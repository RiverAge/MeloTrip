import 'dart:async';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:melo_trip/app_logic/android_apk_installer.dart';
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

  Future<bool> canRequestInstallPermission() {
    return _installerGateway.canRequestInstallPermission();
  }

  Future<void> openInstallPermissionSettings() {
    return _installerGateway.openInstallPermissionSettings();
  }

  Future<void> installDownloadedPackage(File file) {
    return _installerGateway.installPackage(file.path);
  }

  Future<AppUpdateCheckResult> checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersionCode = int.tryParse(packageInfo.buildNumber) ?? 0;
    final response = await Dio().get<Map<String, dynamic>>(
      checkUrl,
      options: Options(
        headers: const {
          'User-Agent': 'MeloTrip-App',
          'Accept': 'application/json',
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
    if (update.downloadUrl.isEmpty) {
      throw StateError('Download URL is empty.');
    }

    return _downloadAndVerifyApk(
      update: update,
      onProgress: onProgress,
      onStageChanged: onStageChanged,
    );
  }

  Future<File> _downloadAndVerifyApk({
    required AppUpdateInfo update,
    void Function(int received, int total, double progress)? onProgress,
    void Function(UpdateDownloadStage stage)? onStageChanged,
  }) async {
    final dir = await getTemporaryDirectory();
    final filePath = p.join(
      dir.path,
      'melotrip-${update.versionName}+${update.versionCode}.apk',
    );
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
        headers: const {
          'User-Agent': 'MeloTrip-App',
          'Accept': 'application/vnd.android.package-archive,*/*',
        },
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
}

enum UpdateDownloadStage { downloading, verifying }
