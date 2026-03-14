part of '../songs_page.dart';

const TextStyle kSongTableHeaderStyle = TextStyle(
  fontSize: 11,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.2,
);

class SongPageHeader extends StatelessWidget {
  const SongPageHeader({
    required this.title,
    required this.count,
    required this.viewType,
    required this.onViewTypeChanged,
    super.key,
  });

  final String title;
  final int count;
  final AppViewType viewType;
  final ValueChanged<AppViewType> onViewTypeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.music_note_rounded,
              color: theme.colorScheme.onPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            title,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: .w900,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              '$count',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Spacer(),
          AlbumViewSwitcher(
            current: viewType,
            onChanged: onViewTypeChanged,
            showDetailOption: false,
          ),
        ],
      ),
    );
  }
}

class SongPageToolbar extends StatelessWidget {
  const SongPageToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 8);
  }
}

class SongTrackRow extends ConsumerWidget {
  const SongTrackRow({required this.index, required this.song, super.key});

  final int index;
  final SongEntity song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () async {
        final player = await ref.read(appPlayerHandlerProvider.future);
        await player?.insertAndPlay(song);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 900;
            final ultraCompact = constraints.maxWidth < 560;
            return Row(
              children: [
                SizedBox(
                  width: 30,
                  child: Text(
                    '$index',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      if (!ultraCompact) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: ArtworkImage(
                            id: song.id,
                            size: 80,
                            width: 40,
                            height: 40,
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              song.title ?? '-',
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: .bold,
                              ),
                            ),
                            Text(
                              song.artist ?? '-',
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    _formatDuration(song.duration),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                if (!compact) ...[
                  Expanded(
                    flex: 3,
                    child: Text(
                      song.album ?? '-',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      song.genre ?? '-',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${song.year ?? ''}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                  Icon(
                    Icons.favorite_border_rounded,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.4,
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '0:00';
    final int m = seconds ~/ 60;
    final String s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
