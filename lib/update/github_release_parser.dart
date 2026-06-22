/// Parses GitHub Release API response and extracts update metadata.
///
/// Supports two metadata formats:
/// 1. New format: MELOTRIP_UPDATE_METADATA block with per-platform asset info
/// 2. Old format: METADATA block (backward compatibility for Android APK only)
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

    final versionName = metadata.versionName ?? _extractVersionFromTag(tagName);
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

  /// Parses the metadata block from release body.
  ///
  /// Supports both MELOTRIP_UPDATE_METADATA and legacy METADATA formats.
  ReleaseMetadata _parseMetadataBlock(String body) {
    // Try new format first
    final newMetadata = _parseNewMetadataFormat(body);
    if (newMetadata != null) {
      return newMetadata;
    }

    // Fall back to legacy format
    final legacyMetadata = _parseLegacyMetadataFormat(body);
    if (legacyMetadata != null) {
      return legacyMetadata;
    }

    return ReleaseMetadata();
  }

  /// Parses the new MELOTRIP_UPDATE_METADATA format.
  ReleaseMetadata? _parseNewMetadataFormat(String body) {
    const startMarker = '<!-- MELOTRIP_UPDATE_METADATA';
    const endMarker = 'MELOTRIP_UPDATE_METADATA -->';

    final startIndex = body.indexOf(startMarker);
    if (startIndex == -1) return null;

    final endIndex = body.indexOf(endMarker, startIndex);
    if (endIndex == -1) return null;

    final content = body.substring(startIndex + startMarker.length, endIndex);

    final lines = content
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty);

    String? versionName;
    int? versionCode;
    final platformAssets = <String, PlatformAssetInfo>{};

    for (final line in lines) {
      if (line.startsWith('versionName=')) {
        versionName = line.substring('versionName='.length);
      } else if (line.startsWith('versionCode=')) {
        versionCode = int.tryParse(line.substring('versionCode='.length));
      } else if (line.startsWith('versionCode.')) {
        _parseVersionCodeLine(line, platformAssets);
      } else if (line.startsWith('asset.')) {
        _parseAssetLine(line, platformAssets);
      } else if (line.startsWith('sha256.')) {
        _parseSha256Line(line, platformAssets);
      } else if (line.startsWith('size.')) {
        _parseSizeLine(line, platformAssets);
      }
    }

    return ReleaseMetadata(
      versionName: versionName,
      versionCode: versionCode,
      platformAssets: platformAssets,
    );
  }

  void _parseAssetLine(
    String line,
    Map<String, PlatformAssetInfo> platformAssets,
  ) {
    // Format: asset.<platform>.<ext>=<filename>
    // e.g., asset.android.apk=app-release.apk
    // ext can contain dots, e.g., asset.linux.tar.gz=melotrip-linux.tar.gz
    final eqIndex = line.indexOf('=');
    if (eqIndex == -1) return;

    final key = line.substring('asset.'.length, eqIndex);
    final value = line.substring(eqIndex + 1);

    // Split by first dot only to allow ext with dots like "tar.gz"
    final firstDotIndex = key.indexOf('.');
    if (firstDotIndex == -1) return;

    final platform = key.substring(0, firstDotIndex);
    final packageType = key.substring(firstDotIndex + 1);

    if (platform.isEmpty || packageType.isEmpty) return;

    final infoKey = '$platform.$packageType';

    platformAssets[infoKey] = (platformAssets[infoKey] ?? PlatformAssetInfo())
        .copyWith(assetName: value);
  }

  void _parseVersionCodeLine(
    String line,
    Map<String, PlatformAssetInfo> platformAssets,
  ) {
    // Format: versionCode.<platform>.<ext>=<code>
    final eqIndex = line.indexOf('=');
    if (eqIndex == -1) return;

    final key = line.substring('versionCode.'.length, eqIndex);
    final value = int.tryParse(line.substring(eqIndex + 1));
    if (value == null) return;

    platformAssets[key] = (platformAssets[key] ?? PlatformAssetInfo()).copyWith(
      versionCode: value,
    );
  }

  void _parseSha256Line(
    String line,
    Map<String, PlatformAssetInfo> platformAssets,
  ) {
    // Format: sha256.<platform>.<ext>=<hash>
    final eqIndex = line.indexOf('=');
    if (eqIndex == -1) return;

    final key = line.substring('sha256.'.length, eqIndex);
    final value = line.substring(eqIndex + 1);

    final infoKey = key;
    platformAssets[infoKey] = (platformAssets[infoKey] ?? PlatformAssetInfo())
        .copyWith(sha256: value);
  }

  void _parseSizeLine(
    String line,
    Map<String, PlatformAssetInfo> platformAssets,
  ) {
    // Format: size.<platform>.<ext>=<bytes>
    final eqIndex = line.indexOf('=');
    if (eqIndex == -1) return;

    final key = line.substring('size.'.length, eqIndex);
    final value = int.tryParse(line.substring(eqIndex + 1));

    if (value == null) return;

    final infoKey = key;
    platformAssets[infoKey] = (platformAssets[infoKey] ?? PlatformAssetInfo())
        .copyWith(size: value);
  }

  /// Parses the legacy METADATA format (Android APK only).
  ReleaseMetadata? _parseLegacyMetadataFormat(String body) {
    const startMarker = '<!-- METADATA';
    const endMarker = 'METADATA -->';

    final startIndex = body.indexOf(startMarker);
    if (startIndex == -1) return null;

    final endIndex = body.indexOf(endMarker, startIndex);
    if (endIndex == -1) return null;

    final content = body.substring(startIndex + startMarker.length, endIndex);

    final lines = content
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty);

    String? versionName;
    int? versionCode;
    String? sha256;
    int? size;

    for (final line in lines) {
      if (line.startsWith('Version:')) {
        versionName = line.substring('Version:'.length).trim();
      } else if (line.startsWith('Build:')) {
        versionCode = int.tryParse(line.substring('Build:'.length).trim());
      } else if (line.startsWith('SHA256:')) {
        sha256 = line.substring('SHA256:'.length).trim();
      } else if (line.startsWith('Size:')) {
        size = int.tryParse(line.substring('Size:'.length).trim());
      }
    }

    if (versionName == null || versionCode == null) return null;

    // Legacy format only supports Android APK
    final platformAssets = <String, PlatformAssetInfo>{};
    if (sha256 != null || size != null) {
      platformAssets['android.apk'] = PlatformAssetInfo(
        sha256: sha256 ?? '',
        size: size ?? 0,
      );
    }

    return ReleaseMetadata(
      versionName: versionName,
      versionCode: versionCode,
      platformAssets: platformAssets,
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

  /// Extracts version name from a git tag (e.g., "v1.0.10" -> "1.0.10").
  String _extractVersionFromTag(String tag) {
    if (tag.startsWith('v')) {
      return tag.substring(1);
    }
    return tag;
  }

  /// Extracts changelog from release body by removing metadata blocks.
  String _extractChangelog(String body) {
    var changelog = body;

    // Remove new metadata block
    const newStart = '<!-- MELOTRIP_UPDATE_METADATA';
    const newEnd = 'MELOTRIP_UPDATE_METADATA -->';
    final newStartIndex = changelog.indexOf(newStart);
    if (newStartIndex != -1) {
      final newEndIndex = changelog.indexOf(newEnd, newStartIndex);
      if (newEndIndex != -1) {
        changelog = changelog.replaceRange(
          newStartIndex,
          newEndIndex + newEnd.length,
          '',
        );
      }
    }

    // Remove legacy metadata block
    const legacyStart = '<!-- METADATA';
    const legacyEnd = 'METADATA -->';
    final legacyStartIndex = changelog.indexOf(legacyStart);
    if (legacyStartIndex != -1) {
      final legacyEndIndex = changelog.indexOf(legacyEnd, legacyStartIndex);
      if (legacyEndIndex != -1) {
        changelog = changelog.replaceRange(
          legacyStartIndex,
          legacyEndIndex + legacyEnd.length,
          '',
        );
      }
    }

    return changelog.trim();
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
  });

  final String versionName;
  final int versionCode;
  final String sha256;
  final int fileSize;
  final String downloadUrl;
  final String changelog;
}
