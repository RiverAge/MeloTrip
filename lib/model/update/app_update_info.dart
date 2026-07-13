import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_update_info.freezed.dart';
part 'app_update_info.g.dart';

@freezed
abstract class AppUpdateInfo with _$AppUpdateInfo {
  const factory AppUpdateInfo({
    required String versionName,
    required int versionCode,
    required String sha256,
    required int fileSize,
    required String downloadUrl,
    required String changelog,
    /// 备用下载镜像列表。客户端按序逐个尝试，失败/校验不过自动切下一个。
    /// 为空时退化成单链下载（用 downloadUrl）。GitHub 直链通常放最后兜底。
    @Default(<String>[]) final List<String> mirrors,
  }) = _AppUpdateInfo;

  factory AppUpdateInfo.fromJson(Map<String, dynamic> json) =>
      _$AppUpdateInfoFromJson(json);
}

@freezed
abstract class AppUpdateCheckResult with _$AppUpdateCheckResult {
  const factory AppUpdateCheckResult({
    required String currentVersionName,
    required int currentVersionCode,
    required AppUpdateInfo? remote,
    required bool hasUpdate,
  }) = _AppUpdateCheckResult;
}

enum UpdateDownloadStage { downloading, verifying }
