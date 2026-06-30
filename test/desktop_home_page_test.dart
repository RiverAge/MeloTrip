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
import 'package:melo_trip/provider/recommendation/for_you_recommendations.dart';
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

  testWidgets('DesktopHomePage renders hero, album and recommendation rows', (
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
    final recommendedSongs = List.generate(
      6,
      (index) => _song(id: 'rec-$index', title: 'Recommended Song $index'),
    );

    await _pumpDesktopHome(
      tester,
      random: [randomAlbum],
      recent: recentAlbums,
      newest: newestAlbums,
      frequent: newestAlbums,
      recommendations: recommendedSongs,
      viewportSize: const Size(1600, 1800),
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
    expect(find.text('Newest Album 0'), findsWidgets);
    expect(find.text('Recommended Song 0'), findsWidgets);
    expect(find.byIcon(Icons.play_arrow_rounded), findsWidgets);
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

  testWidgets('DesktopHomePage section scroll buttons render', (tester) async {
    final randomAlbum = _album(
      id: 'album-1',
      name: 'Hero Album',
      artist: 'Hero Artist',
      genre: 'Hero Genre',
    );
    // Enough albums to make horizontal lists scrollable (so scroll arrows
    // render on the shelf headers).
    final scrollableAlbums = List.generate(
      20,
      (index) => _album(
        id: 'scroll-$index',
        name: 'Scroll Album $index',
        artist: 'Scroll Artist $index',
        genre: 'Genre-$index',
      ),
    );
    final recommendedSongs = List.generate(
      20,
      (index) => _song(id: 'rec-$index', title: 'Recommended $index'),
    );

    await _pumpDesktopHome(
      tester,
      random: [randomAlbum],
      recent: scrollableAlbums,
      newest: scrollableAlbums,
      frequent: scrollableAlbums,
      recommendations: recommendedSongs,
      viewportSize: const Size(1600, 1800),
      detail: _albumDetailResponse(
        albumId: 'album-1',
        albumName: 'Hero Album',
        artist: 'Hero Artist',
        songs: [_song(id: 'song-1', title: 'Song 1')],
      ),
    );
    // Allow post-frame scroll-state updates to flush so the conditional
    // scroll arrows render on the shelf headers.
    await tester.pumpAndSettle();

    // Refresh buttons always render on recommendation shelves. Forward arrows
    // render when a list is scrollable from its initial position. Back arrows
    // are skipped since the lists start at offset 0 (cannot scroll back yet).
    expect(
      find.widgetWithIcon(IconButton, Icons.arrow_forward_ios_rounded),
      findsWidgets,
    );
    expect(
      find.widgetWithIcon(IconButton, Icons.refresh_rounded),
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
