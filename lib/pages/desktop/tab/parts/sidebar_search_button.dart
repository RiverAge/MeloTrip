part of '../tab_page.dart';

class _SidebarSearchButton extends StatelessWidget {
  const _SidebarSearchButton({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return OutlinedButton(
      onPressed: () {
        showDialog(
          context: context,
          barrierColor: colorScheme.scrim.withValues(alpha: 0.4),
          builder: (_) => const SearchCommandPalette(),
        );
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.28,
        ),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              l10n.searchHint,
              maxLines: 1,
              overflow: .ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.6,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(
                alpha: 0.1,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.menu_rounded, size: 14),
          ),
        ],
      ),
    );
  }
}
