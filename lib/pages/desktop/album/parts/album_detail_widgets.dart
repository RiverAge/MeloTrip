part of '../album_detail_page.dart';

class _HeaderOutlineButton extends StatelessWidget {
  const _HeaderOutlineButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.2)),
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
    );
  }
}

class _TrackListTile extends StatelessWidget {
  const _TrackListTile({
    required this.index,
    required this.song,
    required this.onPlay,
  });

  final int index;
  final SongEntity song;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: onPlay,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 30,
              child: Text(
                '$index',
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: 0.6,
                  ),
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: Text(
                song.title ?? '-',
                maxLines: 1,
                overflow: .ellipsis,
                style: TextStyle(
                  fontWeight: .w600,
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatSec(song.duration ?? 0),
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.6,
                ),
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 40),
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
    final String m = (sec ~/ 60).toString();
    final String s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _MiniAlbumCard extends StatelessWidget {
  const _MiniAlbumCard({required this.album});

  final AlbumEntity album;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: .start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: ArtworkImage(
                id: album.id,
                size: 300,
                width: 150,
                height: 150,
                fit: .cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              album.name ?? '',
              maxLines: 1,
              overflow: .ellipsis,
              style: TextStyle(
                fontWeight: .bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              album.artist ?? '',
              maxLines: 1,
              overflow: .ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            Text(
              '${album.year ?? ""}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
