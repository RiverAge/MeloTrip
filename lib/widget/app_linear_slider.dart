import 'dart:math' as math;

import 'package:flutter/material.dart';

class AppLinearSlider extends StatefulWidget {
  const AppLinearSlider({
    super.key,
    required this.value,
    this.secondaryValue,
    this.min = 0,
    this.max = 1,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.activeColor,
    this.inactiveColor,
    this.secondaryActiveColor,
    this.thumbColor,
    this.trackHeight = 4,
    this.thumbRadius = 6,
    this.minTouchHeight = 28,
    this.padding = EdgeInsets.zero,
  }) : assert(min <= max),
       assert(trackHeight > 0),
       assert(thumbRadius >= 0),
       assert(minTouchHeight > 0);

  final double value;
  final double? secondaryValue;
  final double min;
  final double max;
  final ValueChanged<double>? onChanged;
  final ValueChanged<double>? onChangeStart;
  final ValueChanged<double>? onChangeEnd;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? secondaryActiveColor;
  final Color? thumbColor;
  final double trackHeight;
  final double thumbRadius;
  final double minTouchHeight;
  final EdgeInsetsGeometry padding;

  @override
  State<AppLinearSlider> createState() => _AppLinearSliderState();
}

class _AppLinearSliderState extends State<AppLinearSlider> {
  bool _isInteracting = false;
  double? _interactionValue;

  bool get _enabled => widget.onChanged != null && widget.max > widget.min;

  double get _effectiveValue {
    return (_interactionValue ?? widget.value).clamp(widget.min, widget.max);
  }

  double _ratioForValue(double value) {
    if (widget.max == widget.min) {
      return 0;
    }
    return ((value - widget.min) / (widget.max - widget.min)).clamp(0.0, 1.0);
  }

  double _valueForPosition({
    required double dx,
    required double width,
    required EdgeInsets padding,
  }) {
    final double left = padding.left + widget.thumbRadius;
    final double right = math.max(
      left,
      width - padding.right - widget.thumbRadius,
    );
    final double trackWidth = math.max(1, right - left);
    final double ratio = ((dx - left) / trackWidth).clamp(0.0, 1.0);
    return widget.min + ratio * (widget.max - widget.min);
  }

  void _emitValue(double value) {
    final double next = value.clamp(widget.min, widget.max);
    setState(() {
      _interactionValue = next;
    });
    widget.onChanged?.call(next);
  }

  void _handlePointerDown({
    required PointerDownEvent event,
    required double width,
    required EdgeInsets padding,
  }) {
    if (!_enabled) {
      return;
    }
    setState(() {
      _isInteracting = true;
      _interactionValue = widget.value.clamp(widget.min, widget.max);
    });
    widget.onChangeStart?.call(_effectiveValue);
    _emitValue(
      _valueForPosition(
        dx: event.localPosition.dx,
        width: width,
        padding: padding,
      ),
    );
  }

  void _handlePointerMove({
    required PointerMoveEvent event,
    required double width,
    required EdgeInsets padding,
  }) {
    if (!_enabled || !_isInteracting) {
      return;
    }
    _emitValue(
      _valueForPosition(
        dx: event.localPosition.dx,
        width: width,
        padding: padding,
      ),
    );
  }

