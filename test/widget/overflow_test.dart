import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';

void main() {
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
    });
  });

  group('FixedCenterCircular widget', () {
    testWidgets('renders without overflow on small screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 568));

      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(body: FixedCenterCircular()),
        ),
      );

      // Use pump instead of pumpAndSettle because CircularProgressIndicator has infinite animation
      await tester.pump();

      expect(find.byType(FixedCenterCircular), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders without overflow on large screen', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1024, 768));

      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(body: FixedCenterCircular()),
        ),
      );

      await tester.pump();

      expect(find.byType(FixedCenterCircular), findsOneWidget);
    });
  });
}
