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
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(
      context,
    ).colorScheme.primary.withValues(alpha: .2);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Tooltip(
        message: title,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: selected ? activeColor : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 10),
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}