import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/desktop/library/favorites_page.dart';
import 'package:melo_trip/pages/desktop/settings/settings_page.dart';
import 'package:melo_trip/pages/shared/initial/tab_page.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';

import 'test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpTabPage(WidgetTester tester, {required Size size}) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
          currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
          albumsProvider(.random).overrideWith((_) async => null),
          albumsProvider(.newest).overrideWith((_) async => null),
          albumsProvider(.recent).overrideWith((_) async => null),
          albumsProvider(.frequent).overrideWith((_) async => null),
          playlistsProvider.overrideWith(FakePlaylists.new),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const TabPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('TabPage shows mobile bottom navigation on narrow screens', (
    tester,
  ) async {
    await pumpTabPage(tester, size: const Size(700, 900));

    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('TabPage shows desktop sidebar shell on desktop', (tester) async {
    await pumpTabPage(tester, size: const Size(1440, 960));

    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(BottomNavigationBar), findsNothing);
    expect(find.text('My Playlist'), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
  });

  testWidgets('Desktop sidebar settings tile navigates to settings page', (
    tester,
  ) async {
    await pumpTabPage(tester, size: const Size(1440, 960));

    await tester.tap(find.text('Settings').first);
    await tester.pumpAndSettle();

    expect(find.byType(DesktopSettingsPage), findsOneWidget);
  });

  testWidgets('Desktop sidebar favorites tile navigates to favorites page', (
    tester,
  ) async {
    await pumpTabPage(tester, size: const Size(1440, 960));

    await tester.tap(find.text('My Favorites').first);
    await tester.pumpAndSettle();

    expect(find.byType(DesktopFavoritesPage), findsOneWidget);
  });
}

class FakePlaylists extends Playlists {
  @override
  Future<SubsonicResponse?> build() async => null;
}
