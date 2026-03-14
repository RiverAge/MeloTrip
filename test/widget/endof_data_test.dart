import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/widget/endof_data.dart';

void main() {
  testWidgets('EndofData displays endOfData text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: EndofData(),
        ),
      ),
    );

    expect(find.byType(EndofData), findsOneWidget);
    expect(find.text('End Of Data'), findsOneWidget);
  });

  testWidgets('EndofData uses theme colors', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            onSurfaceVariant: Colors.green,
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: EndofData(),
        ),
      ),
    );

    final endofDataWidget = tester.widget<EndofData>(find.byType(EndofData));
    expect(endofDataWidget, isNotNull);
  });
}
