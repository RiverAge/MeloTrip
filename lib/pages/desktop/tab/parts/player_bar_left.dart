part of '../tab_page.dart';

class _DesktopPlayerBarLeft extends StatelessWidget {
  const _DesktopPlayerBarLeft({
    required this.current,
    required this.onToggleFullPlayer,
  });

  final SongEntity? current;
  final VoidCallback onToggleFullPlayer;

  @override
  Widget build(BuildContext context) {
    if (current == null) return const SizedBox.shrink();

    return Row(
      children: [
        _PlayerBarArtwork(id: current!.id, onTap: onToggleFullPlayer),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              _HoverText(
                text: current!.title ?? '-',
                onTap: onToggleFullPlayer,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: .w600,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              _HoverText(
                text: current!.displayArtist ?? '-',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.2,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              _HoverText(
                text: current!.album ?? '-',
                style: TextStyle(
                  fontSize: 11,
                  height: 1.2,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: .7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayerBarArtwork extends StatelessWidget {
  const _PlayerBarArtwork({required this.id, required this.onTap});
  final String? id;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: ArtworkImage(
            id: id,
            width: 46,
            height: 46,
            size: 200,
            fit: .cover,
          ),
        ),
      ),
    );
  }
}

class _HoverText extends StatefulWidget {
  const _HoverText({required this.text, required this.style, this.onTap});

  final String text;
  final TextStyle style;
  final VoidCallback? onTap;

  @override
  State<_HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<_HoverText> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          maxLines: 1,
          overflow: .ellipsis,
          style: widget.style.copyWith(
            color: _isHovering
                ? Theme.of(context).colorScheme.primary
                : widget.style.color,
            decoration: _isHovering
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: .5),
          ),
        ),
      ),
    );
  }
}
