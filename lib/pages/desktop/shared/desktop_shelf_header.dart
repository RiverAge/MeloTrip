import 'package:flutter/material.dart';

/// Shared section header for desktop shelves.
///
/// Renders a bold title (optionally prefixed with an icon) on the left and a
/// trailing button group on the right. Trailing buttons are conditionally
/// rendered based on whether their callback is non-null:
/// view-all → play-all → refresh → scroll-back → scroll-forward.
class DesktopShelfHeader extends StatelessWidget {
  const DesktopShelfHeader({
    super.key,
    required this.title,
    this.icon,
    this.onRefresh,
    this.refreshTooltip,
    this.isRefreshing = false,
    this.onViewAll,
    this.viewAllTooltip,
    this.onPlayAll,
    this.playAllTooltip,
    this.onScrollBack,
    this.onScrollForward,
  });

  final String title;
  final IconData? icon;

  final VoidCallback? onRefresh;
  final String? refreshTooltip;
  final bool isRefreshing;

  final VoidCallback? onViewAll;
  final String? viewAllTooltip;

  final VoidCallback? onPlayAll;
  final String? playAllTooltip;

  final VoidCallback? onScrollBack;
  final VoidCallback? onScrollForward;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
          ],
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
            DesktopScrollButton(
              icon: Icons.open_in_full_rounded,
              onPressed: onViewAll,
              tooltip: viewAllTooltip,
            ),
            const SizedBox(width: 8),
          ],
          if (onPlayAll != null) ...[
            DesktopScrollButton(
              icon: Icons.play_arrow_rounded,
              onPressed: isRefreshing ? null : onPlayAll,
              tooltip: playAllTooltip,
            ),
            const SizedBox(width: 8),
          ],
          if (onRefresh != null) ...[
            DesktopScrollButton(
              icon: Icons.refresh_rounded,
              onPressed: isRefreshing ? null : onRefresh,
              tooltip: refreshTooltip,
              isLoading: isRefreshing,
              quiet: true,
            ),
            const SizedBox(width: 8),
          ],
          if (onScrollBack != null) ...[
            DesktopScrollButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onPressed: onScrollBack,
            ),
            const SizedBox(width: 8),
          ],
          if (onScrollForward != null)
            DesktopScrollButton(
              icon: Icons.arrow_forward_ios_rounded,
              onPressed: onScrollForward,
            ),
        ],
      ),
    );
  }
}

/// Compact icon button used by [DesktopShelfHeader] for trailing actions.
///
/// Supports a [quiet] variant (transparent background with subtle hover
/// feedback) and an inline [isLoading] state that swaps the icon for a small
/// spinner.
class DesktopScrollButton extends StatelessWidget {
  const DesktopScrollButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.tooltip,
    this.isLoading = false,
    this.quiet = false,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isLoading;
  final bool quiet;

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
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: quiet ? 0.72 : 1.0,
                ),
              ),
            )
          : Icon(
              icon,
              size: 12,
              color: theme.colorScheme.onSurfaceVariant.withValues(
                alpha: enabled ? (quiet ? 0.72 : 1.0) : 0.3,
              ),
            ),
      style: quiet
          ? _quietIconButtonStyle(theme, isLoading: isLoading)
          : IconButton.styleFrom(
              backgroundColor: theme.colorScheme.surfaceContainerHighest
                  .withValues(alpha: enabled || isLoading ? 0.5 : 0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(6),
              minimumSize: const Size(24, 24),
            ),
    );
  }

  static ButtonStyle _quietIconButtonStyle(
    ThemeData theme, {
    required bool isLoading,
  }) {
    return ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.12);
        }
        if (states.contains(WidgetState.hovered) ||
            states.contains(WidgetState.focused) ||
            isLoading) {
          return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.08);
        }
        return null;
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      padding: WidgetStateProperty.all(const EdgeInsets.all(6)),
      minimumSize: WidgetStateProperty.all(const Size(24, 24)),
    );
  }
}
