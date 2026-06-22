part of '../song_control.dart';

class _SongTitle extends StatelessWidget {
  const _SongTitle({required this.song});
  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final artist = song.displayArtist ?? song.artist ?? '';

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 0),
      child: PlayQueueBuilder(
        builder: (context, playQueue, ref) {
          final current = playQueue.index >= playQueue.songs.length
              ? null
              : playQueue.songs[playQueue.index];
          return AsyncValueBuilder(
            provider: appPlayerHandlerProvider,
            builder: (context, player, _) {
              return AsyncStreamBuilder(
                provider: player.playingStream,
                builder: (_, playing) {
                  final isCurrent = current?.id == song.id;
                  final isCurrentPlaying = playing && isCurrent;
                  final titleColor = isCurrent
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface;

                  return Row(
                    crossAxisAlignment: .start,
                    children: [
                      _SongArtworkPreview(
                        song: song,
                        isCurrentPlaying: isCurrentPlaying,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              song.title ?? '',
                              maxLines: 2,
                              overflow: .ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: titleColor,
                              ),
                            ),
                            if (artist.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                artist,
                                maxLines: 1,
                                overflow: .ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.78),
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Consumer(
                              builder: (context, ref, _) {
                                return Rating(
                                  onRating: (rating) {
                                    ref
                                        .read(
                                          songDetailProvider(song.id).notifier,
                                        )
                                        .updateRating(rating);
                                  },
                                  rating: song.userRating,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class _SongArtworkPreview extends StatelessWidget {
  const _SongArtworkPreview({
    required this.song,
    required this.isCurrentPlaying,
  });

  final SongEntity song;
  final bool isCurrentPlaying;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox.square(
      dimension: 56,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ArtworkImage(id: song.id, fit: .cover),
            ),
          ),
          if (isCurrentPlaying)
            Align(
              alignment: .bottomRight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withValues(alpha: 0.86),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Image.asset(
                    'images/playing.gif',
                    width: 18,
                    height: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
