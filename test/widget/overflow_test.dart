import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';
import 'package:melo_trip/widget/no_data.dart';

import '../widget_test_bootstrap.dart';

void main() {
  setUpOverflowGuard();

  group('NoData widget', () {
    testWidgets('renders without overflow on small screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: NoData()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(NoData), findsOneWidget);
      expectNoFlutterErrors();
    });

    testWidgets('renders without overflow on large screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1024, 768));

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: NoData()),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(NoData), findsOneWidget);
      expectNoFlutterErrors();
    });
  });

  group('FixedCenterCircular widget', () {
    testWidgets('renders without overflow on small screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FixedCenterCircular()),
        ),
      );

      // Use pump instead of pumpAndSettle because CircularProgressIndicator
      // has an infinite animation.
      await tester.pump();

      expect(find.byType(FixedCenterCircular), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expectNoFlutterErrors();
    });

    testWidgets('renders without overflow on large screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1024, 768));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: FixedCenterCircular()),
        ),
      );

      await tester.pump();

      expect(find.byType(FixedCenterCircular), findsOneWidget);
      expectNoFlutterErrors();
    });
  });
}
