part of '../tab_page.dart';

class _PlaylistTile extends StatelessWidget {
  const _PlaylistTile({required this.item});

  final PlaylistEntity item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        final state = context.findAncestorStateOfType<_DesktopTabPageState>();
        final navigator = state?.contentNavigatorKey.currentState;
        assert(
          navigator != null,
          'Desktop content navigator is not available for playlist routing.',
        );
        navigator?.pushNamed('/playlist_detail', arguments: item.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: ArtworkImage(
                id: item.coverArt ?? item.id,
                width: 28,
                height: 28,
                fit: .cover,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    item.name ?? '-',
                    maxLines: 1,
                    overflow: .ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.library_music_rounded,
                        size: 11,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: .86),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${item.songCount ?? 0} ${AppLocalizations.of(context)!.songCountUnit}',
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.schedule_rounded,
                        size: 11,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurfaceVariant.withValues(alpha: .86),
                      ),
                      const SizedBox(width: 3),
                      Expanded(
                        child: Text(
                          durationFormatter(item.duration),
                          maxLines: 1,
                          overflow: .ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
