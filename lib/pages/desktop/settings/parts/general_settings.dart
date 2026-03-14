import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/settings/parts/settings_widgets.dart';
<<<<<<< HEAD
import 'package:melo_trip/provider/user_config/user_config.dart';
=======
import 'package:melo_trip/pages/shared/initial/initial_page.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
>>>>>>> 590e10d (Add desktop logout entry)
import 'package:melo_trip/provider/update/update_flow.dart';
import 'package:melo_trip/update/app_update_service.dart';
import 'package:update_installer/update_installer.dart';

class GeneralSettings extends ConsumerStatefulWidget {
  const GeneralSettings({super.key});

  @override
  ConsumerState<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends ConsumerState<GeneralSettings> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeAutoCheck();
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final UpdateFlowState updateState = ref.watch(updateFlowControllerProvider);
    final userConfig = ref.watch(userConfigProvider).value;

    final bool isReadyToInstall =
        updateState.stage == .readyToInstall &&
        updateState.pendingPackagePath != null;
    final AppUpdateInfo? availableUpdate = updateState.availableUpdate;
    final ThemeData theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      children: <Widget>[
        Align(
          alignment: .topLeft,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 840),
            child: Column(
              crossAxisAlignment: .start,
              children: <Widget>[
                SettingSectionHeader(
                  title: l10n.settings,
                  icon: Icons.settings_suggest_rounded,
                ),
                SettingSectionCard(
                  child: SettingSectionBody(
                    children: <Widget>[
                      SettingRow(
                        label: l10n.language,
                        description: _getLanguageName(l10n, userConfig?.locale),
                        onTap: () => _showLanguageDialog(context),
                        trailing: Icon(
                          Icons.translate_rounded,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      SettingRow(
                        label: l10n.checkForUpdates,
                        description: _buildUpdateSubtitle(context, updateState),
                        progress: _buildUpdateProgress(context, updateState),
                        trailing: updateState.isChecking
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                ),
                              )
                            : (isReadyToInstall || availableUpdate != null)
                            ? FilledButton.tonal(
                                onPressed:
                                    (updateState.isChecking ||
                                        updateState.isUpdating)
                                    ? null
                                    : isReadyToInstall
                                    ? _restartAndInstallPending
                                    : availableUpdate != null
                                    ? () => _startUpdate(availableUpdate)
                                    : null,
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
<<<<<<< HEAD
                                child: Text(
                                  isReadyToInstall
                                      ? l10n.updateRestartToInstallAction
                                      : availableUpdate != null
                                      ? l10n.updateNow
                                      : '',
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
=======
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _GeneralSettingsSectionTitle(
                      icon: Icons.logout_rounded,
                      title: l10n.logout,
                      subtitle: l10n.logoutDialogConfirm,
                    ),
                    SettingSectionBody(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 0,
                        vertical: 10,
                      ),
                      children: <Widget>[
                        SettingRow(
                          label: l10n.logout,
                          description: l10n.logoutDialogConfirm,
                          trailing: FilledButton.icon(
                            onPressed: _onLogoutPressed,
                            icon: const Icon(Icons.logout_rounded),
                            label: Text(l10n.logout),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
>>>>>>> 590e10d (Add desktop logout entry)
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getLanguageName(AppLocalizations l10n, Locale? locale) {
    if (locale == null) return l10n.systemDefault;
    if (locale.languageCode == 'zh') return l10n.simpleChinese;
    if (locale.languageCode == 'en') return l10n.english;
    return locale.toString();
  }

  void _showLanguageDialog(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.language),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: .min,
          children: <Widget>[
            _LanguageOption(
              label: l10n.systemDefault,
              selected: ref.watch(userConfigProvider).value?.locale == null,
              onTap: () {
                ref
                    .read(userConfigProvider.notifier)
                    .setConfiguration(
                      locale: const ValueUpdater<Locale?>(null),
                    );
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              label: l10n.simpleChinese,
              selected:
                  ref.watch(userConfigProvider).value?.locale?.languageCode ==
                  'zh',
              onTap: () {
                ref
                    .read(userConfigProvider.notifier)
                    .setConfiguration(
                      locale: const ValueUpdater<Locale?>(Locale('zh', 'CN')),
                    );
                Navigator.pop(context);
              },
            ),
            _LanguageOption(
              label: l10n.english,
              selected:
                  ref.watch(userConfigProvider).value?.locale?.languageCode ==
                  'en',
              onTap: () {
                ref
                    .read(userConfigProvider.notifier)
                    .setConfiguration(
                      locale: const ValueUpdater<Locale?>(Locale('en', 'US')),
                    );
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

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
    final InstallCapability capability = await controller
        .getInstallCapability();

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

  Future<void> _onLogoutPressed() async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(l10n.logout),
          content: Text(l10n.logoutDialogConfirm),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext, rootNavigator: true).pop();
              },
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () async {
                final NavigatorState navigator =
                    Navigator.of(dialogContext, rootNavigator: true);
                navigator.pop();
                final player = await ref.read(appPlayerHandlerProvider.future);
                await player?.pause();
                await ref.read(logoutProvider.future);
                if (!mounted) return;
                await navigator.pushAndRemoveUntil(
                  PageRouteBuilder<void>(
                    pageBuilder:
                        (
                          BuildContext context,
                          Animation<double> primaryAnimation,
                          Animation<double> secondaryAnimation,
                        ) =>
                        const InitialPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary.withValues(alpha: 0.5)
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: selected ? .w700 : .w500,
                      color: selected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (selected)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
