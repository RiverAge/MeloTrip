import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/search_result/search_result3.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/pages/desktop/search/search_page.dart';
import 'package:melo_trip/provider/search/search.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/widget/no_data.dart';

class _FakeUserConfig extends UserConfig {
  @override
  Future<Configuration?> build() async => null;

  @override
  Future<void> setConfiguration({
    ValueUpdater<ThemeMode?>? theme,
    ValueUpdater<String?>? maxRate,
    ValueUpdater<PlaylistMode?>? playlistMode,
    ValueUpdater<bool?>? shuffle,
    ValueUpdater<Locale?>? locale,
    ValueUpdater<String?>? recentSearches,
    ValueUpdater<String>? recentSearch,
    ValueUpdater<String?>? desktopLyricsConfig,
  }) async {
    final String? nextRecentSearches = recentSearch == null
        ? recentSearches?.value
        : recentSearch.value;
    state = AsyncData(
      Configuration(
        recentSearches: nextRecentSearches,
        theme: theme?.value,
        maxRate: maxRate?.value,
        playlistMode: playlistMode?.value,
        shuffle: shuffle?.value,
        locale: locale?.value,
        desktopLyricsConfig: desktopLyricsConfig?.value,
      ),
    );
  }
}

SubsonicResponse _searchResponse({
  required List<AlbumEntity> albums,
  required List<SongEntity> songs,
  required List<ArtistEntity> artists,
}) {
  return SubsonicResponse(
    subsonicResponse: SubsonicResponseClass(
      status: 'ok',
      searchResult3: SearchResult3Entity(
        album: albums,
        song: songs,
        artist: artists,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('DesktopSearchPage shows NoData when query is empty', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1600, 1000);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userConfigProvider.overrideWith(_FakeUserConfig.new),
          searchResultProvider.overrideWith((_) async => null),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const DesktopSearchPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(NoData), findsOneWidget);
  });

  testWidgets('DesktopSearchPage renders song, album and artist results', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1600, 1000);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userConfigProvider.overrideWith(_FakeUserConfig.new),
          searchResultProvider.overrideWith(
            (_) async => _searchResponse(
              albums: const <AlbumEntity>[
                AlbumEntity(
                  id: 'a1',
                  name: 'Search Album 1',
                  artist: 'Search Artist 1',
                ),
              ],
              songs: const <SongEntity>[
                SongEntity(
                  id: 's1',
                  title: 'Search Song 1',
                  album: 'Search Album 1',
                  artist: 'Search Artist 1',
                ),
              ],
              artists: const <ArtistEntity>[
                ArtistEntity(id: 'ar1', name: 'Search Artist 1', albumCount: 3),
              ],
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const DesktopSearchPage(initialQuery: 'rock'),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Search Song 1'), findsOneWidget);
    expect(find.text('Search Album 1'), findsOneWidget);
    expect(find.text('Search Artist 1'), findsWidgets);
  });
}
