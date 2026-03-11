import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:melo_trip/update/update_installer_gateway.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdateInfo {
  const AppUpdateInfo({
    required this.versionName,
    required this.versionCode,
    required this.sha256,
    required this.fileSize,
    required this.downloadUrl,
    required this.changelog,
  });

  factory AppUpdateInfo.fromJson(Map<String, dynamic> json) {
    return AppUpdateInfo(
      versionName: (json['versionName'] ?? '').toString(),
      versionCode: _toInt(json['versionCode']),
      sha256: (json['sha256'] ?? '').toString(),
      fileSize: _toInt(json['fileSize']),
      downloadUrl: (json['downloadUrl'] ?? '').toString(),
      changelog: (json['changelog'] ?? '').toString(),
    );
  }

  final String versionName;
  final int versionCode;
  final String sha256;
  final int fileSize;
  final String downloadUrl;
  final String changelog;

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value') ?? 0;
  }
}

class AppUpdateCheckResult {
  const AppUpdateCheckResult({
    required this.currentVersionName,
    required this.currentVersionCode,
    required this.remote,
    required this.hasUpdate,
  });

  final String currentVersionName;
  final int currentVersionCode;
  final AppUpdateInfo? remote;
  final bool hasUpdate;
}

class AppUpdateService {
  AppUpdateService({
    this.checkUrl = 'https://melotrip.587626.xyz/check',
    UpdateInstallerGateway? installerGateway,
  }) : _installerGateway = installerGateway ?? UpdateInstallerGateway.auto();

  final String checkUrl;
  final UpdateInstallerGateway _installerGateway;

  bool get isInstallSupported => _installerGateway.isSupported;

  bool get requiresHostExitForInstall =>
      _installerGateway.requiresHostExitForInstall;

  String get expectedPackageType => _defaultPackageType();

  Future<bool> canRequestInstallPermission() {
    return _installerGateway.canRequestInstallPermission();
  }

  Future<void> openInstallPermissionSettings() {
    return _installerGateway.openInstallPermissionSettings();
  }

  Future<void> installDownloadedPackage(File file) {
    return _installerGateway.installPackage(file.path);
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

    if (Platform.isWindows) {
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
    if (Platform.isLinux) {
      final result = await Process.run('xdg-open', <String>[rawUrl]);
      if (result.exitCode != 0) {
        throw StateError('Failed to open URL on Linux: ${result.stderr}');
      }
      return;
    }
    if (Platform.isMacOS) {
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
    final response = await Dio().get<Map<String, dynamic>>(
      checkUrl,
      options: Options(
        headers: <String, Object>{
          'User-Agent': 'MeloTrip-App',
          'Accept': 'application/json',
          'X-MeloTrip-Platform': _currentPlatformName(),
          'X-MeloTrip-Package-Type': expectedPackageType,
        },
      ),
    );

    final payload = response.data;
    if (payload == null) {
      throw StateError('Empty update response.');
    }

    final remote = AppUpdateInfo.fromJson(payload);
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

  Future<File> downloadAndVerifyApk({
    required AppUpdateInfo update,
    void Function(int received, int total, double progress)? onProgress,
    void Function(UpdateDownloadStage stage)? onStageChanged,
  }) {
    return downloadAndVerifyPackage(
      update: update,
      onProgress: onProgress,
      onStageChanged: onStageChanged,
    );
  }

  Future<File> downloadAndVerifyPackage({
    required AppUpdateInfo update,
    void Function(int received, int total, double progress)? onProgress,
    void Function(UpdateDownloadStage stage)? onStageChanged,
  }) {
    if (update.downloadUrl.isEmpty) {
      throw StateError('Download URL is empty.');
    }

    return _downloadAndVerifyPackage(
      update: update,
      onProgress: onProgress,
      onStageChanged: onStageChanged,
    );
  }

  Future<File> _downloadAndVerifyPackage({
    required AppUpdateInfo update,
    void Function(int received, int total, double progress)? onProgress,
    void Function(UpdateDownloadStage stage)? onStageChanged,
  }) async {
    final dir = await getTemporaryDirectory();
    final filePath = p.join(dir.path, _buildDownloadFileName(update));
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }

    onStageChanged?.call(UpdateDownloadStage.downloading);
    await Dio().download(
      update.downloadUrl,
      filePath,
      options: Options(
        responseType: ResponseType.bytes,
        headers: const {'User-Agent': 'MeloTrip-App', 'Accept': '*/*'},
      ),
      onReceiveProgress: (received, total) {
        final effectiveTotal = total > 0 ? total : update.fileSize;
        if (effectiveTotal <= 0) {
          onProgress?.call(received, 0, 0);
          return;
        }
        final progress = (received / effectiveTotal).clamp(0, 1).toDouble();
        onProgress?.call(received, effectiveTotal, progress);
      },
    );

    final length = await file.length();
    if (length <= 0) {
      throw StateError('Downloaded file is empty.');
    }
    if (update.fileSize > 0 && length != update.fileSize) {
      throw StateError(
        'File size mismatch. expected=${update.fileSize}, actual=$length',
      );
    }

    onStageChanged?.call(UpdateDownloadStage.verifying);
    final checksum = update.sha256.trim().toLowerCase();
    if (checksum.isNotEmpty) {
      final digest = await sha256.bind(file.openRead()).first;
      final actual = digest.toString().toLowerCase();
      if (actual != checksum) {
        throw StateError('SHA256 mismatch. expected=$checksum, actual=$actual');
      }
    }

    return file;
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
    if (Platform.isWindows) {
      return '.zip';
    }
    if (Platform.isLinux) {
      return '.tar.gz';
    }
    if (Platform.isMacOS) {
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

  String _currentPlatformName() {
    if (Platform.isWindows) {
      return 'windows';
    }
    if (Platform.isMacOS) {
      return 'macos';
    }
    if (Platform.isLinux) {
      return 'linux';
    }
    if (Platform.isAndroid) {
      return 'android';
    }
    if (Platform.isIOS) {
      return 'ios';
    }
    return 'unknown';
  }
}

enum UpdateDownloadStage { downloading, verifying }
