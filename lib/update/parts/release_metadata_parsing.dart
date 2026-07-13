part of '../github_release_parser.dart';

/// GitHub Release body 的 metadata 块解析与 changelog 提取。
///
/// 拆分到 part 以保持 [GitHubReleaseParser] 主文件在行数限制内。
/// 仅含私有方法，由 [GitHubReleaseParser.parseRelease] 调用。
/// 处于同一库（part of），可访问 `ReleaseMetadata`、`PlatformAssetInfo` 等。
extension GitHubReleaseMetadataParsing on GitHubReleaseParser {
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
