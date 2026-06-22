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
    if (manifestPackageType != packageType) {
      throw StateError(
        'Update manifest packageType mismatch for platform=$platform. '
        'expected=$packageType, actual=$manifestPackageType',
      );
    }

    final downloadUrl = _readDownloadUrl(
      manifestJson: manifestJson,
      platformPayload: platformPayload,
    );
    final fileSize =
        (platformPayload['fileSize'] as num?)?.toInt() ??
        (platformPayload['size'] as num?)?.toInt() ??
        0;

    return ParsedUpdateInfo(
      versionName: versionName,
      versionCode: versionCode,
      sha256: platformPayload['sha256'] as String? ?? '',
      fileSize: fileSize,
      downloadUrl: downloadUrl,
      changelog: manifestJson['changelog'] as String? ?? '',
    );
  }

  String _readDownloadUrl({
    required Map<String, dynamic> manifestJson,
    required Map<String, dynamic> platformPayload,
  }) {
    final downloadUrl = platformPayload['downloadUrl'] as String?;
    if (downloadUrl != null && downloadUrl.isNotEmpty) {
      return downloadUrl;
    }

    final repository = manifestJson['repository'] as String?;
    final tagName = manifestJson['tagName'] as String?;
    final assetName = platformPayload['assetName'] as String?;
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
