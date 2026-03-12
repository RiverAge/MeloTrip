import 'package:flutter/material.dart';

class SettingSectionHeader extends StatelessWidget {
  const SettingSectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 4),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.label,
    required this.description,
    required this.trailing,
    this.progress,
  });

  final String label;
  final String description;
  final Widget trailing;
  final Widget? progress;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.7,
                      ),
                    ),
                  ),
                ],
                if (progress case final Widget progressWidget) progressWidget,
              ],
            ),
          ),
          const SizedBox(width: 12),
          trailing,
        ],
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
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              widget.label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Row(
              children: [
                Expanded(
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
                SizedBox(
                  width: 50,
                  child: Text(
                    _displayValue.toStringAsFixed(2),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.end,
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
  });

  final String label;
  final int value;
  final List<int> palette;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: palette.map((color) {
                final active = color == value;
                return InkWell(
                  onTap: () => onChanged(color),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Color(color),
                      border: Border.all(
                        color: active
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.outline.withValues(alpha: 0.5),
                        width: active ? 2.5 : 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
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
