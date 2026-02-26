import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/home/home_page.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/route/route_observer.dart';

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

  testWidgets('Home keeps recommendation placeholder', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          albumsProvider(
            AlumsType.newest,
          ).overrideWith((_) async => null),
          albumsProvider(
            AlumsType.recent,
          ).overrideWith((_) async => null),
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

  test('routeObserverProvider returns a route observer', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final observer = container.read(routeObserverProvider);
    expect(observer, isA<RouteObserver<ModalRoute<void>>>());
  });
}
