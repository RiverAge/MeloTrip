import 'package:flutter/material.dart';

const double _kSettingLabelMaxWidth = 180;

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

class SettingSliderRow extends StatefulWidget {
  const SettingSliderRow({
    super.key,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.onPreviewChanged,
    this.onSubmitted,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final ValueChanged<double>? onPreviewChanged;
  final ValueChanged<double>? onSubmitted;

  @override
  State<SettingSliderRow> createState() => _SettingSliderRowState();
}

class _SettingSliderRowState extends State<SettingSliderRow> {
  late double _displayValue;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant SettingSliderRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging && oldWidget.value != widget.value) {
      _displayValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: .center,
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _kSettingLabelMaxWidth),
            child: Text(
              widget.label,
              style: theme.textTheme.titleSmall,
              maxLines: 2,
              overflow: .ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 4,
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 14,
                      ),
                    ),
                    child: Slider(
                      value: _displayValue,
                      min: widget.min,
                      max: widget.max,
                      onChangeStart: (_) {
                        setState(() {
                          _isDragging = true;
                        });
                      },
                      onChangeEnd: (_) {
                        final ValueChanged<double>? onSubmitted =
                            widget.onSubmitted;
                        setState(() {
                          _isDragging = false;
                        });
                        if (onSubmitted != null) {
                          onSubmitted(_displayValue);
                        }
                      },
                      onChanged: (double value) {
                        setState(() {
                          _displayValue = value;
                        });
                        widget.onPreviewChanged?.call(value);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.55,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    child: Text(
                      _displayValue.toStringAsFixed(2),
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.92,
                        ),
                        fontWeight: .w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingColorRow extends StatelessWidget {
  const SettingColorRow({
    super.key,
    required this.label,
    required this.value,
    required this.palette,
    required this.onChanged,
    this.tooltipForColor,
  });

  final String label;
  final int value;
  final List<int> palette;
  final ValueChanged<int> onChanged;
  final String Function(int color)? tooltipForColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: .center,
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _kSettingLabelMaxWidth),
            child: Text(
              label,
              style: theme.textTheme.titleSmall,
              maxLines: 2,
              overflow: .ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 10,
              runSpacing: 10,
              children: palette.map((int color) {
                final bool active = color == value;
                final Color swatchColor = Color(color);
                return Tooltip(
                  message: tooltipForColor?.call(color) ?? '',
                  child: IconButton(
                    onPressed: () => onChanged(color),
                    icon: active
                        ? Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: theme.colorScheme.onPrimary,
                          )
                        : const SizedBox.shrink(),
                    visualDensity: VisualDensity.compact,
                    style: IconButton.styleFrom(
                      backgroundColor: active
                          ? swatchColor
                          : swatchColor.withValues(alpha: 0.82),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(
                          color: active
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outlineVariant.withValues(
                                  alpha: 0.45,
                                ),
                          width: active ? 2.0 : 1.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(6),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SettingSingleChoiceOption<T> {
  const SettingSingleChoiceOption({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final IconData? icon;
}

class SettingSingleChoiceRow<T> extends StatelessWidget {
  const SettingSingleChoiceRow({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final T value;
  final List<SettingSingleChoiceOption<T>> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: .center,
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _kSettingLabelMaxWidth),
            child: Text(
              label,
              style: theme.textTheme.titleSmall,
              maxLines: 2,
              overflow: .ellipsis,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: RadioGroup<T>(
              groupValue: value,
              onChanged: (T? next) {
                if (next == null) return;
                onChanged(next);
              },
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: 6,
                runSpacing: 6,
                children: options.map((SettingSingleChoiceOption<T> option) {
                  final bool selected = option.value == value;
                  final Color borderColor = selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.72,
                        );
                  final Color backgroundColor = selected
                      ? theme.colorScheme.primaryContainer.withValues(
                          alpha: 0.7,
                        )
                      : theme.colorScheme.surfaceContainerLow.withValues(
                          alpha: 0.9,
                        );
                  final Color textColor = selected
                      ? theme.colorScheme.onPrimaryContainer.withValues(
                          alpha: 0.82,
                        )
                      : theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.82,
                        );
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (option.icon != null) ...[
                          Icon(option.icon, size: 14, color: textColor),
                          const SizedBox(width: 6),
                        ],
                        Text(option.label),
                      ],
                    ),
                    selected: selected,
                    onSelected: (_) => onChanged(option.value),
                    showCheckmark: false,
                    selectedColor: backgroundColor,
                    backgroundColor: backgroundColor,
                    side: BorderSide(color: borderColor, width: 1.2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                      color: textColor,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
