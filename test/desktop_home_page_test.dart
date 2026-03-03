import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/desktop/album/album_detail_page.dart';
import 'package:melo_trip/pages/desktop/home/home_page.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';

import 'test_helpers.dart';

SubsonicResponse _albumListResponse(List<AlbumEntity> albums) {
  return SubsonicResponse(
    subsonicResponse: SubsonicResponseClass(
      status: 'ok',
      albumList: AlbumListEntity(album: albums),
    ),
  );
}

SubsonicResponse _albumDetailResponse({
  required String albumId,
  required String albumName,
  required String artist,
  required List<SongEntity> songs,
}) {
  return SubsonicResponse(
    subsonicResponse: SubsonicResponseClass(
      status: 'ok',
      album: AlbumEntity(
        id: albumId,
        name: albumName,
        artist: artist,
        song: songs,
      ),
    ),
  );
}

AlbumEntity _album({
  required String id,
  required String name,
  required String artist,
  required String genre,
  int? year,
}) {
  return AlbumEntity(
    id: id,
    name: name,
    artist: artist,
    genre: genre,
    year: year,
    userRating: 8,
  );
}

SongEntity _song({required String id, required String title, int track = 1}) {
  return SongEntity(
    id: id,
    title: title,
    track: track,
    artist: 'test-artist',
    duration: 120,
    discNumber: 1,
  );
}

Future<void> _pumpDesktopHome(
  WidgetTester tester, {
  required SubsonicResponse random,
  required SubsonicResponse recent,
  required SubsonicResponse newest,
  required SubsonicResponse frequent,
  required SubsonicResponse detail,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1600, 1000);
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
        currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
        albumsProvider(.random).overrideWith((_) async => random),
        albumsProvider(.recent).overrideWith((_) async => recent),
        albumsProvider(.newest).overrideWith((_) async => newest),
        albumsProvider(.frequent).overrideWith((_) async => frequent),
        albumDetailProvider('album-1').overrideWith((_) async => detail),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: DesktopHomePage()),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('DesktopHomePage renders hero, genre and album rows', (
    tester,
  ) async {
    final randomAlbum = _album(
      id: 'album-1',
      name: 'Hero Album',
      artist: 'Hero Artist',
      genre: 'Genre-Hero',
      year: 2025,
    );
    final recentAlbums = List.generate(
      15,
      (index) => _album(
        id: 'recent-$index',
        name: 'Recent Album $index',
        artist: 'Recent Artist $index',
        genre: 'Genre-$index',
      ),
    );
    final newestAlbums = List.generate(
      8,
      (index) => _album(
        id: 'new-$index',
        name: 'Newest Album $index',
        artist: 'Newest Artist $index',
        genre: 'Newest-Genre-$index',
      ),
    );

    await _pumpDesktopHome(
      tester,
      random: _albumListResponse([randomAlbum]),
      recent: _albumListResponse(recentAlbums),
      newest: _albumListResponse(newestAlbums),
      frequent: _albumListResponse(newestAlbums),
      detail: _albumDetailResponse(
        albumId: 'album-1',
        albumName: 'Hero Album',
        artist: 'Hero Artist',
        songs: [_song(id: 'song-1', title: 'Song 1')],
      ),
    );

    expect(find.text('Hero Album'), findsAtLeastNWidgets(1));
    expect(find.text('Hero Artist'), findsAtLeastNWidgets(1));
    expect(find.text('Recent Album 0'), findsAtLeastNWidgets(1));
    await tester.drag(find.byType(CustomScrollView).first, const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(find.text('Newest Album 0'), findsWidgets);
    expect(find.byIcon(Icons.play_arrow_rounded), findsWidgets);
  });

  testWidgets('DesktopHomePage genre section limits to 15 unique genres', (
    tester,
  ) async {
    final randomAlbum = _album(
      id: 'album-1',
      name: 'Hero Album',
      artist: 'Hero Artist',
      genre: 'Hero Genre',
    );
    final recentAlbums = List.generate(
      20,
      (index) => _album(
        id: 'genre-$index',
        name: 'Genre Album $index',
        artist: 'Genre Artist $index',
        genre: 'Genre-$index',
      ),
    );

    await _pumpDesktopHome(
      tester,
      random: _albumListResponse([randomAlbum]),
      recent: _albumListResponse(recentAlbums),
      newest: _albumListResponse([randomAlbum]),
      frequent: _albumListResponse([randomAlbum]),
      detail: _albumDetailResponse(
        albumId: 'album-1',
        albumName: 'Hero Album',
        artist: 'Hero Artist',
        songs: [_song(id: 'song-1', title: 'Song 1')],
      ),
    );

    expect(find.text('Genre-0'), findsOneWidget);
    expect(find.text('Genre-14'), findsOneWidget);
    expect(find.text('Genre-15'), findsNothing);
    expect(find.text('Genre-19'), findsNothing);
  });

  testWidgets('DesktopHomePage handles empty providers without crash', (
    tester,
  ) async {
    await _pumpDesktopHome(
      tester,
      random: _albumListResponse(const []),
      recent: _albumListResponse(const []),
      newest: _albumListResponse(const []),
      frequent: _albumListResponse(const []),
      detail: _albumDetailResponse(
        albumId: 'album-1',
        albumName: 'Empty Detail',
        artist: 'No Artist',
        songs: const [],
      ),
    );

    expect(find.byType(DesktopHomePage), findsOneWidget);
    expect(find.byType(DesktopAlbumDetailPage), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('DesktopHomePage taps album card and opens detail page', (
    tester,
  ) async {
    final randomAlbum = _album(
      id: 'album-1',
      name: 'Hero Album',
      artist: 'Hero Artist',
      genre: 'Genre-Hero',
    );
    final recentAlbums = [
      _album(
        id: 'album-1',
        name: 'Recent Album 0',
        artist: 'Recent Artist 0',
        genre: 'Genre-0',
      ),
    ];

    await _pumpDesktopHome(
      tester,
      random: _albumListResponse([randomAlbum]),
      recent: _albumListResponse(recentAlbums),
      newest: _albumListResponse([randomAlbum]),
      frequent: _albumListResponse([randomAlbum]),
      detail: _albumDetailResponse(
        albumId: 'album-1',
        albumName: 'Hero Album',
        artist: 'Hero Artist',
        songs: [
          _song(id: 'song-1', title: 'Song 1'),
          _song(id: 'song-2', title: 'Song 2', track: 2),
        ],
      ),
    );

    await tester.tap(find.text('Recent Album 0').first);
    await tester.pumpAndSettle();

    expect(find.byType(DesktopAlbumDetailPage), findsOneWidget);
    expect(find.text('Song 1'), findsOneWidget);
  });
}
