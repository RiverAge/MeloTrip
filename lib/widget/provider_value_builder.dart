import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:melo_trip/helper/app_failure_log.dart';
import 'package:melo_trip/helper/app_failure_message.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';
import 'package:melo_trip/widget/no_data.dart';

class AsyncValueBuilder<T> extends StatelessWidget {
  const AsyncValueBuilder({
    super.key,
    required this.provider,
    this.builder,
    this.loading,
    this.empty,
  });

  final ProviderListenable<AsyncValue<T?>> provider;

  final Widget Function(BuildContext context, T data, WidgetRef ref)? builder;
  final Widget Function(BuildContext context, WidgetRef ref)? loading;
  final Widget Function(BuildContext context, WidgetRef ref)? empty;

  @override
  Widget build(BuildContext context) => Consumer(
    builder: (context, ref, child) => ref
        .watch(provider)
        .when(
          loading: () => loading == null
              ? const FixedCenterCircular()
              : loading!(context, ref),
          error: (error, stack) {
            final failure = error is AppFailure
                ? error
                : AppFailure.from(error, stack);
            logAppFailure(
              failure,
              scope: 'async_value_builder',
              error: error,
              stackTrace: stack,
            );
            return _Error(failure: failure);
          },
          data: (value) {
            if (value case Result(isErr: true, :final error)) {
              final failure = error is AppFailure
                  ? error
                  : AppFailure.from(error);
              return _Error(failure: failure);
            }
            if (value == null) {
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
  const _Error({required this.failure});

  final AppFailure failure;

  String _resolveMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return resolveAppFailureMessage(l10n, failure: failure);
  }

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(_resolveMessage(context)),
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
