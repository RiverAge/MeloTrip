import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/settings/settings_page.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/user_config/desktop_lyrics_settings_provider.dart';

import 'test_helpers.dart';

const DesktopLyricsConfig _testDesktopLyricsConfig = DesktopLyricsConfig(
  interaction: DesktopLyricsInteractionConfig(
    enabled: false,
    clickThrough: false,
  ),
  text: DesktopLyricsTextConfig(fontSize: 34),
  background: DesktopLyricsBackgroundConfig(opacity: 0.93),
  gradient: DesktopLyricsGradientConfig(),
  layout: DesktopLyricsLayoutConfig(overlayWidth: 980),
);

class _FakeDesktopLyricsSettings extends DesktopLyricsSettings {
  @override
  Future<DesktopLyricsConfig> build() async => _testDesktopLyricsConfig;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('DesktopSettingsPage renders header and tabs', (tester) async {
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
          desktopLyricsSettingsProvider.overrideWith(
            _FakeDesktopLyricsSettings.new,
          ),
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
    expect(find.byIcon(Icons.tune_rounded), findsWidgets);
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
          desktopLyricsSettingsProvider.overrideWith(
            _FakeDesktopLyricsSettings.new,
          ),
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

    expect(find.textContaining('Coming soon'), findsOneWidget);
  });

  testWidgets('DesktopSettingsPage keeps basic actions visible', (
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
          desktopLyricsSettingsProvider.overrideWith(
            _FakeDesktopLyricsSettings.new,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: DesktopSettingsPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsWidgets);
  });

  testWidgets('DesktopSettingsPage renders desktop lyrics tab content', (
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
          desktopLyricsSettingsProvider.overrideWith(
            _FakeDesktopLyricsSettings.new,
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: DesktopSettingsPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byType(Tab).at(3));
    await tester.pumpAndSettle();

    expect(find.textContaining('Desktop Lyrics'), findsWidgets);
    expect(find.byType(Switch), findsWidgets);
  });
}
