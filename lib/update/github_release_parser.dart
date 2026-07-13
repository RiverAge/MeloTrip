part 'parts/release_metadata_parsing.dart';

/// Parses GitHub Release API response and extracts update metadata.
///
/// Supports two metadata formats:
/// 1. New format: MELOTRIP_UPDATE_METADATA block with per-platform asset info
/// 2. Old format: METADATA block (backward compatibility for Android APK only)
///
/// Metadata block parsing / changelog extraction 由 part
/// `parts/release_metadata_parsing.dart` 中的 extension 提供，
/// 通过 `this._parseMetadataBlock` 等调用，避免主文件超行数限制。
class GitHubReleaseParser {
  /// Parses a GitHub Release API response and returns a [ParsedUpdateInfo].
  ///
  /// [releaseJson] is the JSON response from GitHub Release API.
  /// [platform] is the current platform name (windows, linux, macos, android).
  /// [packageType] is the expected package type (zip, tar.gz, apk).
  ///
  /// Throws [StateError] if the response is invalid or missing required data.
  ParsedUpdateInfo parseRelease({
    required Map<String, dynamic> releaseJson,
    required String platform,
    required String packageType,
  }) {
    final tagName = releaseJson['tag_name'] as String?;
    if (tagName == null || tagName.isEmpty) {
      throw StateError('GitHub Release missing tag_name.');
    }

    final body = releaseJson['body'] as String? ?? '';
    final metadata = _parseMetadataBlock(body);

    final assets = releaseJson['assets'] as List<dynamic>?;
    if (assets == null || assets.isEmpty) {
      throw StateError('GitHub Release has no assets.');
    }

    final assetInfo = _selectAsset(
      assets: assets,
      metadata: metadata,
      platform: platform,
      packageType: packageType,
    );

    final versionName =
        metadata.versionName ?? _extractVersionFromTag(tagName);
    final versionCode = assetInfo.versionCode ?? metadata.versionCode ?? 0;
    if (versionCode <= 0) {
      throw StateError('Invalid version code in release metadata.');
    }

    final changelog = _extractChangelog(body);

    return ParsedUpdateInfo(
      versionName: versionName,
      versionCode: versionCode,
      sha256: assetInfo.sha256,
      fileSize: assetInfo.size,
      downloadUrl: assetInfo.downloadUrl,
      changelog: changelog,
    );
  }

  /// Selects the appropriate asset for the current platform.
  SelectedAssetInfo _selectAsset({
    required List<dynamic> assets,
    required ReleaseMetadata metadata,
    required String platform,
    required String packageType,
  }) {
    final infoKey = '$platform.$packageType';
    final platformAssetInfo = metadata.platformAssets[infoKey];
    final expectedAssetName =
        platformAssetInfo?.assetName ??
        _defaultAssetName(platform, packageType);

    // Find matching asset
    for (final asset in assets) {
      final assetMap = asset as Map<String, dynamic>;
      final name = assetMap['name'] as String?;
      if (name == expectedAssetName) {
        final downloadUrl = assetMap['browser_download_url'] as String?;
        final assetSize = (assetMap['size'] as num?)?.toInt() ?? 0;

        if (downloadUrl == null || downloadUrl.isEmpty) {
          throw StateError('Asset "$name" missing browser_download_url.');
        }

        return SelectedAssetInfo(
          downloadUrl: downloadUrl,
          versionCode: platformAssetInfo?.versionCode,
          sha256: platformAssetInfo?.sha256 ?? '',
          size: (platformAssetInfo?.size ?? 0) > 0
              ? platformAssetInfo!.size
              : assetSize,
        );
      }
    }

    throw StateError(
      'No asset found for platform=$platform, packageType=$packageType. '
      'Expected: $expectedAssetName',
    );
  }

  /// Returns the default asset name for a platform and package type.
  String _defaultAssetName(String platform, String packageType) {
    switch (platform) {
      case 'windows':
        return 'melotrip-windows-x64.zip';
      case 'linux':
        return 'melotrip-linux-x64.tar.gz';
      case 'macos':
        return 'melotrip-macos.zip';
      case 'android':
        return 'app-release.apk';
      default:
        return 'app-release.$packageType';
    }
  }
}

/// Holds parsed metadata from release body.
class ReleaseMetadata {
  ReleaseMetadata({
    this.versionName,
    this.versionCode,
    this.platformAssets = const {},
  });

  final String? versionName;
  final int? versionCode;
  final Map<String, PlatformAssetInfo> platformAssets;
}

/// Holds per-platform asset info from metadata.
class PlatformAssetInfo {
  PlatformAssetInfo({
    this.assetName,
    this.versionCode,
    this.sha256 = '',
    this.size = 0,
  });

  final String? assetName;
  final int? versionCode;
  final String sha256;
  final int size;

  PlatformAssetInfo copyWith({
    String? assetName,
    int? versionCode,
    String? sha256,
    int? size,
  }) {
    return PlatformAssetInfo(
      assetName: assetName ?? this.assetName,
      versionCode: versionCode ?? this.versionCode,
      sha256: sha256 ?? this.sha256,
      size: size ?? this.size,
    );
  }
}

/// Holds selected asset info for download.
class SelectedAssetInfo {
  SelectedAssetInfo({
    required this.downloadUrl,
    this.versionCode,
    required this.sha256,
    required this.size,
  });

  final String downloadUrl;
  final int? versionCode;
  final String sha256;
  final int size;
}

/// Parsed update info ready to be converted to AppUpdateInfo.
class ParsedUpdateInfo {
  const ParsedUpdateInfo({
    required this.versionName,
    required this.versionCode,
    required this.sha256,
    required this.fileSize,
    required this.downloadUrl,
    required this.changelog,
    this.mirrors = const <String>[],
  });

  final String versionName;
  final int versionCode;
  final String sha256;
  final int fileSize;
  final String downloadUrl;
  final String changelog;
  /// 备用镜像列表。GitHub API 分支无此信息，默认空列表
  /// （调用方退化成单链 downloadUrl）。
  final List<String> mirrors;
}
