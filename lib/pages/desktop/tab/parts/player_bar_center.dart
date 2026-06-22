part of '../tab_page.dart';

class _DesktopPlayerBarCenter extends StatelessWidget {
  const _DesktopPlayerBarCenter({
    required this.player,
    required this.colorScheme,
  });

  static const double _controlButtonWidth = 48.0;
  static const int _controlButtonCount = 6;
  static const int _controlGapCount = 5;
  static const double _minControlGap = 4.0;
  static const double _maxControlGap = 16.0;

  final AppPlayer player;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final iconMutedColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.72);

    return Column(
      mainAxisAlignment: .center,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final gap = _resolveControlGap(constraints.maxWidth);
            final controls = _buildControlsRow(
              context: context,
              l10n: l10n,
              iconMutedColor: iconMutedColor,
              gap: gap,
            );

            if (!constraints.maxWidth.isFinite) return controls;

            return SizedBox(
              width: constraints.maxWidth,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: .center,
                child: controls,
              ),
            );
          },
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

  Widget _buildControlsRow({
    required BuildContext context,
    required AppLocalizations l10n,
    required Color iconMutedColor,
    required double gap,
  }) {
    return Row(
      mainAxisSize: .min,
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
        SizedBox(width: gap),
        IconButton(
          iconSize: 24,
          tooltip: l10n.previousSong,
          onPressed: player.skipToPrevious,
          icon: const Icon(Icons.skip_previous_rounded),
        ),
        SizedBox(width: gap),
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
        SizedBox(width: gap),
        IconButton(
          iconSize: 24,
          tooltip: l10n.nextSong,
          onPressed: player.skipToNext,
          icon: const Icon(Icons.skip_next_rounded),
        ),
        SizedBox(width: gap),
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
        SizedBox(width: gap),
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
    );
  }

  double _resolveControlGap(double maxWidth) {
    if (!maxWidth.isFinite) return _maxControlGap;

    final fixedWidth = _controlButtonWidth * _controlButtonCount;
    final gapBudget = (maxWidth - fixedWidth) / _controlGapCount;
    return gapBudget.clamp(_minControlGap, _maxControlGap).toDouble();
  }
}