  void _finishInteraction() {
    if (!_isInteracting) {
      return;
    }
    final double value = _effectiveValue;
    setState(() {
      _isInteracting = false;
      _interactionValue = null;
    });
    widget.onChangeEnd?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color activeColor = widget.activeColor ?? colorScheme.primary;
    final Color inactiveColor =
        widget.inactiveColor ?? colorScheme.onSurface.withValues(alpha: 0.18);
    final Color secondaryActiveColor =
        widget.secondaryActiveColor ?? activeColor.withValues(alpha: 0.28);
    final Color thumbColor = widget.thumbColor ?? activeColor;
    final EdgeInsets padding = widget.padding.resolve(
      Directionality.of(context),
    );
    final double contentHeight = math.max(
      widget.trackHeight,
      widget.thumbRadius * 2,
    );
    final double height = math.max(
      widget.minTouchHeight,
      padding.vertical + contentHeight,
    );

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 144;
        return MouseRegion(
          cursor: _enabled ? SystemMouseCursors.click : MouseCursor.defer,
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (PointerDownEvent event) => _handlePointerDown(
              event: event,
              width: width,
              padding: padding,
            ),
            onPointerMove: (PointerMoveEvent event) => _handlePointerMove(
              event: event,
              width: width,
              padding: padding,
            ),
            onPointerUp: (_) => _finishInteraction(),
            onPointerCancel: (_) => _finishInteraction(),
            child: SizedBox(
              width: width,
              height: height,
              child: CustomPaint(
                painter: _AppLinearSliderPainter(
                  valueRatio: _ratioForValue(_effectiveValue),
                  secondaryRatio: widget.secondaryValue == null
                      ? null
                      : _ratioForValue(widget.secondaryValue!),
                  activeColor: activeColor,
                  inactiveColor: inactiveColor,
                  secondaryActiveColor: secondaryActiveColor,
                  thumbColor: thumbColor,
                  trackHeight: widget.trackHeight,
                  thumbRadius: widget.thumbRadius,
                  padding: padding,
                  enabled: _enabled,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AppLinearSliderPainter extends CustomPainter {
  const _AppLinearSliderPainter({
    required this.valueRatio,
    required this.secondaryRatio,
    required this.activeColor,
    required this.inactiveColor,
    required this.secondaryActiveColor,
    required this.thumbColor,
    required this.trackHeight,
    required this.thumbRadius,
    required this.padding,
    required this.enabled,
  });

  final double valueRatio;
  final double? secondaryRatio;
  final Color activeColor;
  final Color inactiveColor;
  final Color secondaryActiveColor;
  final Color thumbColor;
  final double trackHeight;
  final double thumbRadius;
  final EdgeInsets padding;
  final bool enabled;

  @override
  void paint(Canvas canvas, Size size) {
    final double left = padding.left + thumbRadius;
    final double right = math.max(
      left,
      size.width - padding.right - thumbRadius,
    );
    final double centerY = size.height / 2;
    final Radius radius = Radius.circular(trackHeight / 2);
    final Rect trackRect = Rect.fromLTRB(
      left,
      centerY - trackHeight / 2,
      right,
      centerY + trackHeight / 2,
    );

    final Paint paint = Paint()..color = inactiveColor;
    canvas.drawRRect(RRect.fromRectAndRadius(trackRect, radius), paint);

    final double activeRight = left + (right - left) * valueRatio;
    final double? secondary = secondaryRatio;
    if (secondary != null) {
      paint.color = secondaryActiveColor;
      final double secondaryRight = left + (right - left) * secondary;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(left, trackRect.top, secondaryRight, trackRect.bottom),
          radius,
        ),
        paint,
      );
    }

    paint.color = enabled ? activeColor : activeColor.withValues(alpha: 0.5);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(left, trackRect.top, activeRight, trackRect.bottom),
        radius,
      ),
      paint,
    );

    if (thumbRadius > 0) {
      paint.color = enabled ? thumbColor : thumbColor.withValues(alpha: 0.5);
      canvas.drawCircle(Offset(activeRight, centerY), thumbRadius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _AppLinearSliderPainter oldDelegate) {
    return valueRatio != oldDelegate.valueRatio ||
        secondaryRatio != oldDelegate.secondaryRatio ||
        activeColor != oldDelegate.activeColor ||
        inactiveColor != oldDelegate.inactiveColor ||
        secondaryActiveColor != oldDelegate.secondaryActiveColor ||
        thumbColor != oldDelegate.thumbColor ||
        trackHeight != oldDelegate.trackHeight ||
        thumbRadius != oldDelegate.thumbRadius ||
        padding != oldDelegate.padding ||
        enabled != oldDelegate.enabled;
  }
}
