import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/desktop/album/album_detail_page.dart';
import 'package:melo_trip/pages/desktop/home/home_page.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';

import 'test_helpers.dart';

part 'parts/desktop_home_page_test_helpers.dart';

class _FakeAlbumDetail extends AlbumDetail {
  _FakeAlbumDetail(this._response);

  final SubsonicResponse _response;

  @override
  Future<Result<SubsonicResponse, AppFailure>?> build(String? albumId) async =>
      Result.ok(_response);
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
      random: [randomAlbum],
      recent: recentAlbums,
      newest: newestAlbums,
      frequent: newestAlbums,
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
    await tester.drag(
      find.byType(CustomScrollView).first,
      const Offset(0, -700),
    );
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
      random: [randomAlbum],
      recent: recentAlbums,
      newest: [randomAlbum],
      frequent: [randomAlbum],
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
      random: const <AlbumEntity>[],
      recent: const <AlbumEntity>[],
      newest: const <AlbumEntity>[],
      frequent: const <AlbumEntity>[],
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
      random: [randomAlbum],
      recent: recentAlbums,
      newest: [randomAlbum],
      frequent: [randomAlbum],
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

  testWidgets('DesktopHomePage genre tiles use click cursor on hover area', (
    tester,
  ) async {
    final randomAlbum = _album(
      id: 'album-1',
      name: 'Hero Album',
      artist: 'Hero Artist',
      genre: 'Hero Genre',
    );
    final recentAlbums = List.generate(
      5,
      (index) => _album(
        id: 'genre-$index',
        name: 'Genre Album $index',
        artist: 'Genre Artist $index',
        genre: 'Genre-$index',
      ),
    );

    await _pumpDesktopHome(
      tester,
      random: [randomAlbum],
      recent: recentAlbums,
      newest: [randomAlbum],
      frequent: [randomAlbum],
      detail: _albumDetailResponse(
        albumId: 'album-1',
        albumName: 'Hero Album',
        artist: 'Hero Artist',
        songs: [_song(id: 'song-1', title: 'Song 1')],
      ),
    );

    final tileMouseRegion = find.ancestor(
      of: find.text('Genre-0'),
      matching: find.byType(MouseRegion),
    );
    expect(tileMouseRegion, findsWidgets);

    final clickRegions = tester
        .widgetList<MouseRegion>(tileMouseRegion)
        .where((it) => it.cursor == SystemMouseCursors.click);
    expect(clickRegions.isNotEmpty, isTrue);
  });

  testWidgets('DesktopHomePage section scroll buttons render', (
    tester,
  ) async {
    final randomAlbum = _album(
      id: 'album-1',
      name: 'Hero Album',
      artist: 'Hero Artist',
      genre: 'Hero Genre',
    );

    await _pumpDesktopHome(
      tester,
      random: [randomAlbum],
      recent: [randomAlbum],
      newest: [randomAlbum],
      frequent: [randomAlbum],
      detail: _albumDetailResponse(
        albumId: 'album-1',
        albumName: 'Hero Album',
        artist: 'Hero Artist',
        songs: [_song(id: 'song-1', title: 'Song 1')],
      ),
    );

    expect(
      find.widgetWithIcon(IconButton, Icons.arrow_back_ios_new_rounded),
      findsWidgets,
    );
    expect(
      find.widgetWithIcon(IconButton, Icons.arrow_forward_ios_rounded),
      findsWidgets,
    );
  });

  testWidgets('DesktopHomePage album hover action buttons use click cursor', (
    tester,
  ) async {
    final randomAlbum = _album(
      id: 'album-1',
      name: 'Hero Album',
      artist: 'Hero Artist',
      genre: 'Hero Genre',
    );

    await _pumpDesktopHome(
      tester,
      random: [randomAlbum],
      recent: [randomAlbum],
      newest: [randomAlbum],
      frequent: [randomAlbum],
      detail: _albumDetailResponse(
        albumId: 'album-1',
        albumName: 'Hero Album',
        artist: 'Hero Artist',
        songs: [_song(id: 'song-1', title: 'Song 1')],
      ),
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer();
    await mouse.moveTo(tester.getCenter(find.text('Hero Album').first));
    await tester.pumpAndSettle();

    final shuffleActionRegion = find.ancestor(
      of: find.byIcon(Icons.shuffle_rounded).first,
      matching: find.byType(MouseRegion),
    );
    expect(shuffleActionRegion, findsWidgets);
    final hasClickCursor = tester
        .widgetList<MouseRegion>(shuffleActionRegion)
        .any((it) => it.cursor == SystemMouseCursors.click);
    expect(hasClickCursor, isTrue);
  });
}
