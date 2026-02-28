import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_logic/app_update_service.dart';

final appUpdateServiceProvider = Provider<AppUpdateService>((ref) {
  return AppUpdateService();
});

class UpdateFlowState {
  const UpdateFlowState({
    this.isChecking = false,
    this.isUpdating = false,
    this.downloadProgressPercent = 0,
  });

  final bool isChecking;
  final bool isUpdating;
  final int downloadProgressPercent;

  UpdateFlowState copyWith({
    bool? isChecking,
    bool? isUpdating,
    int? downloadProgressPercent,
  }) {
    return UpdateFlowState(
      isChecking: isChecking ?? this.isChecking,
      isUpdating: isUpdating ?? this.isUpdating,
      downloadProgressPercent:
          downloadProgressPercent ?? this.downloadProgressPercent,
    );
  }
}

enum InstallCapability { supported, notSupported, permissionRequired }

class UpdateFlowController extends StateNotifier<UpdateFlowState> {
  UpdateFlowController(this._service) : super(const UpdateFlowState());

  final AppUpdateService _service;

  Future<AppUpdateCheckResult> checkForUpdate() async {
    state = state.copyWith(isChecking: true);
    try {
      return await _service.checkForUpdate();
    } finally {
      state = state.copyWith(isChecking: false);
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

  Future<String?> downloadAndInstall(AppUpdateInfo update) async {
    if (state.isUpdating) return 'Update is already in progress.';

    state = state.copyWith(isUpdating: true, downloadProgressPercent: 0);
    try {
      final apkFile = await _service.downloadAndVerifyApk(
        update: update,
        onProgress: (progress) {
          final percent = (progress * 100).clamp(0, 100).toInt();
          if (percent == state.downloadProgressPercent) return;
          state = state.copyWith(downloadProgressPercent: percent);
        },
      );
      await _service.installDownloadedPackage(apkFile);
      return null;
    } catch (err) {
      return '$err';
    } finally {
      state = state.copyWith(isUpdating: false);
    }
  }
}

final updateFlowControllerProvider =
    StateNotifierProvider<UpdateFlowController, UpdateFlowState>((ref) {
      final service = ref.watch(appUpdateServiceProvider);
      return UpdateFlowController(service);
    });
