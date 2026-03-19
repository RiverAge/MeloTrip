import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/pages/desktop/library/favorites_page.dart';
import 'package:melo_trip/pages/desktop/playlist/playlist_detail_page.dart';
import 'package:melo_trip/pages/desktop/settings/settings_page.dart';
import 'package:melo_trip/pages/desktop/tab/tab_page.dart';
import 'package:melo_trip/pages/shared/initial/tab_page.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';

import 'test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpTabPageWithPlaylists(
    WidgetTester tester, {
    required Size size,
    required List<PlaylistEntity>? playlists,
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
          albumListProvider(
            AlbumListQuery(type: AlbumListType.random.name),
          ).overrideWith((_) async => const Result.ok(<AlbumEntity>[])),
          albumListProvider(
            AlbumListQuery(type: AlbumListType.newest.name),
          ).overrideWith((_) async => const Result.ok(<AlbumEntity>[])),
          albumListProvider(
            AlbumListQuery(type: AlbumListType.newest.name, size: 50),
          ).overrideWith((_) async => const Result.ok(<AlbumEntity>[])),
          albumListProvider(
            AlbumListQuery(type: AlbumListType.recent.name),
          ).overrideWith((_) async => const Result.ok(<AlbumEntity>[])),
          albumListProvider(
            AlbumListQuery(type: AlbumListType.recent.name, size: 50),
          ).overrideWith((_) async => const Result.ok(<AlbumEntity>[])),
          albumListProvider(
            AlbumListQuery(type: AlbumListType.frequent.name),
          ).overrideWith((_) async => const Result.ok(<AlbumEntity>[])),
          albumListProvider(
            AlbumListQuery(type: AlbumListType.frequent.name, size: 50),
          ).overrideWith((_) async => const Result.ok(<AlbumEntity>[])),
          playlistsProvider.overrideWith(
            (ref) async => playlists == null
                ? Result.err(
                    const AppFailure(
                      type: AppFailureType.unknown,
                      message: 'No playlist data',
                    ),
                  )
                : Result.ok(playlists),
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
    await pumpTabPageWithPlaylists(tester, size: size, playlists: null);
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
    await pumpTabPageWithPlaylists(
      tester,
      size: const Size(1440, 960),
      playlists: const [PlaylistEntity(id: 'playlist-1', name: 'Road Trip')],
    );

    await tester.tap(find.text('Road Trip').first);
    await tester.pumpAndSettle();

    expect(find.byType(DesktopPlaylistDetailPage), findsOneWidget);
  });

  testWidgets('Desktop playlist tile with null id does not navigate', (
    tester,
  ) async {
    await pumpTabPageWithPlaylists(
      tester,
      size: const Size(1440, 960),
      playlists: const [PlaylistEntity(id: null, name: 'Broken Playlist')],
    );

    await tester.tap(find.text('Broken Playlist').first);
    await tester.pumpAndSettle();

    expect(find.byType(DesktopPlaylistDetailPage), findsNothing);
  });

  testWidgets('Desktop content routes use zero transition duration', (
    tester,
  ) async {
    await pumpTabPage(tester, size: const Size(1440, 960));

    final navigatorFinder = find.descendant(
      of: find.byType(DesktopTabPage),
      matching: find.byType(Navigator),
    );
    expect(navigatorFinder, findsOneWidget);

    final navigatorWidget = tester.widget<Navigator>(navigatorFinder);
    final route = navigatorWidget.onGenerateRoute!(
      const RouteSettings(name: '/settings'),
    );

    expect(route, isA<PageRouteBuilder<dynamic>>());
    final pageRoute = route! as PageRouteBuilder<dynamic>;
    expect(pageRoute.transitionDuration, Duration.zero);
    expect(pageRoute.reverseTransitionDuration, Duration.zero);
  });
}

