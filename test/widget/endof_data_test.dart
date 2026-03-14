import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/widget/endof_data.dart';

void main() {
  group('EndofData widget', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
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
          home: const Scaffold(
            body: EndofData(),
          ),
        ),
      );

      expect(find.byType(EndofData), findsOneWidget);
      expect(find.byType(Row), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });
  });
}
