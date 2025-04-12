import 'package:flutter/material.dart';

class FutureStreamBuilder<T> extends StatelessWidget {
  final Future<Stream<T>> future;
  final Widget? placeholder;
  final Widget Function(BuildContext context, T data) builder;

  const FutureStreamBuilder(
      {super.key,
      required this.future,
      required this.builder,
      this.placeholder});

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: future,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return placeholder ?? const SizedBox.shrink();
        }
        final data = snapshot.data;
        if (data == null) {
          return placeholder ?? const SizedBox.shrink();
        }

        return StreamBuilder(
            stream: data,
            builder: (sctx, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return placeholder ?? const SizedBox.shrink();
              }
              final stream = snap.data;
              if (stream == null) {
                return placeholder ?? const SizedBox.shrink();
              }

              return builder(sctx, stream);
            });
      });
}
