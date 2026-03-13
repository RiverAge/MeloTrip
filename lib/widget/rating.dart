import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  const Rating({
    super.key,
    required this.rating,
    required this.onRating,
    this.color,
  });
  final int? rating;
  final void Function(int rating) onRating;
  final Color? color;
  @override
  State<StatefulWidget> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int _counter = 0;
  int? _hoverRating;

  final GlobalKey _key = GlobalKey();
  bool _isDragging = false;

  int _clampRating(int value) => value.clamp(0, 5);

  void _setDragRating(PointerEvent details) {
    final RenderBox? box = _key.currentContext?.findRenderObject() as RenderBox?;
    final Offset? position = box?.localToGlobal(Offset.zero);
    final double starWidth = (box?.size.width ?? 0) / 5;
    final double relativeOffsetDx = details.position.dx - (position?.dx ?? 0);
    final int nextRating = _clampRating((relativeOffsetDx / starWidth).ceil());
    setState(() {
      _counter = nextRating;
    });
  }

  void _beginDrag(PointerDownEvent event) {
    setState(() {
      _counter = widget.rating ?? 0;
      _isDragging = true;
    });
    _setDragRating(event);
  }

  void _commitRating() {
    final nextRating = _clampRating(_counter);
    widget.onRating(nextRating);
    setState(() {
      _isDragging = false;
      _counter = widget.rating ?? 0;
      _hoverRating = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRating =
        _isDragging ? _counter : _hoverRating ?? widget.rating ?? 0;
    final baseColor = widget.color ?? Theme.of(context).colorScheme.primary;
    final color = baseColor.withValues(alpha: _isDragging ? 0.5 : 1);

    return Listener(
      onPointerDown: _beginDrag,
      onPointerUp: (_) => _commitRating(),
      onPointerCancel: (_) => _commitRating(),
      onPointerMove: _setDragRating,
      child: Row(
        key: _key,
        children: List.generate(5, (index) {
          final starRating = index + 1;
          return MouseRegion(
            onEnter: (_) {
              if (_isDragging) return;
              setState(() {
                _hoverRating = starRating;
              });
            },
            onExit: (_) {
              if (_isDragging) return;
              setState(() {
                _hoverRating = null;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Icon(
                starRating <= effectiveRating
                    ? Icons.star_rounded
                    : Icons.star_border_rounded,
                color: color,
                size: 14,
              ),
            ),
          );
        }),
      ),
    );
  }
}
