import 'package:melo_trip/update/app_update_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:update_installer/update_installer.dart';

part 'update_flow.g.dart';
part 'update_flow_download_tracker.dart';
part 'update_flow_models.dart';

@Riverpod(keepAlive: true)
AppUpdateService appUpdateService(Ref ref) {
  return AppUpdateService();
}

@Riverpod(keepAlive: true)
class UpdateFlowController extends _$UpdateFlowController {
  late final AppUpdateService _service;

  @override
  UpdateFlowState build() {
    _service = ref.watch(appUpdateServiceProvider);
    return const UpdateFlowState();
  }

  bool get requiresHostExitForInstall => _service.requiresHostExitForInstall;

  Future<AppUpdateCheckResult> checkForUpdate({bool silent = false}) async {
    state = state.copyWith(
      isChecking: silent ? state.isChecking : true,
      clearCheckError: true,
      clearAvailableUpdate: true,
    );
    try {
      final AppUpdateCheckResult result = await _service.checkForUpdate();
      if (ref.mounted) {
        state = state.copyWith(
          hasChecked: true,
          currentVersionName: result.currentVersionName,
          currentVersionCode: result.currentVersionCode,
          availableUpdate: result.hasUpdate ? result.remote : null,
          clearAvailableUpdate: !result.hasUpdate || result.remote == null,
        );
      }
      return result;
    } catch (err) {
      if (ref.mounted) {
        state = state.copyWith(
          hasChecked: true,
          checkError: '$err',
          clearAvailableUpdate: true,
        );
      }
      rethrow;
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
    final bool canInstall = await _service.canRequestInstallPermission();
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

  Future<String?> downloadAndInstall(
    AppUpdateInfo update, {
    WindowsUpdaterStrings? updaterStrings,
  }) async {
    if (state.isUpdating) return 'Update is already in progress.';

    _beginDownloadFlow(update);
    final tracker = _DownloadProgressTracker();
    try {
      final String packagePath = await _service.downloadAndVerifyPackagePath(
        update: update,
        onStageChanged: (UpdateDownloadStage stage) {
          if (!ref.mounted) return;
          _applyStageUpdate(stage);
        },
        onProgress: (int received, int total, double progress) {
          if (!ref.mounted) return;
          final snapshot = tracker.compute(
            received: received,
            total: total,
            progress: progress,
            currentUiPercent: state.downloadProgressPercent,
          );
          if (snapshot == null) {
            return;
          }
          _applyProgressSnapshot(snapshot, fallbackTotalBytes: update.fileSize);
        },
      );
      if (!ref.mounted) return null;
      _markDownloadCompleted(update);
      await _installDownloadedPackage(
        packagePath,
        update: update,
        updaterStrings: updaterStrings,
      );
      return null;
    } catch (err) {
      _maybeMarkReadyToInstall();
      return '$err';
    } finally {
      _finishUpdateFlow();
    }
  }

  Future<String?> installPendingPackage({
    WindowsUpdaterStrings? updaterStrings,
  }) async {
    final String? packagePath = state.pendingPackagePath;
    if (packagePath == null || packagePath.isEmpty) {
      return 'No downloaded update package is ready.';
    }
    if (state.isUpdating) return 'Update is already in progress.';

    state = state.copyWith(
      isUpdating: true,
      stage: .openingInstaller,
      downloadBytesPerSecond: 0,
      clearEtaSeconds: true,
    );
    try {
      await _service.installDownloadedPackagePath(
        packagePath,
        updaterStrings: updaterStrings,
      );
      return null;
    } catch (err) {
      return '$err';
    } finally {
      if (ref.mounted) {
        state = state.copyWith(
          isUpdating: false,
          stage: .idle,
          clearPendingPackagePath: true,
          clearPendingVersion: true,
        );
      }
    }
  }

  void _beginDownloadFlow(AppUpdateInfo update) {
    state = state.copyWith(
      isUpdating: true,
      downloadProgressPercent: 0,
      downloadedBytes: 0,
      totalBytes: update.fileSize,
      downloadBytesPerSecond: 0,
      clearEtaSeconds: true,
      stage: .downloading,
      clearPendingPackagePath: true,
      clearPendingVersion: true,
      availableUpdate: update,
      clearCheckError: true,
    );
  }

  void _applyStageUpdate(UpdateDownloadStage stage) {
    if (stage == .downloading) {
      state = state.copyWith(stage: .downloading);
      return;
    }
    state = state.copyWith(
      stage: .verifying,
      downloadBytesPerSecond: 0,
      clearEtaSeconds: true,
    );
  }

  void _applyProgressSnapshot(
    _DownloadProgressSnapshot snapshot, {
    required int fallbackTotalBytes,
  }) {
    state = state.copyWith(
      downloadProgressPercent: snapshot.percent,
      downloadedBytes: snapshot.receivedBytes,
      totalBytes: snapshot.totalBytes > 0
          ? snapshot.totalBytes
          : fallbackTotalBytes,
      downloadBytesPerSecond: snapshot.speedBytesPerSecond,
      etaSeconds: snapshot.etaSeconds,
      clearEtaSeconds: snapshot.etaSeconds == null,
    );
  }

  void _markDownloadCompleted(AppUpdateInfo update) {
    state = state.copyWith(
      downloadProgressPercent: 100,
      downloadedBytes: state.totalBytes > 0
          ? state.totalBytes
          : update.fileSize,
    );
  }

  Future<void> _installDownloadedPackage(
    String packagePath, {
    required AppUpdateInfo update,
    required WindowsUpdaterStrings? updaterStrings,
  }) async {
    state = state.copyWith(
      stage: .openingInstaller,
      downloadBytesPerSecond: 0,
      clearEtaSeconds: true,
      pendingPackagePath: _service.requiresHostExitForInstall
          ? packagePath
          : null,
      pendingVersionName: _service.requiresHostExitForInstall
          ? update.versionName
          : null,
      pendingVersionCode: _service.requiresHostExitForInstall
          ? update.versionCode
          : null,
      clearPendingPackagePath: !_service.requiresHostExitForInstall,
      clearPendingVersion: !_service.requiresHostExitForInstall,
    );
    await _service.installDownloadedPackagePath(
      packagePath,
      updaterStrings: updaterStrings,
    );
  }

  void _maybeMarkReadyToInstall() {
    if (!ref.mounted ||
        !_service.requiresHostExitForInstall ||
        state.pendingPackagePath == null) {
      return;
    }
    state = state.copyWith(stage: .readyToInstall);
  }

  void _finishUpdateFlow() {
    if (!ref.mounted) {
      return;
    }
    final bool keepPendingInstall = state.stage == .readyToInstall;
    state = state.copyWith(
      isUpdating: false,
      stage: keepPendingInstall ? .readyToInstall : .idle,
      downloadBytesPerSecond: 0,
      clearEtaSeconds: true,
      clearPendingPackagePath: !keepPendingInstall,
      clearPendingVersion: !keepPendingInstall,
    );
  }
}
