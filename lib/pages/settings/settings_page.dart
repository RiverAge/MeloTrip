import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:melo_trip/app_logic/app_update_service.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/favorite/favorite_page.dart';
import 'package:melo_trip/pages/initial/initial_page.dart';
import 'package:melo_trip/pages/playlist/playlist_page.dart';
import 'package:melo_trip/pages/settings/app_theme_page.dart';
import 'package:melo_trip/pages/settings/language_page.dart';
import 'package:melo_trip/pages/settings/music_quality_page.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/cached_data/cached_data.dart';
import 'package:melo_trip/provider/scan_status/scan_status.dart';
import 'package:melo_trip/provider/update/update_flow.dart';
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
  Widget build(BuildContext context) {
    final updateState = ref.watch(updateFlowControllerProvider);
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        elevation: 3.0,
      ),
      body: ListView(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 80.0),
        children: [
          _ServerStatus(),
          Card(
            margin: EdgeInsets.only(bottom: 32),
            child: Column(
              children: [
                ListTile(
                  onTap: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (_) => AppThemePage()));
                  },
                  leading: Icon(Icons.contrast),
                  title: Text(AppLocalizations.of(context)!.theme),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: const Icon(Icons.high_quality),
                  title: Text(AppLocalizations.of(context)!.musicQuality),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: ((_) => MusicQualityPage())),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                ),

                ListTile(
                  leading: const Icon(Icons.featured_play_list_outlined),
                  title: Text(AppLocalizations.of(context)!.myPlaylist),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: ((_) => const PlaylistPage())),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                ),

                ListTile(
                  leading: const Icon(Icons.favorite_border_outlined),
                  title: Text(AppLocalizations.of(context)!.myFavorites),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: ((_) => const FavoritePage())),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: Text(AppLocalizations.of(context)!.language),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: ((_) => const LanguagePage())),
                  ),
                  trailing: const Icon(Icons.arrow_forward),
                ),
                ListTile(
                  leading: const Icon(Icons.system_update_alt),
                  title: Text(AppLocalizations.of(context)!.checkForUpdates),
                  subtitle: updateState.isUpdating
                      ? Text(_buildUpdateSubtitle(context, updateState))
                      : null,
                  onTap: (updateState.isChecking || updateState.isUpdating)
                      ? null
                      : _onCheckUpdate,
                  trailing: updateState.isChecking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : updateState.isUpdating
                      ? Text(
                          '${updateState.downloadProgressPercent.toStringAsFixed(1)}%',
                        )
                      : const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.logout),
            onPressed: _onLogout,
            label: Text(AppLocalizations.of(context)!.logout),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _onCheckUpdate() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(updateFlowControllerProvider.notifier);

    try {
      final result = await controller.checkForUpdate();
      if (!mounted) return;

      if (!result.hasUpdate || result.remote == null) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(l10n.noUpdateTitle),
            content: Text(
              l10n.upToDateMessage(
                result.currentVersionName,
                result.currentVersionCode,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.confirm),
              ),
            ],
          ),
        );
        return;
      }

      final update = result.remote!;
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(l10n.updateAvailableTitle),
          content: SingleChildScrollView(
            child: Text(
              '${l10n.updateCurrentVersion(result.currentVersionName, result.currentVersionCode)}\n'
              '${l10n.updateLatestVersion(update.versionName, update.versionCode)}\n'
              '${l10n.updateSizeMb((update.fileSize / 1024 / 1024).toStringAsFixed(1))}\n\n'
              '${update.changelog}',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startNativeUpdate(update);
              },
              child: Text(l10n.updateNow),
            ),
          ],
        ),
      );
    } catch (err) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.updateCheckFailed('$err'))));
    }
  }

  Future<void> _startNativeUpdate(AppUpdateInfo update) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(updateFlowControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    final capability = await controller.getInstallCapability();
    switch (capability) {
      case InstallCapability.notSupported:
        if (!mounted) return;
        messenger.showSnackBar(SnackBar(content: Text(l10n.otaAndroidOnly)));
        return;
      case InstallCapability.permissionRequired:
        if (!mounted) return;
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(l10n.updateAvailableTitle),
            content: Text(l10n.updateInstallPermissionDenied),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancel),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await controller.openInstallPermissionSettings();
                },
                child: Text(l10n.confirm),
              ),
            ],
          ),
        );
        return;
      case InstallCapability.supported:
        break;
    }

    if (!mounted) return;
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.updateDownloadingPackage)),
    );

    final error = await controller.downloadAndInstall(update);
    if (!mounted) return;
    if (error != null) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.updateFailed(error))));
      return;
    }

    messenger.showSnackBar(
      SnackBar(content: Text(l10n.updateOpeningInstaller)),
    );
  }

  void _onLogout() {
    showDialog(
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
            builder: (context, player, _) {
              return Consumer(
                builder: (context, ref, _) {
                  return TextButton(
                    child: Text(AppLocalizations.of(context)!.confirm),
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      await player.pause();
                      await ref.read(logoutProvider.future);
                      navigator.pushAndRemoveUntil(
                        PageRouteBuilder(
                          pageBuilder: (context, _, _) => const InitialPage(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                        (route) => false,
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

  String _buildUpdateSubtitle(BuildContext context, UpdateFlowState state) {
    final l10n = AppLocalizations.of(context)!;
    final stage = switch (state.stage) {
      UpdateUiStage.idle => '',
      UpdateUiStage.downloading => l10n.updateStageDownloading,
      UpdateUiStage.verifying => l10n.updateStageVerifying,
      UpdateUiStage.openingInstaller => l10n.updateStageOpeningInstaller,
    };
    final progressLine = l10n.updateProgressLine(
      _formatBytes(state.downloadedBytes),
      _formatBytes(state.totalBytes),
      state.downloadProgressPercent.round(),
    );
    final speed = state.downloadBytesPerSecond > 0
        ? l10n.updateSpeedLine(
            '${_formatBytes(state.downloadBytesPerSecond.round())}/s',
          )
        : '';
    final eta = state.etaSeconds == null
        ? ''
        : l10n.updateEtaLine(_formatEta(state.etaSeconds!));
    final parts = <String>[stage, progressLine, speed, eta]
      ..removeWhere((it) => it.isEmpty);
    return parts.join('\n');
  }

  String _formatBytes(int bytes) {
    if (bytes <= 0) return '0 B';
    const kb = 1024.0;
    const mb = kb * 1024;
    if (bytes >= mb) {
      return '${(bytes / mb).toStringAsFixed(1)} MB';
    }
    if (bytes >= kb) {
      return '${(bytes / kb).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }

  String _formatEta(int seconds) {
    if (seconds <= 0) return '0s';
    final d = Duration(seconds: seconds);
    if (d.inMinutes >= 1) {
      final remainSeconds = d.inSeconds % 60;
      return '${d.inMinutes}m ${remainSeconds}s';
    }
    return '${d.inSeconds}s';
  }
}
