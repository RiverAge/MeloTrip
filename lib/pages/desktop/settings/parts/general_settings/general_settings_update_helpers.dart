part of '../general_settings.dart';

extension _GeneralSettingsUpdateHelpers on _GeneralSettingsState {
  Future<void> _maybeAutoCheck() async {
    final UpdateFlowState state = ref.read(updateFlowControllerProvider);
    if (state.hasChecked || state.isChecking || state.isUpdating) {
      return;
    }
    final UpdateFlowController controller = ref.read(
      updateFlowControllerProvider.notifier,
    );
    try {
      await controller.checkForUpdate(silent: true);
    } catch (_) {}
  }

  Future<void> _startUpdate(AppUpdateInfo update) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final UpdateFlowController controller = ref.read(
      updateFlowControllerProvider.notifier,
    );
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final InstallCapability capability = await controller.getInstallCapability();

    if (capability == InstallCapability.supported) {
      final String? error = await controller.downloadAndInstall(
        update,
        updaterStrings: _buildWindowsUpdaterStrings(
          l10n,
          ref.read(updateFlowControllerProvider),
          fallbackVersionName: update.versionName,
          fallbackVersionCode: update.versionCode,
        ),
      );
      if (!mounted) return;
      if (error != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.updateFailed(error))),
        );
      }
      return;
    }

    final String? error = await controller.openDownloadPage(update);
    if (!mounted) return;
    if (error != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.updateCheckFailed(error))),
      );
    }
  }

  Future<void> _restartAndInstallPending() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final UpdateFlowController controller = ref.read(
      updateFlowControllerProvider.notifier,
    );
    final UpdateFlowState updateState = ref.read(updateFlowControllerProvider);
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    final String? error = await controller.installPendingPackage(
      updaterStrings: _buildWindowsUpdaterStrings(l10n, updateState),
    );
    if (!mounted) return;
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.updateFailed(error))));
    }
  }

  WindowsUpdaterStrings _buildWindowsUpdaterStrings(
    AppLocalizations l10n,
    UpdateFlowState state, {
    String? fallbackVersionName,
    int? fallbackVersionCode,
  }) {
    final String versionName =
        state.pendingVersionName ?? fallbackVersionName ?? '-';
    final int versionCode =
        state.pendingVersionCode ?? fallbackVersionCode ?? 0;
    return WindowsUpdaterStrings(
      windowTitle: l10n.updateInstallerWindowTitle,
      versionLine: l10n.updateInstallerVersionLine(versionName, versionCode),
      preparing: l10n.updateInstallerPreparing,
      waitingForApp: l10n.updateInstallerWaitingForApp,
      extractingArchive: l10n.updateInstallerExtractingArchive,
      copyingFiles: l10n.updateInstallerCopyingFiles,
      restartingApp: l10n.updateInstallerRestartingApp,
      failed: l10n.updateInstallerFailed,
      invalidArguments: l10n.updateInstallerInvalidArguments,
      initFailed: l10n.updateInstallerInitFailed,
      waitFailed: l10n.updateInstallerWaitFailed,
      tempPathFailed: l10n.updateInstallerTempPathFailed,
      tempDirFailed: l10n.updateInstallerTempDirFailed,
      extractFailed: l10n.updateInstallerExtractFailed,
      copyFailed: l10n.updateInstallerCopyFailed,
    );
  }

  Widget? _buildUpdateProgress(BuildContext context, UpdateFlowState state) {
    if (!state.isUpdating || state.stage != .downloading) {
      return null;
    }
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final double? progress = state.totalBytes > 0
        ? (state.downloadProgressPercent / 100).clamp(0.0, 1.0)
        : null;
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: LinearProgressIndicator(
          minHeight: 6,
          value: progress,
          backgroundColor: colorScheme.surfaceContainerHighest,
          valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
        ),
      ),
    );
  }

  String _buildUpdateSubtitle(BuildContext context, UpdateFlowState state) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (state.isChecking) {
      return l10n.updateCheckingInline;
    }
    if (state.stage == .readyToInstall) {
      return l10n.updateReadyToInstallTitle;
    }
    if (state.stage == .verifying) {
      return l10n.updateStageVerifying;
    }
    if (state.stage == .openingInstaller) {
      return l10n.updateStageOpeningInstaller;
    }
    if (state.isUpdating) {
      final String percent =
          '${state.downloadProgressPercent.toStringAsFixed(0)}%';
      final String size =
          '${_formatBytes(state.downloadedBytes)}/${_formatBytes(state.totalBytes)}';
      final String speed = state.downloadBytesPerSecond > 0
          ? '${_formatBytes(state.downloadBytesPerSecond.round())}/s'
          : '';
      final List<String> parts = <String>[percent, size, speed]
        ..removeWhere((String item) => item.isEmpty);
      return parts.join(' | ');
    }
    if (state.checkError != null) {
      return l10n.updateCheckFailedInline;
    }
    if (state.availableUpdate case final AppUpdateInfo update) {
      return l10n.updateAvailableInline(update.versionName);
    }
    if (state.hasChecked &&
        state.currentVersionName != null &&
        state.currentVersionCode != null) {
      return l10n.updateAlreadyLatestInline(
        state.currentVersionName!,
        state.currentVersionCode!,
      );
    }
    return l10n.checkForUpdates;
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0B';
    const double kb = 1024;
    const double mb = kb * 1024;
    if (bytes >= mb) {
      return '${(bytes / mb).toStringAsFixed(0)}M';
    }
    if (bytes >= kb) {
      return '${(bytes / kb).toStringAsFixed(0)}K';
    }
    return '${bytes}B';
  }
}
