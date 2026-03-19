import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/desktop/home/parts/desktop_album_card.dart';
import 'package:melo_trip/pages/desktop/library/albums_page.dart';
import 'package:melo_trip/pages/desktop/library/artists_page.dart';
import 'package:melo_trip/pages/desktop/library/folders_page.dart';
import 'package:melo_trip/pages/desktop/library/genre_detail_page.dart';
import 'package:melo_trip/pages/desktop/library/genres_page.dart';
import 'package:melo_trip/pages/desktop/library/songs_page.dart';
import 'package:melo_trip/model/response/genre/genre.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/auth/auth.dart';

import 'test_helpers.dart';

class _FakeAlbumDetail extends AlbumDetail {
  _FakeAlbumDetail(this._response);

  final SubsonicResponse _response;

  @override
  Future<Result<SubsonicResponse, AppFailure>?> build(String? albumId) async =>
      Result.ok(_response);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpDesktopPage(
    WidgetTester tester, {
    required Widget child,
    List overrides = const [],
    Size size = const Size(1600, 1000),
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
          ...overrides,
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: child,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('DesktopSongsPage renders song rows from provider data', (
    tester,
  ) async {
    await pumpDesktopPage(
      tester,
      child: const DesktopSongsPage(),
      overrides: [apiProvider.overrideWith(FakeApiDesktopLibrary.new)],
    );

    expect(find.text('Song A'), findsOneWidget);
    expect(find.text('Artist A'), findsOneWidget);
    expect(find.text('Album A'), findsOneWidget);
    expect(find.text('Pop'), findsOneWidget);
    expect(find.text('2024'), findsOneWidget);
    expect(find.text('2:05'), findsOneWidget);
  });

  testWidgets('DesktopAlbumsPage supports grid, table and detail views', (
    tester,
  ) async {
    final albumDetailResponse = SubsonicResponse(
      subsonicResponse: SubsonicResponseClass(
        album: const AlbumEntity(
          id: 'album-1',
          song: [SongEntity(id: 'song-1', title: 'First Track', duration: 61)],
        ),
      ),
    );

    await pumpDesktopPage(
      tester,
      child: const DesktopAlbumsPage(),
      overrides: [
        apiProvider.overrideWith(FakeApiDesktopLibrary.new),
        albumDetailProvider(
          'album-1',
        ).overrideWith(() => _FakeAlbumDetail(albumDetailResponse)),
      ],
    );

    expect(find.byType(DesktopAlbumCard), findsOneWidget);

    await tester.tap(find.byIcon(Icons.view_list_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Road Trip'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.view_headline_rounded));
    await tester.pumpAndSettle();
    expect(find.text('First Track'), findsOneWidget);
    expect(find.text('1:01'), findsOneWidget);
  });

  testWidgets('DesktopFoldersPage renders entries parsed from getIndexes', (
    tester,
  ) async {
    await pumpDesktopPage(
      tester,
      child: const DesktopFoldersPage(),
      overrides: [apiProvider.overrideWith(FakeApiDesktopLibrary.new)],
    );

    expect(find.text('Adele'), findsWidgets);
    expect(find.text('Aimer'), findsWidgets);
  });

  testWidgets('DesktopArtistsPage renders artists parsed from getArtists', (
    tester,
  ) async {
    await pumpDesktopPage(
      tester,
      child: const DesktopArtistsPage(),
      overrides: [apiProvider.overrideWith(FakeApiDesktopLibrary.new)],
    );

    expect(find.text('Adele'), findsOneWidget);
    expect(find.text('Aimer'), findsOneWidget);
  });

  testWidgets('DesktopGenresPage renders genres parsed from getGenres', (
    tester,
  ) async {
    await pumpDesktopPage(
      tester,
      child: const DesktopGenresPage(),
      overrides: [apiProvider.overrideWith(FakeApiDesktopLibrary.new)],
    );

    expect(find.text('Pop'), findsOneWidget);
    expect(find.text('Rock'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
  });

  testWidgets('DesktopGenreDetailPage renders albums from getAlbumList', (
    tester,
  ) async {
    await pumpDesktopPage(
      tester,
      child: const DesktopGenreDetailPage(
        genre: GenreEntity(value: 'Rock', songCount: 8, albumCount: 3),
      ),
      overrides: [apiProvider.overrideWith(FakeApiDesktopLibrary.new)],
    );

    expect(find.text('Rock'), findsOneWidget);
    expect(find.byType(DesktopAlbumCard), findsOneWidget);
    expect(find.text('Road Trip'), findsOneWidget);
  });
}

class FakeApiDesktopLibrary extends Api {
  @override
  Future<Dio> build() async {
    final dio = Dio();
    dio.httpClientAdapter = PathJsonAdapter({
      '/rest/search3': {
        'subsonic-response': {
          'status': 'ok',
          'searchResult3': {
            'song': [
              {
                'id': 'song-1',
                'title': 'Song A',
                'artist': 'Artist A',
                'album': 'Album A',
                'genre': 'Pop',
                'year': 2024,
                'duration': 125,
              },
            ],
          },
        },
      },
      '/rest/getIndexes': {
        'subsonic-response': {
          'indexes': {
            'index': [
              {
                'artist': [
                  {'id': 'a-1', 'name': 'Adele'},
                  {'id': 'a-2', 'name': 'Aimer'},
                ],
              },
            ],
          },
        },
      },
      '/rest/getArtists': {
        'subsonic-response': {
          'artists': {
            'index': [
              {
                'artist': [
                  {'id': 'artist-1', 'name': 'Adele', 'albumCount': 2},
                  {'id': 'artist-2', 'name': 'Aimer', 'albumCount': 1},
                ],
              },
            ],
          },
        },
      },
      '/rest/getGenres': {
        'subsonic-response': {
          'genres': {
            'genre': [
              {'value': 'Pop', 'songCount': 12, 'albumCount': 4},
              {'value': 'Rock', 'songCount': 8, 'albumCount': 3},
            ],
          },
        },
      },
      '/rest/getAlbumList': {
        'subsonic-response': {
          'status': 'ok',
          'albumList': {
            'album': [
              {
                'id': 'album-1',
                'name': 'Road Trip',
                'artist': 'Various',
                'genre': 'Rock',
                'year': 2023,
              },
            ],
          },
        },
      },
    });
    return dio;
  }
}

class PathJsonAdapter implements HttpClientAdapter {
  PathJsonAdapter(this.pathJson);

  final Map<String, Map<String, dynamic>> pathJson;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final payload = pathJson[options.path] ?? <String, dynamic>{};
    return ResponseBody.fromBytes(
      utf8.encode(jsonEncode(payload)),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
