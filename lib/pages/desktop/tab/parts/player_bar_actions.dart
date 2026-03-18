part of '../tab_page.dart';

class _DesktopPlayerBarActions extends StatelessWidget {
  const _DesktopPlayerBarActions({
    required this.current,
    required this.player,
    required this.colorScheme,
  });

  final SongEntity? current;
  final AppPlayer player;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final iconMutedColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.72);

    return Consumer(
      builder: (context, ref, _) {
        final detail = ref.watch(songDetailProvider(current?.id));
        final effectiveSong = detail.asData?.value?.subsonicResponse?.song ?? current;
        final rating = effectiveSong?.userRating ?? 0;
        final isStarred = effectiveSong?.starred != null;
        return Column(
          mainAxisAlignment: .center,
          crossAxisAlignment: .end,
          children: [
            Row(
              mainAxisAlignment: .end,
              children: [
                _DesktopAudioOutputDeviceButton(player: player),
                const SizedBox(width: 10),
                Rating(
                  rating: rating,
                  onRating: (value) {
                    ref
                        .read(songRatingProvider.notifier)
                        .updateRating(current?.id, value);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: .end,
              children: [
                IconButton(
                  onPressed: current == null
                      ? null
                      : () => ref
                            .read(songFavoriteProvider.notifier)
                            .toggleFavorite(current),
                  iconSize: 20,
                  visualDensity: .compact,
                  constraints: const BoxConstraints.tightFor(
                    width: 34,
                    height: 34,
                  ),
                  padding: EdgeInsets.zero,
                  tooltip: isStarred ? l10n.unfavorite : l10n.favorite,
                  icon: Icon(
                    isStarred
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isStarred ? colorScheme.primary : iconMutedColor,
                  ),
                ),
                const SizedBox(width: 8),
                const _DesktopVolumeBar(),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _DesktopAudioOutputDeviceButton extends StatelessWidget {
  const _DesktopAudioOutputDeviceButton({required this.player});

  final AppPlayer player;

  static bool get _supportsAudioOutputSelection {
    if (kIsWeb) return false;
    return switch (defaultTargetPlatform) {
      TargetPlatform.windows => true,
      TargetPlatform.linux => true,
      TargetPlatform.macOS => true,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (!_supportsAudioOutputSelection) {
      return const SizedBox.shrink();
    }
    return StreamBuilder<List<AudioDevice>>(
      stream: player.audioDevicesStream,
      initialData: player.audioDevices,
      builder: (context, devicesSnapshot) {
        final l10n = AppLocalizations.of(context)!;
        final theme = Theme.of(context);
        final devices = [
          AudioDevice.auto(),
          ...(devicesSnapshot.data ?? const <AudioDevice>[]).where(
            (d) => d.name != 'auto',
          ),
        ];
        return StreamBuilder<AudioDevice>(
          stream: player.audioDeviceStream,
          initialData: player.audioDevice,
          builder: (context, activeSnapshot) {
            final active = activeSnapshot.data ?? AudioDevice.auto();
            final selected = devices.firstWhere(
              (d) => d.name == active.name,
              orElse: AudioDevice.auto,
            );
            return IconButton(
              tooltip: '${l10n.audioOutputDevice}: ${_deviceLabel(l10n, selected)}',
              onPressed: () => _showAudioOutputDialog(
                context: context,
                l10n: l10n,
                theme: theme,
                selected: selected,
                devices: devices,
              ),
              visualDensity: .compact,
              iconSize: 18,
              constraints: const BoxConstraints.tightFor(
                width: 34,
                height: 34,
              ),
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.55),
                foregroundColor: theme.colorScheme.onSurfaceVariant,
              ),
              icon: const Icon(Icons.speaker_rounded),
            );
          },
        );
      },
    );
  }

  Future<void> _showAudioOutputDialog({
    required BuildContext context,
    required AppLocalizations l10n,
    required ThemeData theme,
    required AudioDevice selected,
    required List<AudioDevice> devices,
  }) async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              mainAxisSize: .min,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.speaker_rounded,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.audioOutputDevice,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: .centerLeft,
                  child: Text(
                    '${l10n.audioOutputDeviceCurrent}: ${_deviceLabel(l10n, selected)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.82,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Divider(
                  height: 1,
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.35,
                  ),
                ),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 280),
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: devices.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 6),
                      itemBuilder: (_, index) {
                        final device = devices[index];
                        return _AudioOutputOption(
                          label: _deviceLabel(l10n, device),
                          selected: device.name == selected.name,
                          theme: theme,
                          onTap: () {
                            player.setAudioOutputDevice(device);
                            Navigator.pop(dialogContext);
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: .centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: Text(l10n.cancel),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _deviceLabel(AppLocalizations l10n, AudioDevice device) {
    if (device.name == 'auto') {
      return l10n.audioOutputDeviceAuto;
    }
    final description = device.description.trim();
    if (description.isNotEmpty) {
      return description;
    }
    return device.name;
  }
}

class _AudioOutputOption extends StatelessWidget {
  const _AudioOutputOption({
    required this.label,
    required this.selected,
    required this.theme,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.42)
                : theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary.withValues(alpha: 0.35)
                  : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              children: <Widget>[
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 18,
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.7,
                        ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: selected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (selected)
                  Icon(
                    Icons.check_rounded,
                    size: 16,
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
