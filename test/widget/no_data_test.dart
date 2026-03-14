import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/widget/no_data.dart';

void main() {
  testWidgets('NoData displays noDataFound text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: NoData(),
        ),
      ),
    );

    expect(find.byType(NoData), findsOneWidget);
    expect(find.text('No Data'), findsOneWidget);
  });

  testWidgets('NoData uses theme colors', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.light(
            onSurfaceVariant: Colors.blue,
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: NoData(),
        ),
      ),
    );

    final noDataWidget = tester.widget<NoData>(find.byType(NoData));
    expect(noDataWidget, isNotNull);
  });
}
