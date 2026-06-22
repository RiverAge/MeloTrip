part of '../home_page.dart';

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.onRefresh,
    this.refreshTooltip,
    this.isRefreshing = false,
    this.onViewAll,
    this.viewAllTooltip,
    this.onScrollBack,
    this.onScrollForward,
  });

  final String title;
  final VoidCallback? onRefresh;
  final String? refreshTooltip;
  final bool isRefreshing;
  final VoidCallback? onViewAll;
  final String? viewAllTooltip;
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
          if (onViewAll != null) ...[
            _ScrollButton(
              icon: Icons.open_in_full_rounded,
              onPressed: onViewAll,
              tooltip: viewAllTooltip,
            ),
            const SizedBox(width: 8),
          ],
          if (onRefresh != null) ...[
            _ScrollButton(
              icon: Icons.refresh_rounded,
              onPressed: isRefreshing ? null : onRefresh,
              tooltip: refreshTooltip,
              isLoading: isRefreshing,
            ),
            const SizedBox(width: 8),
          ],
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
  const _ScrollButton({
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.isLoading = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onPressed != null;
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: isLoading
          ? SizedBox.square(
              dimension: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.8,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          : Icon(
              icon,
              size: 12,
              color: theme.colorScheme.onSurfaceVariant.withValues(
                alpha: enabled ? 1.0 : 0.3,
              ),
            ),
      style: IconButton.styleFrom(
        backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: enabled || isLoading ? 0.5 : 0.2,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.all(6),
        minimumSize: const Size(24, 24),
      ),
    );
  }
}
