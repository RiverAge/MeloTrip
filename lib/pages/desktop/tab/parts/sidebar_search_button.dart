part of '../tab_page.dart';

class _SidebarSearchButton extends StatelessWidget {
  const _SidebarSearchButton({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const DesktopSearchPage()),
        );
      },
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withValues(alpha: .06) : Colors.black.withValues(alpha: .04),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Icon(
              Icons.search_rounded,
              size: 18,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .8),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '搜索',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .6),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(Icons.menu_rounded, size: 14),
            ),
          ],
        ),
      ),
    );
  }
}