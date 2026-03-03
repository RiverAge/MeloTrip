part of '../home_page.dart';

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onViewAll});

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: -0.8,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          if (onViewAll != null) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.refresh_rounded,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .5),
            ),
          ],
          const Spacer(),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: Text(
                AppLocalizations.of(context)!.viewAll,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .8),
                ),
              ),
            ),
          const SizedBox(width: 10),
          _ScrollButton(icon: Icons.arrow_back_ios_new_rounded, onPressed: () {}),
          const SizedBox(width: 8),
          _ScrollButton(icon: Icons.arrow_forward_ios_rounded, onPressed: () {}),
        ],
      ),
    );
  }
}

class _ScrollButton extends StatelessWidget {
  const _ScrollButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: isDark ? .28 : .72,
      ),
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 12, color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}
