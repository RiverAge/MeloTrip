part of '../tab_page.dart';

class _PlaylistTile extends StatelessWidget {
  const _PlaylistTile({required this.item, required this.selected, this.onTap});

  final PlaylistEntity item;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final subtitleColor = colorScheme.onSurfaceVariant;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Material(
        type: .transparency,
        child: ListTile(
          onTap: onTap,
          selected: selected,
          dense: true,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          tileColor: colorScheme.surface.withValues(alpha: 0),
          hoverColor: colorScheme.primary.withValues(alpha: 0.1),
          selectedTileColor: colorScheme.primary.withValues(alpha: 0.2),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: ArtworkImage(
              id: item.coverArt ?? item.id,
              width: 28,
              height: 28,
              fit: .cover,
            ),
          ),
          title: Text(
            item.name ?? '-',
            maxLines: 1,
            overflow: .ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? .bold : .normal,
            ),
          ),
          subtitle: Row(
            children: [
              Icon(
                Icons.library_music_rounded,
                size: 11,
                color: subtitleColor.withValues(alpha: 0.86),
              ),
              const SizedBox(width: 3),
              Text(
                '${item.songCount ?? 0} ${AppLocalizations.of(context)!.songCountUnit}',
                maxLines: 1,
                overflow: .ellipsis,
                style: TextStyle(fontSize: 10, color: subtitleColor),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.schedule_rounded,
                size: 11,
                color: subtitleColor.withValues(alpha: 0.86),
              ),
              const SizedBox(width: 3),
              Expanded(
                child: Text(
                  durationFormatter(item.duration),
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: TextStyle(fontSize: 10, color: subtitleColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
