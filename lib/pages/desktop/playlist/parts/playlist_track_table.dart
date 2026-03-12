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
            SizedBox(
              width: 40,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          song.artist ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: .7),
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
                _formatSec(song.duration ?? 0),
                style: theme.textTheme.bodySmall,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                song.album ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                song.genre ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .4),
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
