import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/settings/settings_page.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';

import 'test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('DesktopSettingsPage renders header and tabs', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1600, 1200);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
          appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: DesktopSettingsPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(TabBar), findsOneWidget);
    expect(find.byType(TabBarView), findsOneWidget);
    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    expect(find.byType(Scrollable), findsWidgets);
  });

  testWidgets('DesktopSettingsPage can switch tabs', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1600, 1200);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
          appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: DesktopSettingsPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byType(Tab).at(1));
    await tester.pumpAndSettle();

    expect(find.textContaining('Coming Soon'), findsOneWidget);
  });

  testWidgets('DesktopSettingsPage keeps basic actions visible', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1600, 1200);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
          appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: DesktopSettingsPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.byType(ListView), findsWidgets);
  });
}
