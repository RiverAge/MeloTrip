part of '../tab_page.dart';

class _DesktopPlayerBarCenter extends StatelessWidget {
  const _DesktopPlayerBarCenter({
    required this.player,
    required this.colorScheme,
  });

  final AppPlayer player;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final iconMutedColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.72);

    return Column(
      mainAxisAlignment: .center,
      children: [
        Row(
          mainAxisAlignment: .center,
          children: [
            AsyncStreamBuilder(
              provider: player.playlistModeStream,
              builder: (_, playlistMode) {
                final bool shuffleDisabled = playlistMode == .single;
                return AsyncStreamBuilder(
                  provider: player.shuffleStream,
                  builder: (_, shuffleEnabled) {
                    final shuffleTooltip = shuffleDisabled
                        ? '${l10n.shuffleOff} · ${l10n.playModeSingle}'
                        : (shuffleEnabled ? l10n.shuffleOn : l10n.shuffleOff);
                    return IconButton(
                      iconSize: 20,
                      tooltip: shuffleTooltip,
                      onPressed: shuffleDisabled
                          ? null
                          : () => player.setShuffleModeEnabled(!shuffleEnabled),
                      icon: Icon(
                        shuffleEnabled
                            ? Icons.shuffle_on_rounded
                            : Icons.shuffle_rounded,
                        color: shuffleEnabled
                            ? colorScheme.primary
                            : iconMutedColor,
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(width: 16),
            IconButton(
              iconSize: 24,
              tooltip: l10n.previousSong,
              onPressed: player.skipToPrevious,
              icon: const Icon(Icons.skip_previous_rounded),
            ),
            const SizedBox(width: 16),
            AsyncStreamBuilder(
              provider: player.playingStream,
              loading: (_) => const SizedBox.shrink(),
              builder: (_, playing) {
                return IconButton.filled(
                  iconSize: 32,
                  tooltip: playing ? l10n.pause : l10n.play,
                  onPressed: player.playOrPause,
                  icon: Icon(
                    playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                );
              },
            ),
            const SizedBox(width: 16),
            IconButton(
              iconSize: 24,
              tooltip: l10n.nextSong,
              onPressed: player.skipToNext,
              icon: const Icon(Icons.skip_next_rounded),
            ),
            const SizedBox(width: 16),
            AsyncStreamBuilder(
              provider: player.playlistModeStream,
              builder: (_, playlistMode) {
                final (icon, tooltip, color) = switch (playlistMode) {
                  .none => (
                    Icons.queue_music_outlined,
                    l10n.playModeNone,
                    iconMutedColor,
                  ),
                  .loop => (
                    Icons.repeat_rounded,
                    l10n.playModeLoop,
                    colorScheme.primary,
                  ),
                  .single => (
                    Icons.repeat_one_rounded,
                    l10n.playModeSingle,
                    colorScheme.primary,
                  ),
                };

                return IconButton(
                  iconSize: 20,
                  tooltip: tooltip,
                  onPressed: () {
                    if (playlistMode == .loop) {
                      player.setPlaylistMode(.none);
                    } else if (playlistMode == .none) {
                      player.setPlaylistMode(.single);
                    } else {
                      player.setPlaylistMode(.loop);
                    }
                  },
                  icon: Icon(icon, color: color),
                );
              },
            ),
            const SizedBox(width: 16),
            IconButton(
              iconSize: 20,
              tooltip: l10n.playQueue,
              onPressed: () {
                showDialog(
                  context: context,
                  barrierColor: Theme.of(
                    context,
                  ).colorScheme.scrim.withValues(alpha: 0.4),
                  builder: (_) => const _DesktopQueueSheet(),
                );
              },
              icon: Icon(Icons.playlist_play_rounded, color: iconMutedColor),
            ),
          ],
        ),
        const SizedBox(height: 6),
        FractionallySizedBox(
          widthFactor: .4,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: _DesktopProgressBar(player: player),
          ),
        ),
      ],
    );
  }
}
