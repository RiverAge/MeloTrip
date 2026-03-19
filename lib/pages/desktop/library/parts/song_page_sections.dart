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
    super.key,
  });

  final String title;
  final int count;

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

class SongTrackRow extends ConsumerStatefulWidget {
  const SongTrackRow({required this.index, required this.song, super.key});

  final int index;
  final SongEntity song;

  @override
  ConsumerState<SongTrackRow> createState() => _SongTrackRowState();
}

class _SongTrackRowState extends ConsumerState<SongTrackRow> {
  bool _isHovered = false;
  bool? _optimisticStarred;

  bool get _isStarred => _optimisticStarred ?? widget.song.starred != null;

  Future<void> _toggleFavorite() async {
    final original = _isStarred;
    setState(() => _optimisticStarred = !original);

    final res = await ref
        .read(songDetailProvider(widget.song.id).notifier)
        .toggleFavorite(currentlyStarred: original);
    if (!mounted) return;
    if (res == null || res.isErr) {
      setState(() => _optimisticStarred = original);
      return;
    }
    ref.invalidate(favoriteProvider);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final song = widget.song;
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: InkWell(
        onTap: () async {
          final player = await ref.read(appPlayerHandlerProvider.future);
          await player?.insertAndPlay(song);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final ultraCompact = constraints.maxWidth < 560;
              return Row(
                children: [
                  SizedBox(
                    width: 30,
                    child: Text(
                      '${widget.index}',
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
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: ArtworkImage(
                                  id: song.id,
                                  size: 80,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              if (_isHovered)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.scrim.withValues(
                                        alpha: 0.4,
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        color: theme.colorScheme.onInverseSurface,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
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
                  IconButton(
                    onPressed: _toggleFavorite,
                    icon: Icon(
                      _isStarred
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 16,
                      color: _isStarred
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.45,
                            ),
                    ),
                    splashRadius: 16,
                    visualDensity: .compact,
                  ),
                ],
              );
            },
          ),
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

