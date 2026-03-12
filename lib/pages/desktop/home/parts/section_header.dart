part of '../home_page.dart';

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.onScrollBack,
    this.onScrollForward,
  });

  final String title;
  final VoidCallback? onScrollBack;
  final VoidCallback? onScrollForward;

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
                fontWeight: .w900,
                fontSize: 22,
                letterSpacing: -0.8,
              ),
              maxLines: 1,
              overflow: .ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          const Spacer(),
          const SizedBox(width: 10),
          _ScrollButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onPressed: onScrollBack,
          ),
          const SizedBox(width: 8),
          _ScrollButton(
            icon: Icons.arrow_forward_ios_rounded,
            onPressed: onScrollForward,
          ),
        ],
      ),
    );
  }
}

class _ScrollButton extends StatelessWidget {
  const _ScrollButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final enabled = onPressed != null;
    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: enabled ? (isDark ? 0.28 : 0.72) : (isDark ? 0.08 : 0.24),
      ),
      borderRadius: BorderRadius.circular(4),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              icon,
              size: 12,
              color: theme.colorScheme.onSurfaceVariant.withValues(
                alpha: enabled ? 1.0 : 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
