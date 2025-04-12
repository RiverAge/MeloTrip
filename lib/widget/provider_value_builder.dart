import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';
import 'package:melo_trip/widget/no_data.dart';

class AsyncValueBuilder<T> extends StatelessWidget {
  const AsyncValueBuilder(
      {super.key,
      required this.provider,
      required this.builder,
      this.loading,
      this.empty});

  final ProviderListenable<AsyncValue<T?>> provider;

  final Widget Function(BuildContext context, T data, WidgetRef ref) builder;
  final Widget Function(BuildContext context, WidgetRef ref)? loading;
  final Widget Function(BuildContext context, WidgetRef ref)? empty;

  @override
  Widget build(BuildContext context) => Consumer(
      builder: (context, ref, child) => ref.watch(provider).when(
          loading: () => loading == null
              ? const FixedCenterCircular()
              : loading!(context, ref),
          error: (error, stack) {
            debugPrintStack(stackTrace: stack);
            return const _Error();
          },
          data: (value) => value == null
              ? empty != null
                  ? empty!(context, ref)
                  : const NoData()
              : builder(context, value, ref)));
}

class _Error extends StatelessWidget {
  const _Error();
  @override
  Widget build(BuildContext context) => const Center(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('遇到未知错误'),
      ));
}

class AsyncStreamBuilder<T> extends StatelessWidget {
  const AsyncStreamBuilder(
      {super.key,
      required this.provider,
      required this.builder,
      this.loading,
      this.emptyBuilder});

  final ProviderListenable<AsyncValue<Stream<T>?>> provider;
  final Widget Function(BuildContext context, T data, WidgetRef ref) builder;
  final Widget Function(BuildContext context, WidgetRef ref)? emptyBuilder;
  final Widget Function(BuildContext context, WidgetRef ref)? loading;

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: provider,
      builder: (context, data, ref) {
        return StreamBuilder(
            stream: data,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return loading == null
                    ? const FixedCenterCircular()
                    : loading!(context, ref);
              }
              final stream = snapshot.data;
              if (stream == null) {
                final effectiveEmptyBuilder = emptyBuilder;
                if (effectiveEmptyBuilder != null) {
                  return effectiveEmptyBuilder(context, ref);
                }
                return const NoData();
              }
              return builder(context, stream, ref);
            });
      },
      loading: loading,
    );
  }
}
