import 'package:flutter/material.dart';

class GestureHint extends StatelessWidget {
  const GestureHint({super.key});

  @override
  Widget build(BuildContext context) => Container(
    margin: EdgeInsets.only(top: 8),
    height: 5,
    width: 40,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onSurfaceVariant.withAlpha(50),
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );
}
