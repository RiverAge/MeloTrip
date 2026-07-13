import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:melo_trip/model/update/app_update_info.dart';
import 'package:melo_trip/update/github_release_parser.dart';
import 'package:melo_trip/update/update_installer_gateway.dart';
import 'package:melo_trip/update/update_manifest_parser.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:update_installer/update_installer.dart';

export 'package:melo_trip/model/update/app_update_info.dart';

part 'parts/download.dart';

class AppUpdateService {
  AppUpdateService({
    this.manifestUrl =
        'https://github.com/RiverAge/MeloTrip/releases/latest/download/update.json',
    this.checkUrl =
        'https://api.github.com/repos/RiverAge/MeloTrip/releases/latest',
    Dio? dio,
    UpdateInstallerGateway? installerGateway,
  }) : _dio = dio ?? Dio(),
       _installerGateway = installerGateway ?? UpdateInstallerGateway.auto();

  final String manifestUrl;
  final String checkUrl;
  final Dio _dio;
  final UpdateInstallerGateway _installerGateway;
  final GitHubReleaseParser _releaseParser = GitHubReleaseParser();
  final UpdateManifestParser _manifestParser = UpdateManifestParser();

  bool get isInstallSupported => _installerGateway.isSupported;

  bool get requiresHostExitForInstall =>
      _installerGateway.requiresHostExitForInstall;

  /// 用于下载文件名扩展等场景的基础包类型（apk/zip/tar.gz），不含 ABI。
  String get expectedPackageType => _defaultPackageType();

  Future<bool> canRequestInstallPermission() {
    return _installerGateway.canRequestInstallPermission();
  }

  Future<void> openInstallPermissionSettings() {
    return _installerGateway.openInstallPermissionSettings();
  }

  Future<void> installDownloadedPackage(
    File file, {
    WindowsUpdaterStrings? updaterStrings,
  }) {
    return _installerGateway.installPackage(
      file.path,
      updaterStrings: updaterStrings,
    );
  }

  Future<void> installDownloadedPackagePath(
    String filePath, {
    WindowsUpdaterStrings? updaterStrings,
  }) {
    return _installerGateway.installPackage(
      filePath,
      updaterStrings: updaterStrings,
    );
  }

  Future<void> openUpdateDownloadPage(AppUpdateInfo update) async {
    final rawUrl = update.downloadUrl.trim();
    if (rawUrl.isEmpty) {
      throw StateError('Download URL is empty.');
    }
    final uri = Uri.tryParse(rawUrl);
    if (uri == null || !uri.hasScheme) {
      throw StateError('Invalid download URL: $rawUrl');
    }

    if (kIsWeb) {
      throw UnsupportedError(
        'Open download page is unsupported on this platform.',
      );
    }
    if (defaultTargetPlatform == .windows) {
      final result = await Process.run('cmd', <String>[
        '/c',
        'start',
        '',
        rawUrl,
      ]);
      if (result.exitCode != 0) {
        throw StateError('Failed to open URL on Windows: ${result.stderr}');
      }
      return;
    }
    if (defaultTargetPlatform == .linux) {
      final result = await Process.run('xdg-open', <String>[rawUrl]);
      if (result.exitCode != 0) {
        throw StateError('Failed to open URL on Linux: ${result.stderr}');
      }
      return;
    }
    if (defaultTargetPlatform == .macOS) {
      final result = await Process.run('open', <String>[rawUrl]);
      if (result.exitCode != 0) {
        throw StateError('Failed to open URL on macOS: ${result.stderr}');
      }
      return;
    }

    throw UnsupportedError(
      'Open download page is unsupported on this platform.',
    );
  }

  Future<AppUpdateCheckResult> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;
    // Android 上带 ABI 选 split 包（如 apk.arm64-v8a），避免下载 universal 大包；
    // 拿不到 ABI 时退回基础类型，由 parser 选 universal 兜底条目。
    final packageType = await _expectedPackageTypeForCheck();
    ParsedUpdateInfo parsedInfo;
    try {
      parsedInfo = await _fetchManifestUpdateInfo(packageType: packageType);
    } catch (manifestError) {
      try {
        parsedInfo = await _fetchGitHubReleaseUpdateInfo(
          packageType: packageType,
        );
      } catch (apiError) {
        throw StateError(
          'Update check failed. '
          'manifestUrl=$manifestUrl, '
          'manifestError=${_summarizeUpdateCheckError(manifestError)}; '
          'apiUrl=$checkUrl, '
          'apiError=${_summarizeUpdateCheckError(apiError)}',
        );
      }
    }

    final remote = AppUpdateInfo(
      versionName: parsedInfo.versionName,
      versionCode: parsedInfo.versionCode,
      sha256: parsedInfo.sha256,
      fileSize: parsedInfo.fileSize,
      downloadUrl: parsedInfo.downloadUrl,
      changelog: parsedInfo.changelog,
      mirrors: parsedInfo.mirrors,
    );

    if (remote.versionCode <= 0 || remote.downloadUrl.isEmpty) {
      throw StateError('Invalid update payload.');
    }

