import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/tab/parts/search_command_palette.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp(Widget child) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  testWidgets('SearchCommandPalette renders localized content', (tester) async {
    await tester.pumpWidget(buildApp(const SearchCommandPalette()));
    await tester.pumpAndSettle();

    expect(find.text('Search History'), findsWidgets);
    expect(find.text('ESC'), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsWidgets);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('SearchCommandPalette close button dismisses dialog', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog<void>(
                      context: context,
                      barrierDismissible: false,
                      builder: (_) => const SearchCommandPalette(),
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(SearchCommandPalette), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.byType(SearchCommandPalette), findsNothing);
  });
}
