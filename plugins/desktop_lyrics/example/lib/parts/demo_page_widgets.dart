part of '../main.dart';

class _DemoSection extends StatelessWidget {
  const _DemoSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}

class _DemoSlider extends StatefulWidget {
  const _DemoSlider({
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
  State<_DemoSlider> createState() => _DemoSliderState();
}

class _DemoSliderState extends State<_DemoSlider> {
  late double _displayValue;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();
    _displayValue = widget.value;
  }

  @override
  void didUpdateWidget(covariant _DemoSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isDragging && oldWidget.value != widget.value) {
      _displayValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 170,
          child: Text('${widget.label} (${_displayValue.toStringAsFixed(2)})'),
        ),
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
              final ValueChanged<double>? onSubmitted = widget.onSubmitted;
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
      ],
    );
  }
}

class _DemoColorRow extends StatelessWidget {
  const _DemoColorRow({
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
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 170, child: Text(label)),
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: palette.map((color) {
                final active = color == value;
                return InkWell(
                  onTap: () => onChanged(color),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(color),
                      border: Border.all(
                        color: active
                            ? colorScheme.onSurface
                            : colorScheme.outline.withValues(alpha: 0.5),
                        width: active ? 2 : 1,
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
