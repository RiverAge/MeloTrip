part of '../playlist_detail_page.dart';

class PlaylistTrackRow extends StatelessWidget {
  const PlaylistTrackRow({
    required this.index,
    required this.song,
    required this.onTap,
    super.key,
  });

  final int index;
  final SongEntity song;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: .centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 40),
                  child: Text(
                    '$index',
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
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
                  const SizedBox(width: 12),
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
            Expanded(
              child: Align(
                alignment: .centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 72),
                  child: Text(
                    _formatSec(song.duration ?? 0),
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
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
            Expanded(
              child: Align(
                alignment: .centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 72),
                  child: Text(
                    '${song.year ?? ''}',
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.favorite_border_rounded,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSec(int sec) {
    final String m = (sec ~/ 60).toString().padLeft(1, '0');
    final String s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
