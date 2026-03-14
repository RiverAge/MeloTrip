import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/widget/no_data.dart';

void main() {
  testWidgets('NoData widget renders correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('zh', 'CN'),
        ],
        home: Scaffold(
          body: NoData(),
        ),
      ),
    );

    expect(find.byType(NoData), findsOneWidget);
    expect(find.byType(Row), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);

    final row = tester.widget<Row>(find.byType(Row));
    expect(row.mainAxisAlignment, MainAxisAlignment.center);
    expect(row.crossAxisAlignment, CrossAxisAlignment.center);

    final containers = tester.widgetList<Container>(find.byType(Container));
    expect(containers.length, 2);
  });

  testWidgets('NoData widget has correct padding', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          ...AppLocalizations.localizationsDelegates,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('zh', 'CN'),
        ],
        home: Scaffold(
          body: NoData(),
        ),
      ),
    );

    final paddingFinder = find.byType(Padding).at(0);
    expect(paddingFinder, findsOneWidget);
  });
}
