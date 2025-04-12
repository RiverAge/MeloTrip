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

  final GlobalKey _key = GlobalKey();
  bool _isDraging = false;

  @override
  Widget build(BuildContext context) {
    final effectiveRating = _isDraging ? _counter : widget.rating ?? 0;
    return Listener(
      onPointerDown: (event) {
        setState(() {
          _counter = widget.rating ?? 0;
          _isDraging = true;
        });
      },
      onPointerUp: (event) {
        widget.onRating(_counter);
        setState(() {
          _isDraging = false;
          _counter = widget.rating ?? 0;
        });
      },
      onPointerCancel: (event) {
        widget.onRating(_counter);
        setState(() {
          _isDraging = false;
          _counter = widget.rating ?? 0;
        });
      },
      onPointerMove: (PointerEvent details) {
        RenderBox? box = _key.currentContext?.findRenderObject() as RenderBox?;

        Offset? position = box?.localToGlobal(Offset.zero);

        final starWidth = (box?.size.width ?? 0) / 10;
        final relativeOffsetDx = details.position.dx - (position?.dx ?? 0);
        setState(() {
          _counter = (relativeOffsetDx / starWidth / 2).round();
        });
      },
      child: Row(
        key: _key,
        children: List.generate(5, (index) {
          return Icon(
            (index + 1) <= effectiveRating ? Icons.star : Icons.star_outline,
            color: Theme.of(context)
                .colorScheme
                .primary
                .withValues(alpha: _isDraging ? 0.5 : 1),
            size: 15,
          );
        }),
      ),
    );
  }
}
