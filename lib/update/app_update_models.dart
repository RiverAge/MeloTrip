part of 'app_update_service.dart';

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

enum UpdateDownloadStage { downloading, verifying }
