import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/mobile/home/home_page.dart';
import 'package:melo_trip/provider/album/albums.dart';

void main() {
  testWidgets('Localization delegates load', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SizedBox.shrink(),
      ),
    );

    expect(find.byType(SizedBox), findsOneWidget);
  });

  test('Supported locales include en and zh_CN', () {
    final locales = AppLocalizations.supportedLocales;
    expect(locales, contains(const Locale('en')));
    expect(locales, contains(const Locale('zh', 'CN')));
  });

  testWidgets('Home localization keys exist in en and zh_CN', (
    WidgetTester tester,
  ) async {
    String? enListenNow;
    String? zhListenNow;
    String? enGuessYouLike;
    String? zhGuessYouLike;

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            enListenNow = l10n.listenNow;
            enGuessYouLike = l10n.guessYouLike;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('zh', 'CN'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final l10n = AppLocalizations.of(context)!;
            zhListenNow = l10n.listenNow;
            zhGuessYouLike = l10n.guessYouLike;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(enListenNow, isNotEmpty);
    expect(zhListenNow, isNotEmpty);
    expect(enGuessYouLike, isNotEmpty);
    expect(zhGuessYouLike, isNotEmpty);
  });

  testWidgets('Home keeps recommendation placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          albumsProvider(.newest).overrideWith((_) async => null),
          albumsProvider(.recent).overrideWith((_) async => null),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HomePage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.text(
        'Your daily mix of music is ready. Tap to explore personalized suggestions.',
      ),
      findsOneWidget,
    );
  });
}
