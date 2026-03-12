import 'dart:io';

import 'package:melo_trip/update/app_update_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:update_installer/update_installer.dart';

part 'update_flow.g.dart';
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
      clearPendingPackagePath: true,
      clearPendingVersion: true,
      availableUpdate: update,
      clearCheckError: true,
    );
    var lastReceived = 0;
    DateTime? lastTick;
    DateTime? lastUiTick;
    try {
      final File packageFile = await _service.downloadAndVerifyPackage(
        update: update,
        onStageChanged: (UpdateDownloadStage stage) {
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
        onProgress: (int received, int total, double progress) {
          if (!ref.mounted) return;
          final double percent = (progress * 100).clamp(0, 100).toDouble();
          final DateTime now = DateTime.now();
          var speed = state.downloadBytesPerSecond;
          if (lastTick != null) {
            final int deltaMs = now.difference(lastTick!).inMilliseconds;
            final int deltaBytes = received - lastReceived;
            if (deltaMs > 0 && deltaBytes >= 0) {
              final double instantSpeed = deltaBytes / (deltaMs / 1000);
              speed = speed <= 0
                  ? instantSpeed
                  : speed * 0.75 + instantSpeed * 0.25;
            }
          }
          final int? rawEta = speed > 0 && total > 0
              ? ((total - received).clamp(0, total) / speed).ceil()
              : null;
          final int? eta = rawEta == null ? null : ((rawEta / 5).round() * 5);
          lastTick = now;
          lastReceived = received;
          final bool shouldThrottle =
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
      if (_service.requiresHostExitForInstall) {
        state = state.copyWith(
          isUpdating: false,
          stage: UpdateUiStage.readyToInstall,
          downloadBytesPerSecond: 0,
          clearEtaSeconds: true,
          pendingPackagePath: packageFile.path,
          pendingVersionName: update.versionName,
          pendingVersionCode: update.versionCode,
        );
        return null;
      }
      state = state.copyWith(
        stage: UpdateUiStage.openingInstaller,
        downloadBytesPerSecond: 0,
        clearEtaSeconds: true,
      );
      await _service.installDownloadedPackage(packageFile);
      return null;
    } catch (err) {
      return '$err';
    } finally {
      if (ref.mounted) {
        state = state.copyWith(
          isUpdating: false,
          stage: state.stage == UpdateUiStage.readyToInstall
              ? UpdateUiStage.readyToInstall
              : UpdateUiStage.idle,
          downloadBytesPerSecond: 0,
          clearEtaSeconds: true,
          clearPendingPackagePath: state.stage != UpdateUiStage.readyToInstall,
          clearPendingVersion: state.stage != UpdateUiStage.readyToInstall,
        );
      }
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
      stage: UpdateUiStage.openingInstaller,
      downloadBytesPerSecond: 0,
      clearEtaSeconds: true,
    );
    try {
      await _service.installDownloadedPackage(
        File(packagePath),
        updaterStrings: updaterStrings,
      );
      return null;
    } catch (err) {
      return '$err';
    } finally {
      if (ref.mounted) {
        state = state.copyWith(
          isUpdating: false,
          stage: UpdateUiStage.idle,
          clearPendingPackagePath: true,
          clearPendingVersion: true,
        );
      }
    }
  }
}
