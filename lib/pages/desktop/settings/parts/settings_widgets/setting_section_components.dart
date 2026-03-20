part of '../settings_widgets.dart';

class SettingSectionHeader extends StatelessWidget {
  const SettingSectionHeader({super.key, required this.title, this.icon});

  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
      child: Row(
        children: <Widget>[
          if (icon != null) ...[
            Icon(
              icon,
              size: 20,
              color: theme.colorScheme.primary.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 10),
          ],
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.normal,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingSectionCard extends StatelessWidget {
  const SettingSectionCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.48),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: child,
    );
  }
}

class SettingSectionBody extends StatelessWidget {
  const SettingSectionBody({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.symmetric(vertical: 4),
  });

  final List<Widget> children;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<Widget> sectionChildren = <Widget>[];
    for (int index = 0; index < children.length; index++) {
      final bool isLast = index == children.length - 1;
      sectionChildren.add(children[index]);
      if (!isLast) {
        sectionChildren.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Divider(
              height: 1,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.25),
            ),
          ),
        );
      }
    }
    return Padding(
      padding: padding,
      child: Column(crossAxisAlignment: .stretch, children: sectionChildren),
    );
  }
}

class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.label,
    this.description = '',
    this.trailing,
    this.progress,
    this.onTap,
  });

  final String label;
  final String description;
  final Widget? trailing;
  final Widget? progress;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Widget content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: .center,
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _kSettingLabelMaxWidth),
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: <Widget>[
                Text(
                  label,
                  style: theme.textTheme.titleSmall,
                  maxLines: 2,
                  overflow: .ellipsis,
                ),
                if (description.isNotEmpty) ...<Widget>[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: .ellipsis,
                  ),
                ],
                if (progress case final Widget progressWidget) ...<Widget>[
                  const SizedBox(height: 10),
                  progressWidget,
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Align(
              alignment: .centerRight,
              child: trailing ?? const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: content,
      ),
    );
  }
}
