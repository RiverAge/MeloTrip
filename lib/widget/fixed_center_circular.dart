import 'package:flutter/material.dart';

class FixedCenterCircular extends StatelessWidget {
  const FixedCenterCircular({super.key, this.strokeWidth = 4, this.size = 30});

  final double strokeWidth;
  final double size;

  @override
  Widget build(BuildContext context) => Center(
          child: SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
        ),
      ));
}
