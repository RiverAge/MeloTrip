import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';
import 'package:melo_trip/widget/no_data.dart';

class AsyncValueBuilder<T> extends StatelessWidget {
  const AsyncValueBuilder({
    super.key,
    required this.provider,
    this.builder,
    this.nullableBuilder,
    this.loading,
    this.empty,
  });

  final ProviderListenable<AsyncValue<T?>> provider;

  final Widget Function(BuildContext context, T data, WidgetRef ref)? builder;
  final Widget Function(BuildContext context, T? data, WidgetRef ref)?
  nullableBuilder;
  final Widget Function(BuildContext context, WidgetRef ref)? loading;
  final Widget Function(BuildContext context, WidgetRef ref)? empty;

  @override
  Widget build(BuildContext context) => Consumer(
    builder:
        (context, ref, child) => ref
            .watch(provider)
            .when(
              loading:
                  () =>
                      loading == null
                          ? const FixedCenterCircular()
                          : loading!(context, ref),
              error: (error, stack) {
                debugPrintStack(stackTrace: stack);
                return const _Error();
              },
              data: (value) {
                if (nullableBuilder != null) {
                  return nullableBuilder!(context, value, ref);
                } else if (value == null) {
                  return empty != null ? empty!(context, ref) : const NoData();
                } else if (builder != null) {
                  return builder!(context, value, ref);
                }
                return SizedBox.shrink();
              },
            ),
  );
}

class _Error extends StatelessWidget {
  const _Error();
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(AppLocalizations.of(context)!.encounterUnknownError),
    ),
  );
}

class AsyncStreamBuilder<T> extends StatelessWidget {
  const AsyncStreamBuilder({
    super.key,
    required this.provider,
    required this.builder,
    this.loading,
    this.emptyBuilder,
  });

  final Stream<T> provider;
  final Widget Function(BuildContext context, T data) builder;
  final Widget Function(BuildContext context)? emptyBuilder;
  final Widget Function(BuildContext context)? loading;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: provider,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loading == null
              ? const FixedCenterCircular()
              : loading!(context);
        }
        final stream = snapshot.data;
        if (stream == null) {
          final effectiveEmptyBuilder = emptyBuilder;
          if (effectiveEmptyBuilder != null) {
            return effectiveEmptyBuilder(context);
          }
          return const NoData();
        }
        return builder(context, stream);
      },
    );
  }
}
