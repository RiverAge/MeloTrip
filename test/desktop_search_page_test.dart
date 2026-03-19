import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/search_result/search_result3.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/desktop/search/search_page.dart';
import 'package:melo_trip/provider/search/search.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';
import 'package:melo_trip/widget/no_data.dart';

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
          sessionConfigProvider.overrideWith((_) async => null),
          searchProvider.overrideWith((_) async => null),
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
          sessionConfigProvider.overrideWith((_) async => null),
          searchProvider.overrideWith(
            (_) async => Result.ok(
              _searchResponse(
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

