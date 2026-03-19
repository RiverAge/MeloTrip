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
    final enabled = onPressed != null;
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 12,
        color: theme.colorScheme.onSurfaceVariant.withValues(
          alpha: enabled ? 1.0 : 0.3,
        ),
      ),
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: enabled ? 0.5 : 0.2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.all(6),
        minimumSize: const Size(24, 24),
      ),
    );
  }
}