    return AppUpdateCheckResult(
      currentVersionName: packageInfo.version,
      currentVersionCode: currentVersionCode,
      remote: remote,
      hasUpdate: remote.versionCode > currentVersionCode,
    );
  }

  Future<ParsedUpdateInfo> _fetchManifestUpdateInfo({
    required String packageType,
  }) async {
    final payload = await _getJsonMap(
      manifestUrl,
      headers: const <String, String>{
        'User-Agent': 'MeloTrip-App',
        'Accept': 'application/json, */*',
      },
    );
    return _manifestParser.parseManifest(
      manifestJson: payload,
      platform: _currentPlatformName(),
      packageType: packageType,
    );
  }

  Future<ParsedUpdateInfo> _fetchGitHubReleaseUpdateInfo({
    required String packageType,
  }) async {
    final payload = await _getJsonMap(
      checkUrl,
      headers: const <String, String>{
        'User-Agent': 'MeloTrip-App',
        'Accept': 'application/vnd.github.v3+json',
      },
    );
    return _releaseParser.parseRelease(
      releaseJson: payload,
      platform: _currentPlatformName(),
      packageType: packageType,
    );
  }

  Future<Map<String, dynamic>> _getJsonMap(
    String url, {
    required Map<String, String> headers,
  }) async {
    final response = await _dio.get<dynamic>(
      url,
      options: Options(responseType: ResponseType.plain, headers: headers),
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is String) {
      final decoded = jsonDecode(data);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    }
    throw StateError('Expected JSON object from $url.');
  }

  Future<File> downloadAndVerifyApk({
    required AppUpdateInfo update,
    void Function(int received, int total, double progress)? onProgress,
    void Function(UpdateDownloadStage stage)? onStageChanged,
    void Function(int mirrorIndex, int total)? onMirrorChanged,
  }) {
    return downloadAndVerifyPackage(
      update: update,
      onProgress: onProgress,
      onStageChanged: onStageChanged,
      onMirrorChanged: onMirrorChanged,
    );
  }

  Future<File> downloadAndVerifyPackage({
    required AppUpdateInfo update,
    void Function(int received, int total, double progress)? onProgress,
    void Function(UpdateDownloadStage stage)? onStageChanged,
    void Function(int mirrorIndex, int total)? onMirrorChanged,
  }) {
    if (update.downloadUrl.isEmpty) {
      throw StateError('Download URL is empty.');
    }

    return _downloadAndVerifyPackage(
      update: update,
      onProgress: onProgress,
      onStageChanged: onStageChanged,
      onMirrorChanged: onMirrorChanged,
    );
  }

  Future<String> downloadAndVerifyPackagePath({
    required AppUpdateInfo update,
    void Function(int received, int total, double progress)? onProgress,
    void Function(UpdateDownloadStage stage)? onStageChanged,
    void Function(int mirrorIndex, int total)? onMirrorChanged,
  }) async {
    final file = await downloadAndVerifyPackage(
      update: update,
      onProgress: onProgress,
      onStageChanged: onStageChanged,
      onMirrorChanged: onMirrorChanged,
    );
    return file.path;
  }

  /// 删除已下载的安装包（安装成功后 / 重新检查更新时清理）。
  Future<void> deleteDownloadedPackage(AppUpdateInfo? update) {
    return _deleteDownloadedPackage(update);
  }

  String _buildDownloadFileName(AppUpdateInfo update) {
    final uri = Uri.tryParse(update.downloadUrl);
    final candidate = uri == null ? '' : p.basename(uri.path);
    if (candidate.isNotEmpty && candidate.contains('.')) {
      return candidate;
    }

    return 'melotrip-${update.versionName}+${update.versionCode}'
        '${_defaultPackageExtension()}';
  }

  String _defaultPackageExtension() {
    if (!kIsWeb && defaultTargetPlatform == .windows) {
      return '.zip';
    }
    if (!kIsWeb && defaultTargetPlatform == .linux) {
      return '.tar.gz';
    }
    if (!kIsWeb && defaultTargetPlatform == .macOS) {
      return '.zip';
    }
    return '.apk';
  }

  String _defaultPackageType() {
    final extension = _defaultPackageExtension();
    if (extension.startsWith('.')) {
      return extension.substring(1);
    }
    return extension;
  }

  /// 用于检查更新时的包类型：Android 上拼成本机 ABI（如 `apk.arm64-v8a`），
  /// 让 parser 从 split-per-abi 产物里选对应包；拿不到 ABI 或非 Android 时
  /// 返回基础类型（`apk`/`zip`/...），由 parser 选 universal 兜底。
  Future<String> _expectedPackageTypeForCheck() async {
    final base = _defaultPackageType();
    if (base != 'apk') {
      return base;
    }
    final abi = await _installerGateway.deviceAbi;
    if (abi == null || abi.isEmpty) {
      return base;
    }
    return 'apk.$abi';
  }

  String _currentPlatformName() {
    if (kIsWeb) {
      return 'web';
    }
    if (defaultTargetPlatform == .windows) {
      return 'windows';
    }
    if (defaultTargetPlatform == .macOS) {
      return 'macos';
    }
    if (defaultTargetPlatform == .linux) {
      return 'linux';
    }
    if (defaultTargetPlatform == .android) {
      return 'android';
    }
    if (defaultTargetPlatform == .iOS) {
      return 'ios';
    }
    return 'unknown';
  }

  String _summarizeUpdateCheckError(dynamic error) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final responseData = error.response?.data;
      return 'DioException(statusCode=$statusCode, '
          'message=${error.message}, response=${_stringifyResponseData(responseData)})';
    }
    return '$error';
  }

  String _stringifyResponseData(dynamic data) {
    if (data == null) {
      return '';
    }
    final text = data is String ? data : data.toString();
    const maxLength = 300;
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }
}
