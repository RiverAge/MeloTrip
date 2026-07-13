import 'package:melo_trip/update/github_release_parser.dart';

/// Parses the static update manifest uploaded as a GitHub Release asset.
class UpdateManifestParser {
  ParsedUpdateInfo parseManifest({
    required Map<String, dynamic> manifestJson,
    required String platform,
    required String packageType,
  }) {
    final versionName = manifestJson['versionName'] as String?;
    final versionCode = (manifestJson['versionCode'] as num?)?.toInt();
    if (versionName == null || versionName.isEmpty) {
      throw StateError('Update manifest missing versionName.');
    }
    if (versionCode == null || versionCode <= 0) {
      throw StateError('Update manifest has invalid versionCode.');
    }

    final platforms = manifestJson['platforms'] as Map<String, dynamic>?;
    if (platforms == null || platforms.isEmpty) {
      throw StateError('Update manifest missing platforms.');
    }

    final platformPayload = platforms[platform] as Map<String, dynamic>?;
    if (platformPayload == null) {
      throw StateError('Update manifest missing platform=$platform.');
    }

    final manifestPackageType = platformPayload['packageType'] as String?;
    if (manifestPackageType == null || manifestPackageType.isEmpty) {
      throw StateError(
        'Update manifest missing packageType for platform=$platform.',
      );
    }
    // packageType 可能是 `apk.<abi>`（如 `apk.arm64-v8a`）。manifest 顶层记录的
    // 是 universal 包类型（`apk`），两者基础部分必须一致。
    final basePackageType = manifestPackageType.split('.').first;
    if (basePackageType != packageType.split('.').first) {
      throw StateError(
        'Update manifest packageType mismatch for platform=$platform. '
        'expected=$packageType, actual=$manifestPackageType',
      );
    }

    // 传 `apk.<abi>` 且 manifest 有对应 split 条目时优先用 split（小包）；
    // 否则退回 platform 级 universal 条目。
    final abiPayload = _readAbiPayload(platformPayload, packageType);

    final platformVersionCode =
        (abiPayload?['versionCode'] as num?)?.toInt() ??
        (platformPayload['versionCode'] as num?)?.toInt() ??
        versionCode;
    if (platformVersionCode <= 0) {
      throw StateError('Update manifest has invalid platform versionCode.');
    }

    final downloadUrl = _readDownloadUrl(
      manifestJson: manifestJson,
      platformPayload: platformPayload,
      abiPayload: abiPayload,
    );
    final fileSize =
        (abiPayload?['fileSize'] as num?)?.toInt() ??
        (platformPayload['fileSize'] as num?)?.toInt() ??
        (platformPayload['size'] as num?)?.toInt() ??
        0;
    final mirrors = _readMirrors(
      abiPayload ?? platformPayload,
      fallbackUrl: downloadUrl,
    );

    return ParsedUpdateInfo(
      versionName: versionName,
      versionCode: platformVersionCode,
      sha256: (abiPayload?['sha256'] as String?) ??
          (platformPayload['sha256'] as String? ?? ''),
      fileSize: fileSize,
      downloadUrl: downloadUrl,
      changelog: manifestJson['changelog'] as String? ?? '',
      mirrors: mirrors,
    );
  }

  /// 当 [packageType] 形如 `apk.<abi>` 且 manifest 的 `abis` 子映射里有该 ABI
  /// 条目时返回之；否则返回 null（调用方退回 platform 级 universal 条目）。
  Map<String, dynamic>? _readAbiPayload(
    Map<String, dynamic> platformPayload,
    String packageType,
  ) {
    if (!packageType.startsWith('apk.')) {
      return null;
    }
    final abi = packageType.substring('apk.'.length);
    if (abi.isEmpty) {
      return null;
    }
    final abis = platformPayload['abis'];
    if (abis is! Map<String, dynamic>) {
      return null;
    }
    final payload = abis[abi];
    if (payload is! Map<String, dynamic>) {
      return null;
    }
    return payload;
  }

  /// 读取镜像列表。优先取 `mirrors` 数组（过滤空串）；
  /// 为空时退化为 `[downloadUrl]`，保证下游统一按列表处理。
  List<String> _readMirrors(
    Map<String, dynamic> platformPayload, {
    required String fallbackUrl,
  }) {
    final raw = platformPayload['mirrors'];
    if (raw is List<dynamic>) {
      final list = raw
          .whereType<String>()
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(growable: false);
      if (list.isNotEmpty) return list;
    }
    if (fallbackUrl.isNotEmpty) return <String>[fallbackUrl];
    return const <String>[];
  }

  String _readDownloadUrl({
    required Map<String, dynamic> manifestJson,
    required Map<String, dynamic> platformPayload,
    Map<String, dynamic>? abiPayload,
  }) {
    // split 条目可能自带 downloadUrl；否则退到 platform 级。
    final directUrl = abiPayload?['downloadUrl'] as String? ??
        platformPayload['downloadUrl'] as String?;
    if (directUrl != null && directUrl.isNotEmpty) {
      return directUrl;
    }

    final repository = manifestJson['repository'] as String?;
    final tagName = manifestJson['tagName'] as String?;
    // split 条目优先用自己的 assetName（如 app-arm64-v8a-release.apk），
    // 否则用 platform 级 assetName（universal）。
    final assetName = abiPayload?['assetName'] as String? ??
        platformPayload['assetName'] as String?;
    if (repository == null ||
        repository.isEmpty ||
        tagName == null ||
        tagName.isEmpty ||
        assetName == null ||
        assetName.isEmpty) {
      throw StateError('Update manifest missing downloadUrl.');
    }

    return 'https://github.com/$repository/releases/download/$tagName/$assetName';
  }
}
