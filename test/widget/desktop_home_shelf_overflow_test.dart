import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/desktop/home/home_page.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/recommendation/for_you_recommendations.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';

import '../test_helpers.dart';
import '../widget_test_bootstrap.dart';

const _longAlbumName =
    'This Is A Very Long Album Name That Should Stress The Desktop Shelf '
    'Card Layout At The Minimum Card Width';
const _longArtistName =
    'An Extremely Verbose Artist Name That Goes On And On And On';
const _longSongTitle =
    'A Ridiculously Long Song Title Designed To Overflow The Recommendation '
    'Card Width On A Narrow Desktop Window';

AlbumEntity _album(int i) => AlbumEntity(
      id: 'album-$i',
      name: _longAlbumName,
      artist: _longArtistName,
      genre: 'Genre',
      year: 2025,
    );

SongEntity _song(int i) => SongEntity(
      id: 'song-$i',
      title: _longSongTitle,
      artist: _longArtistName,
      duration: 200,
    );

SubsonicResponse _detail() => SubsonicResponse(
      subsonicResponse: SubsonicResponseClass(
        status: 'ok',
        album: AlbumEntity(
          id: 'album-1',
          name: _longAlbumName,
          artist: _longArtistName,
          song: [SongEntity(id: 'song-1', title: _longSongTitle)],
        ),
      ),
    );

class _FakeAlbumDetail extends AlbumDetail {
  _FakeAlbumDetail(this._response);
  final SubsonicResponse _response;

  @override
  Future<Result<SubsonicResponse, AppFailure>?> build(String? albumId) async =>
      Result.ok(_response);
}

Future<void> _pumpDesktopHome(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final albums = List.generate(20, _album);
  final songs = List.generate(20, _song);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
        sessionAuthProvider.overrideWith(fakeSessionAuthLoggedOut),
        forYouRecommendationsProvider.overrideWith((_) async => songs),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.random.name),
        ).overrideWith((_) async => Result.ok(albums)),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.recent.name),
        ).overrideWith((_) async => Result.ok(albums)),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.recent.name, size: 50),
        ).overrideWith((_) async => Result.ok(albums)),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.newest.name),
        ).overrideWith((_) async => Result.ok(albums)),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.newest.name, size: 50),
        ).overrideWith((_) async => Result.ok(albums)),
        albumDetailProvider('album-1').overrideWith(() => _FakeAlbumDetail(_detail())),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: DesktopHomePage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpOverflowGuard();

  group('DesktopHomePage shelf overflow', () {
    // 800px wide window pushes album card width to the 136 lower clamp,
    // which is where the historical hover-overlay overflow occurred.
    testWidgets('renders without overflow at narrow window', (tester) async {
      await _pumpDesktopHome(tester, const Size(800, 1000));
      expect(find.byType(DesktopHomePage), findsOneWidget);
      expectNoFlutterErrors();
    });

    testWidgets('renders without overflow at wide window', (tester) async {
      await _pumpDesktopHome(tester, const Size(1600, 1000));
      expect(find.byType(DesktopHomePage), findsOneWidget);
      expectNoFlutterErrors();
    });
  });
}
