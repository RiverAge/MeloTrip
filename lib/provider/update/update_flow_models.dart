part of 'update_flow.dart';

class UpdateFlowState {
  const UpdateFlowState({
    this.hasChecked = false,
    this.isChecking = false,
    this.isUpdating = false,
    this.downloadProgressPercent = 0,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.downloadBytesPerSecond = 0,
    this.etaSeconds,
    this.stage = .idle,
    this.pendingPackagePath,
    this.pendingVersionName,
    this.pendingVersionCode,
    this.availableUpdate,
    this.currentVersionName,
    this.currentVersionCode,
    this.checkError,
  });

  final bool hasChecked;
  final bool isChecking;
  final bool isUpdating;
  final double downloadProgressPercent;
  final int downloadedBytes;
  final int totalBytes;
  final double downloadBytesPerSecond;
  final int? etaSeconds;
  final UpdateUiStage stage;
  final String? pendingPackagePath;
  final String? pendingVersionName;
  final int? pendingVersionCode;
  final AppUpdateInfo? availableUpdate;
  final String? currentVersionName;
  final int? currentVersionCode;
  final String? checkError;

  UpdateFlowState copyWith({
    bool? hasChecked,
    bool? isChecking,
    bool? isUpdating,
    double? downloadProgressPercent,
    int? downloadedBytes,
    int? totalBytes,
    double? downloadBytesPerSecond,
    int? etaSeconds,
    bool clearEtaSeconds = false,
    UpdateUiStage? stage,
    String? pendingPackagePath,
    bool clearPendingPackagePath = false,
    String? pendingVersionName,
    int? pendingVersionCode,
    bool clearPendingVersion = false,
    AppUpdateInfo? availableUpdate,
    bool clearAvailableUpdate = false,
    String? currentVersionName,
    int? currentVersionCode,
    String? checkError,
    bool clearCheckError = false,
  }) {
    return UpdateFlowState(
      hasChecked: hasChecked ?? this.hasChecked,
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
      pendingPackagePath: clearPendingPackagePath
          ? null
          : pendingPackagePath ?? this.pendingPackagePath,
      pendingVersionName: clearPendingVersion
          ? null
          : pendingVersionName ?? this.pendingVersionName,
      pendingVersionCode: clearPendingVersion
          ? null
          : pendingVersionCode ?? this.pendingVersionCode,
      availableUpdate: clearAvailableUpdate
          ? null
          : availableUpdate ?? this.availableUpdate,
      currentVersionName: currentVersionName ?? this.currentVersionName,
      currentVersionCode: currentVersionCode ?? this.currentVersionCode,
      checkError: clearCheckError ? null : checkError ?? this.checkError,
    );
  }
}

enum UpdateUiStage {
  idle,
  downloading,
  verifying,
  readyToInstall,
  openingInstaller,
}

enum InstallCapability { supported, notSupported, permissionRequired }
