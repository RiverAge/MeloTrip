import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/desktop/library/favorites_page.dart';
import 'package:melo_trip/pages/desktop/playlist/playlist_detail_page.dart';
import 'package:melo_trip/pages/desktop/settings/settings_page.dart';
import 'package:melo_trip/pages/shared/initial/tab_page.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';

import 'test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpTabPageWithPlaylists(
    WidgetTester tester, {
    required Size size,
    required SubsonicResponse? playlistsResponse,
  }) async {
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
          playlistsProvider.overrideWith(
            () => FakePlaylistsData(playlistsResponse),
          ),
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

  Future<void> pumpTabPage(WidgetTester tester, {required Size size}) async {
    await pumpTabPageWithPlaylists(tester, size: size, playlistsResponse: null);
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

  testWidgets('Desktop playlist tile navigates to playlist detail page', (
    tester,
  ) async {
    final data = SubsonicResponse(
      subsonicResponse: SubsonicResponseClass(
        playlists: const PlaylistsEntity(
          playlist: [
            PlaylistEntity(id: 'playlist-1', name: 'Road Trip'),
          ],
        ),
      ),
    );
    await pumpTabPageWithPlaylists(
      tester,
      size: const Size(1440, 960),
      playlistsResponse: data,
    );

    await tester.tap(find.text('Road Trip').first);
    await tester.pumpAndSettle();

    expect(find.byType(DesktopPlaylistDetailPage), findsOneWidget);
  });

  testWidgets('Desktop playlist tile with null id does not navigate', (
    tester,
  ) async {
    final data = SubsonicResponse(
      subsonicResponse: SubsonicResponseClass(
        playlists: const PlaylistsEntity(
          playlist: [
            PlaylistEntity(id: null, name: 'Broken Playlist'),
          ],
        ),
      ),
    );
    await pumpTabPageWithPlaylists(
      tester,
      size: const Size(1440, 960),
      playlistsResponse: data,
    );

    await tester.tap(find.text('Broken Playlist').first);
    await tester.pumpAndSettle();

    expect(find.byType(DesktopPlaylistDetailPage), findsNothing);
  });
}

class FakePlaylistsData extends Playlists {
  FakePlaylistsData(this._response);

  final SubsonicResponse? _response;

  @override
  Future<SubsonicResponse?> build() async => _response;
}
