part of 'package:melo_trip/pages/shared/player/play_queue_panel.dart';

class _PlayQueueHeader extends StatelessWidget {
  const _PlayQueueHeader({
    required this.player,
    required this.variant,
    required this.closeAfterClear,
    this.onClose,
  });

  final AppPlayer player;
  final PlayQueuePanelVariant variant;
  final VoidCallback? onClose;
  final bool closeAfterClear;

  bool get _isDesktop => variant == PlayQueuePanelVariant.desktop;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        _isDesktop ? 18 : 16,
        _isDesktop ? 14 : 12,
        12,
        10,
      ),
      decoration: BoxDecoration(
        color: _isDesktop
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)
            : null,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.22),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _PlayQueueTitle(variant: variant, player: player)),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface
                  .withValues(alpha: _isDesktop ? 0.88 : 0.92),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(
                  alpha: _isDesktop ? 0.28 : 0.22,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _PlayQueuePlaylistModeButton(),
                const _PlayQueueShuffleModeButton(),
                _ClearQueueButton(
                  player: player,
                  closeAfterClear: closeAfterClear,
                  onClose: onClose,
                ),
              ],
            ),
          ),
          if (_isDesktop)
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded),
            ),
        ],
      ),
    );
  }
}

class _ClearQueueButton extends StatelessWidget {
  const _ClearQueueButton({
    required this.player,
    required this.closeAfterClear,
    this.onClose,
  });

  final AppPlayer player;
  final bool closeAfterClear;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return PlayQueueBuilder(
      builder: (context, playQueue, _) {
        if (playQueue.songs.isEmpty) {
          return const SizedBox.shrink();
        }
        return IconButton(
          tooltip: AppLocalizations.of(context)!.clearPlayQueue,
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final l10n = AppLocalizations.of(context)!;
            await player.setPlaylist(songs: []);
            if (closeAfterClear) {
              onClose?.call();
            }
            messenger.showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 6),
                content: Text(l10n.playQueueCleared),
                action: SnackBarAction(
                  label: l10n.revoke,
                  onPressed: () {
                    final currentIndex = playQueue.index.clamp(
                      0,
                      playQueue.songs.length - 1,
                    );
                    player.setPlaylist(
                      songs: playQueue.songs,
                      initialId: playQueue.songs[currentIndex].id,
                    );
                  },
                ),
              ),
            );
          },
          icon: const Icon(Icons.clear_all_outlined),
        );
      },
    );
  }
}

class _PlayQueueTitle extends StatelessWidget {
  const _PlayQueueTitle({required this.variant, required this.player});

  final PlayQueuePanelVariant variant;
  final AppPlayer player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PlayQueueBuilder(
      builder: (context, playQueue, _) {
        if (variant == PlayQueuePanelVariant.mobile) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.playlist_play_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text.rich(
                  TextSpan(
                    text: AppLocalizations.of(context)!.playQueue,
                    style: theme.textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: ' (${playQueue.songs.length})',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.playlist_play_rounded,
                color: colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context)!.playQueue,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: .w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Text(
                          playQueue.songs.length.toString(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: .w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
