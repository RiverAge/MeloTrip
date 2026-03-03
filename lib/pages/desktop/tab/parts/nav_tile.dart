part of '../tab_page.dart';

class _NavTile extends StatefulWidget {
  const _NavTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final activeColor = colorScheme.primary.withValues(alpha: .2);
    final hoverColor = colorScheme.primary.withValues(alpha: .1);
    final hoverBorder = colorScheme.outlineVariant.withValues(alpha: .45);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: widget.selected
                  ? activeColor
                  : _hovered
                  ? hoverColor
                  : colorScheme.surface.withValues(alpha: 0),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: widget.selected || _hovered
                    ? hoverBorder
                    : Colors.transparent,
              ),
            ),
            child: Row(
              children: [
                Icon(widget.icon, size: 18),
                const SizedBox(width: 10),
                Text(widget.title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
