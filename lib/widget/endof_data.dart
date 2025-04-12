import 'package:flutter/material.dart';

class EndofData extends StatelessWidget {
  const EndofData({super.key});

  @override
  Widget build(BuildContext context) {
    final color =
        Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: .5);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 50,
                height: 0.5,
                color: color,
                margin: const EdgeInsets.only(right: 5)),
            Text('到底了', style: TextStyle(color: color)),
            Container(
                width: 50,
                height: 0.5,
                color: color,
                margin: const EdgeInsets.only(left: 5)),
          ]),
    );
  }
}
