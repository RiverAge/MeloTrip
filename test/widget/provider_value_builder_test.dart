import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

final _resultErrorProvider = Provider<AsyncValue<Result<int, AppFailure>?>>(
  (_) => const AsyncValue.data(
    Result.err(
      AppFailure(
        type: AppFailureType.network,
        message: 'socket timeout',
      ),
    ),
  ),
);

final _asyncErrorProvider = Provider<AsyncValue<int?>>(
  (_) => const AsyncValue.error(
    AppFailure(
      type: AppFailureType.server,
      message: 'server unavailable',
    ),
    StackTrace.empty,
  ),
);

void main() {
  testWidgets('AsyncValueBuilder maps Result.err AppFailure to localized message', (
    tester,
  ) async {
    var builderCalled = false;
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AsyncValueBuilder<Result<int, AppFailure>>(
              provider: _resultErrorProvider,
              builder: (_, _, _) {
                builderCalled = true;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(builderCalled, isFalse);
    expect(
      find.text('Network connection failed. Please check your network and try again.'),
      findsOneWidget,
    );
  });

  testWidgets('AsyncValueBuilder maps AsyncError AppFailure to localized message', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AsyncValueBuilder<int>(
              provider: _asyncErrorProvider,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text('Server is temporarily unavailable. Please try again later.'),
      findsOneWidget,
    );
  });
}
