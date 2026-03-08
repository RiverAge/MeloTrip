import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_logic/app_update_service.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/provider/update/update_flow.dart';

class GeneralSettings extends ConsumerStatefulWidget {
  const GeneralSettings({super.key});

  @override
  ConsumerState<GeneralSettings> createState() => _GeneralSettingsState();
}

class _GeneralSettingsState extends ConsumerState<GeneralSettings> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final updateState = ref.watch(updateFlowControllerProvider);

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      children: [
        _SectionHeader(title: l10n.theme),
        _SettingRow(
          label: l10n.systemDefault,
          description: l10n.theme,
          trailing: Switch(value: true, onChanged: (_) {}),
        ),
        const Divider(height: 40),
        _SectionHeader(title: l10n.settings),
        _SettingRow(
          label: l10n.language,
          description: l10n.language,
          trailing: const Icon(Icons.chevron_right_rounded),
        ),
        _SettingRow(
          label: l10n.checkForUpdates,
          description: updateState.isUpdating
              ? _buildUpdateSubtitle(context, updateState)
              : l10n.checkForUpdates,
          trailing: updateState.isChecking
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : FilledButton.tonal(
                  onPressed: (updateState.isChecking || updateState.isUpdating)
                      ? null
                      : _onCheckUpdate,
                  child: Text(l10n.checkForUpdates),
                ),
        ),
      ],
    );
  }

  Future<void> _onCheckUpdate() async {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(updateFlowControllerProvider.notifier);

    try {
      final result = await controller.checkForUpdate();
      if (!mounted) return;

      if (!result.hasUpdate || result.remote == null) {
        await showDialog<void>(
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
      await showDialog<void>(
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
                _startUpdate(update);
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

  Future<void> _startUpdate(AppUpdateInfo update) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = ref.read(updateFlowControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context);
    final capability = await controller.getInstallCapability();

    if (capability == InstallCapability.supported) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.updateDownloadingPackage)),
      );
      final error = await controller.downloadAndInstall(update);
      if (!mounted) return;
      if (error != null) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.updateFailed(error))),
        );
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.updateOpeningInstaller)),
      );
      return;
    }

    messenger.showSnackBar(SnackBar(content: Text(update.downloadUrl)));
    final error = await controller.openDownloadPage(update);
    if (!mounted) return;
    if (error != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.updateCheckFailed(error))),
      );
    }
  }

  String _buildUpdateSubtitle(BuildContext context, UpdateFlowState state) {
    final l10n = AppLocalizations.of(context)!;
    if (state.stage == UpdateUiStage.verifying) {
      return l10n.updateStageVerifying;
    }
    if (state.stage == UpdateUiStage.openingInstaller) {
      return l10n.updateStageOpeningInstaller;
    }

    final percent = '${state.downloadProgressPercent.toStringAsFixed(0)}%';
    final size =
        '${_formatBytes(state.downloadedBytes)}/${_formatBytes(state.totalBytes)}';
    final speed = state.downloadBytesPerSecond > 0
        ? '${_formatBytes(state.downloadBytesPerSecond.round())}/s'
        : '';
    final parts = <String>[percent, size, speed]
      ..removeWhere((String item) => item.isEmpty);
    return parts.join(' | ');
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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w900,
          fontSize: 22,
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    required this.description,
    required this.trailing,
  });

  final String label;
  final String description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          trailing,
        ],
      ),
    );
  }
}
