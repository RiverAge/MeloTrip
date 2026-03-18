part of '../tab_page.dart';

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: ListTile(
        onTap: onTap,
        selected: selected,
        dense: true,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        tileColor: colorScheme.surface.withValues(alpha: 0),
        hoverColor: colorScheme.primary.withValues(alpha: 0.1),
        selectedTileColor: colorScheme.primary.withValues(alpha: 0.2),
        leading: Icon(icon, size: 18),
        title: Text(title),
      ),
    );
  }
}
