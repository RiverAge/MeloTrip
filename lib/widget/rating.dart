import 'package:flutter/material.dart';

class Rating extends StatefulWidget {
  const Rating({super.key, required this.rating, required this.onRating});
  final int? rating;
  final void Function(int rating) onRating;
  @override
  State<StatefulWidget> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  int _counter = 0;
  int? _hoverRating;

  final GlobalKey _key = GlobalKey();
  bool _isDraging = false;

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

  @override
  Widget build(BuildContext context) {
    final effectiveRating =
        _isDraging ? _counter : _hoverRating ?? widget.rating ?? 0;
    final color = Theme.of(
      context,
    ).colorScheme.primary.withValues(alpha: _isDraging ? 0.5 : 1);

    return Listener(
      onPointerDown: (event) {
        setState(() {
          _counter = widget.rating ?? 0;
          _isDraging = true;
        });
        _setDragRating(event);
      },
      onPointerUp: (_) {
        final nextRating = _clampRating(_counter);
        widget.onRating(nextRating);
        setState(() {
          _isDraging = false;
          _counter = widget.rating ?? 0;
          _hoverRating = null;
        });
      },
      onPointerCancel: (_) {
        final nextRating = _clampRating(_counter);
        widget.onRating(nextRating);
        setState(() {
          _isDraging = false;
          _counter = widget.rating ?? 0;
          _hoverRating = null;
        });
      },
      onPointerMove: _setDragRating,
      child: Row(
        key: _key,
        children: List.generate(5, (index) {
          final starRating = index + 1;
          return MouseRegion(
            onEnter: (_) {
              if (_isDraging) return;
              setState(() {
                _hoverRating = starRating;
              });
            },
            onExit: (_) {
              if (_isDraging) return;
              setState(() {
                _hoverRating = null;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Icon(
                starRating <= effectiveRating
                    ? Icons.star
                    : Icons.star_outline,
                color: color,
                size: 15,
              ),
            ),
          );
        }),
      ),
    );
  }
}
