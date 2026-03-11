import 'package:melo_trip/app_logic/app_update_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'update_flow.g.dart';

@Riverpod(keepAlive: true)
AppUpdateService appUpdateService(Ref ref) {
  return AppUpdateService();
}

class UpdateFlowState {
  const UpdateFlowState({
    this.isChecking = false,
    this.isUpdating = false,
    this.downloadProgressPercent = 0,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.downloadBytesPerSecond = 0,
    this.etaSeconds,
    this.stage = UpdateUiStage.idle,
  });

  final bool isChecking;
  final bool isUpdating;
  final double downloadProgressPercent;
  final int downloadedBytes;
  final int totalBytes;
  final double downloadBytesPerSecond;
  final int? etaSeconds;
  final UpdateUiStage stage;

  UpdateFlowState copyWith({
    bool? isChecking,
    bool? isUpdating,
    double? downloadProgressPercent,
    int? downloadedBytes,
    int? totalBytes,
    double? downloadBytesPerSecond,
    int? etaSeconds,
    bool clearEtaSeconds = false,
    UpdateUiStage? stage,
  }) {
    return UpdateFlowState(
      isChecking: isChecking ?? this.isChecking,
      isUpdating: isUpdating ?? this.isUpdating,
      downloadProgressPercent:
          downloadProgressPercent ?? this.downloadProgressPercent,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      downloadBytesPerSecond:
          downloadBytesPerSecond ?? this.downloadBytesPerSecond,
      etaSeconds: clearEtaSeconds ? null : etaSeconds ?? this.etaSeconds,
      stage: stage ?? this.stage,
    );
  }
}

enum UpdateUiStage { idle, downloading, verifying, openingInstaller }

enum InstallCapability { supported, notSupported, permissionRequired }

@Riverpod(keepAlive: true)
class UpdateFlowController extends _$UpdateFlowController {
  late final AppUpdateService _service;

  @override
  UpdateFlowState build() {
    _service = ref.watch(appUpdateServiceProvider);
    return const UpdateFlowState();
  }

  Future<AppUpdateCheckResult> checkForUpdate() async {
    state = state.copyWith(isChecking: true);
    try {
      return await _service.checkForUpdate();
    } finally {
      if (ref.mounted) {
        state = state.copyWith(isChecking: false);
      }
    }
  }

  Future<InstallCapability> getInstallCapability() async {
    if (!_service.isInstallSupported) {
      return InstallCapability.notSupported;
    }
    final canInstall = await _service.canRequestInstallPermission();
    if (!canInstall) {
      return InstallCapability.permissionRequired;
    }
    return InstallCapability.supported;
  }

  Future<void> openInstallPermissionSettings() {
    return _service.openInstallPermissionSettings();
  }

  Future<String?> openDownloadPage(AppUpdateInfo update) async {
    try {
      await _service.openUpdateDownloadPage(update);
      return null;
    } catch (err) {
      return '$err';
    }
  }

  Future<String?> downloadAndInstall(AppUpdateInfo update) async {
    if (state.isUpdating) return 'Update is already in progress.';

    state = state.copyWith(
      isUpdating: true,
      downloadProgressPercent: 0,
      downloadedBytes: 0,
      totalBytes: update.fileSize,
      downloadBytesPerSecond: 0,
      clearEtaSeconds: true,
      stage: UpdateUiStage.downloading,
    );
    var lastReceived = 0;
    DateTime? lastTick;
    DateTime? lastUiTick;
    try {
      final apkFile = await _service.downloadAndVerifyApk(
        update: update,
        onStageChanged: (stage) {
          if (!ref.mounted) return;
          if (stage == UpdateDownloadStage.downloading) {
            state = state.copyWith(stage: UpdateUiStage.downloading);
            return;
          }
          state = state.copyWith(
            stage: UpdateUiStage.verifying,
            downloadBytesPerSecond: 0,
            clearEtaSeconds: true,
          );
        },
        onProgress: (received, total, progress) {
          if (!ref.mounted) return;
          final percent = (progress * 100).clamp(0, 100).toDouble();
          final now = DateTime.now();
          var speed = state.downloadBytesPerSecond;
          if (lastTick != null) {
            final deltaMs = now.difference(lastTick!).inMilliseconds;
            final deltaBytes = received - lastReceived;
            if (deltaMs > 0 && deltaBytes >= 0) {
              final instantSpeed = deltaBytes / (deltaMs / 1000);
              speed = speed <= 0
                  ? instantSpeed
                  : speed * 0.75 + instantSpeed * 0.25;
            }
          }
          final rawEta = speed > 0 && total > 0
              ? ((total - received).clamp(0, total) / speed).ceil()
              : null;
          final eta = rawEta == null ? null : ((rawEta / 5).round() * 5);
          lastTick = now;
          lastReceived = received;
          final shouldThrottle =
              lastUiTick != null &&
              now.difference(lastUiTick!).inMilliseconds < 300 &&
              (percent - state.downloadProgressPercent).abs() < 0.2;
          if (shouldThrottle) return;
          lastUiTick = now;
          state = state.copyWith(
            downloadProgressPercent: percent,
            downloadedBytes: received,
            totalBytes: total > 0 ? total : update.fileSize,
            downloadBytesPerSecond: speed,
            etaSeconds: eta,
            clearEtaSeconds: eta == null,
          );
        },
      );
      if (!ref.mounted) return null;
      state = state.copyWith(
        downloadProgressPercent: 100,
        downloadedBytes: state.totalBytes > 0
            ? state.totalBytes
            : update.fileSize,
      );
      state = state.copyWith(
        stage: UpdateUiStage.openingInstaller,
        downloadBytesPerSecond: 0,
        clearEtaSeconds: true,
      );
      await _service.installDownloadedPackage(apkFile);
      return null;
    } catch (err) {
      return '$err';
    } finally {
      if (ref.mounted) {
        state = state.copyWith(
          isUpdating: false,
          stage: UpdateUiStage.idle,
          downloadBytesPerSecond: 0,
          clearEtaSeconds: true,
        );
      }
    }
  }
}
