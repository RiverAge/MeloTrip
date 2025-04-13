import 'package:flutter/material.dart';

class FixedCenterCircular extends StatelessWidget {
  const FixedCenterCircular({super.key, this.strokeWidth = 2, this.size = 20});

  final double strokeWidth;
  final double size;

  @override
  Widget build(BuildContext context) => Center(
    child: SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(strokeWidth: strokeWidth),
    ),
  );
}
