import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/mobile/favorite/favorite_page.dart';
import 'package:melo_trip/pages/mobile/playlist/playlist_page.dart';
import 'package:melo_trip/pages/mobile/settings/app_theme_page.dart';
import 'package:melo_trip/pages/mobile/settings/language_page.dart';
import 'package:melo_trip/pages/mobile/settings/music_quality_page.dart';
import 'package:melo_trip/pages/shared/initial/initial_page.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/cached_data/cached_data.dart';
import 'package:melo_trip/provider/scan_status/scan_status.dart';
import 'package:melo_trip/provider/update/update_flow.dart';
import 'package:melo_trip/update/app_update_service.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/cache_file.dart';
part 'parts/server_status.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeAutoCheck();
    });
  }

  @override
  Widget build(BuildContext context) {
    final UpdateFlowState updateState = ref.watch(updateFlowControllerProvider);
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings), elevation: 3.0),
      body: ListView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 80.0),
        children: <Widget>[
          _ServerStatus(),
          Card(
            margin: const EdgeInsets.only(bottom: 32),
            child: Column(
              children: <Widget>[
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<AppThemePage>(
                        builder: (_) => AppThemePage(),
                      ),
                    );
                  },
                  leading: const Icon(Icons.contrast),
                  title: Text(l10n.theme),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: const Icon(Icons.high_quality),
                  title: Text(l10n.musicQuality),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<MusicQualityPage>(
                      builder: (_) => MusicQualityPage(),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: const Icon(Icons.featured_play_list_outlined),
                  title: Text(l10n.myPlaylist),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<PlaylistPage>(
                      builder: (_) => const PlaylistPage(),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_border_outlined),
                  title: Text(l10n.myFavorites),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<FavoritePage>(
                      builder: (_) => const FavoritePage(),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(l10n.language),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<LanguagePage>(
                      builder: (_) => const LanguagePage(),
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: const Icon(Icons.system_update_alt),
                  title: Text(l10n.checkForUpdates),
                  subtitle: _buildUpdateSubtitleWidget(context, updateState),
                  onTap: (updateState.isChecking || updateState.isUpdating)
                      ? null
                      : updateState.availableUpdate != null
                      ? () => _startNativeUpdate(updateState.availableUpdate!)
                      : _onCheckUpdate,
                  trailing: updateState.isChecking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : updateState.availableUpdate != null
                      ? Text(
                          l10n.updateNow,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        )
                      : const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            onPressed: _onLogout,
            label: Text(l10n.logout),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

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

  Future<void> _onCheckUpdate() async {
    final UpdateFlowController controller = ref.read(
      updateFlowControllerProvider.notifier,
    );
    try {
      await controller.checkForUpdate();
    } catch (_) {}
  }

  Future<void> _startNativeUpdate(AppUpdateInfo update) async {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final UpdateFlowController controller = ref.read(
      updateFlowControllerProvider.notifier,
    );
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final InstallCapability capability = await controller
        .getInstallCapability();
    switch (capability) {
      case InstallCapability.notSupported:
        if (!mounted) return;
        messenger.showSnackBar(SnackBar(content: Text(l10n.otaAndroidOnly)));
        return;
      case InstallCapability.permissionRequired:
        await controller.openInstallPermissionSettings();
        return;
      case InstallCapability.supported:
        break;
    }

    final String? error = await controller.downloadAndInstall(update);
    if (!mounted) return;
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.updateFailed(error))));
    }
  }

  void _onLogout() {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.logout),
        content: Text(AppLocalizations.of(context)!.logoutDialogConfirm),
        actions: <Widget>[
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          AsyncValueBuilder(
            provider: appPlayerHandlerProvider,
            builder: (BuildContext context, dynamic player, _) {
              return Consumer(
                builder: (BuildContext context, WidgetRef ref, _) {
                  return TextButton(
                    child: Text(AppLocalizations.of(context)!.confirm),
                    onPressed: () async {
                      final NavigatorState navigator = Navigator.of(context);
                      await player.pause();
                      await ref.read(logoutProvider.future);
                      navigator.pushAndRemoveUntil(
                        PageRouteBuilder<void>(
                          pageBuilder: (BuildContext context, _, _) =>
                              const InitialPage(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                        (Route<dynamic> route) => false,
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateSubtitleWidget(
    BuildContext context,
    UpdateFlowState state,
  ) {
    final ThemeData theme = Theme.of(context);
    final List<Widget> children = <Widget>[
      Text(
        _buildUpdateSubtitle(context, state),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.bodySmall,
      ),
    ];

    if (state.isUpdating && state.stage == UpdateUiStage.downloading) {
      final double? progress = state.totalBytes > 0
          ? (state.downloadProgressPercent / 100).clamp(0.0, 1.0)
          : null;
      children.add(const SizedBox(height: 8));
      children.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 6,
            value: progress,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.primary,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  String _buildUpdateSubtitle(BuildContext context, UpdateFlowState state) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    if (state.isChecking) {
      return l10n.updateCheckingInline;
    }
    if (state.stage == UpdateUiStage.verifying) {
      return l10n.updateStageVerifying;
    }
    if (state.stage == UpdateUiStage.openingInstaller) {
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
    const double kb = 1024.0;
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
