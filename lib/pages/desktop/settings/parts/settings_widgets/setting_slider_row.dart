part of '../settings_widgets.dart';

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
