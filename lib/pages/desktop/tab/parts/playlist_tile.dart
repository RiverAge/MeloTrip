part of '../tab_page.dart';

class _PlaylistTile extends StatefulWidget {
  const _PlaylistTile({
    required this.item,
    required this.selected,
    this.onTap,
  });

  final PlaylistEntity item;
  final bool selected;
  final VoidCallback? onTap;

  @override
  State<_PlaylistTile> createState() => _PlaylistTileState();
}

class _PlaylistTileState extends State<_PlaylistTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final activeColor = colorScheme.primary.withValues(alpha: .2);
    final hoverColor = colorScheme.primary.withValues(alpha: .1);
    final hoverBorder = colorScheme.outlineVariant.withValues(alpha: .45);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: MouseRegion(
        cursor: widget.onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: DesktopMotionTokens.fast,
            curve: DesktopMotionTokens.standardCurve,
            decoration: BoxDecoration(
              color: widget.selected
                  ? activeColor
                  : _hovered
                  ? hoverColor
                  : theme.colorScheme.surface.withValues(alpha: 0),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.selected || _hovered
                    ? hoverBorder
                    : Colors.transparent,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: ArtworkImage(
                    id: widget.item.coverArt ?? widget.item.id,
                    width: 28,
                    height: 28,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.item.name ?? '-',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: widget.selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.library_music_rounded,
                            size: 11,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: .86),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${widget.item.songCount ?? 0} ${AppLocalizations.of(context)!.songCountUnit}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 10,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.schedule_rounded,
                            size: 11,
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: .86),
                          ),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              durationFormatter(widget.item.duration),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 10,
                                color: theme.colorScheme.onSurfaceVariant,
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
        ),
      ),
    );
  }
}
