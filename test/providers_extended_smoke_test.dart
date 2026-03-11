import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/artist/artist_detail.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:melo_trip/provider/lyrics/lyrics.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/provider/search/search.dart';
import 'package:melo_trip/provider/song/song_detail.dart';
import 'package:melo_trip/provider/song/songs.dart';

typedef JsonResolver = Map<String, dynamic>? Function(RequestOptions options);

class RecordingRouteAdapter implements HttpClientAdapter {
  RecordingRouteAdapter(this.resolver);

  final JsonResolver resolver;
  final List<RequestOptions> requests = [];

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final payload = resolver(options);
    final body = payload == null ? 'null' : jsonEncode(payload);
    return ResponseBody.fromBytes(
      utf8.encode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

class FakeApiWithAdapter extends Api {
  FakeApiWithAdapter(this.adapter);

  final RecordingRouteAdapter adapter;

  @override
  Future<Dio> build() async {
    final dio = Dio();
    dio.httpClientAdapter = adapter;
    return dio;
  }
}

void main() {
  test('detail providers return null when id is null', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(await container.read(playlistDetailProvider(null).future), isNull);
    expect(await container.read(artistDetailProvider(null).future), isNull);
    expect(await container.read(songDetailProvider(null).future), isNull);
    expect(await container.read(albumDetailProvider(null).future), isNull);
    expect(await container.read(lyricsProvider(null).future), isNull);
  });

  test('favoriteProvider parses getStarred payload', () async {
    final adapter = RecordingRouteAdapter((options) {
      if (options.path != '/rest/getStarred') return null;
      return {
        'subsonic-response': {
          'status': 'ok',
          'starred': {
            'song': [
              {'id': 's1', 'title': 'Star Song'},
            ],
          },
        },
      };
    });

    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(() => FakeApiWithAdapter(adapter))],
    );
    addTearDown(container.dispose);

    final result = await container.read(favoriteProvider.future);
    expect(result?.subsonicResponse?.status, 'ok');
    expect(result?.subsonicResponse?.starred?.song?.first.id, 's1');
  });

  test('playlists provider parses payload and null guards work', () async {
    final adapter = RecordingRouteAdapter((options) {
      if (options.path == '/rest/getPlaylists') {
        return {
          'subsonic-response': {
            'status': 'ok',
            'playlists': {
              'playlist': [
                {'id': 'p1', 'name': 'Playlist 1'},
              ],
            },
          },
        };
      }
      if (options.path == '/rest/getPlaylist') {
        return {
          'subsonic-response': {'status': 'ok'},
        };
      }
      return null;
    });

    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(() => FakeApiWithAdapter(adapter))],
    );
    addTearDown(container.dispose);

    final playlists = await container.read(playlistsProvider.future);
    expect(playlists?.subsonicResponse?.playlists?.playlist?.first.id, 'p1');

    final playlistsNotifier = container.read(playlistsProvider.notifier);
    expect(await playlistsNotifier.createPlaylist(null), isNull);
    expect(await playlistsNotifier.deletePlaytlist(null), isNull);

    final detail = await container.read(playlistDetailProvider('p1').future);
    expect(detail?.subsonicResponse?.status, 'ok');

    expect(
      await container.read(playlistUpdateProvider.notifier).build(),
      isNull,
    );
  });

  test('playlistUpdateProvider supports songIdToAdd branch', () async {
    final adapter = RecordingRouteAdapter((options) {
      if (options.path != '/rest/updatePlaylist') return null;
      expect(options.queryParameters['playlistId'], 'p1');
      expect(options.queryParameters['songIdToAdd'], 's1');
      return {
        'subsonic-response': {'status': 'ok'},
      };
    });

    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(() => FakeApiWithAdapter(adapter))],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      playlistUpdateProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final result = await container
        .read(playlistUpdateProvider.notifier)
        .modify(playlistId: 'p1', songIdToAdd: 's1');

    expect(result?.subsonicResponse?.status, 'ok');
  });

  test('song/album favorite and rating null guards return null', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final songFavorite = container.read(songFavoriteProvider.notifier);
    final songRating = container.read(songRatingProvider.notifier);
    final albumFavorite = container.read(albumFavoriteProvider.notifier);
    final albumRating = container.read(albumRatingProvider.notifier);

    expect(await songFavorite.toggleFavorite(null), isNull);
    expect(await songFavorite.toggleFavorite(const SongEntity()), isNull);
    expect(await songRating.updateRating(null, 5), isNull);
    expect(await songRating.updateRating('s1', null), isNull);
    expect(await albumFavorite.toggleFavorite(null), isNull);
    expect(await albumFavorite.toggleFavorite(const AlbumEntity()), isNull);
    expect(await albumRating.updateRating(null, 4), isNull);
    expect(await albumRating.updateRating('a1', null), isNull);
  });

  test('lyrics provider merges best source and skips latn lines', () async {
    final adapter = RecordingRouteAdapter((options) {
      if (options.path != '/rest/getLyricsBySongId') return null;
      return {
        'subsonic-response': {
          'status': 'ok',
          'lyricsList': {
            'structuredLyrics': [
              {
                'lang': 'ori-NetEase',
                'line': [
                  {'start': 0, 'value': 'Hello'},
                  {'start': 1000, 'value': 'World'},
                ],
              },
              {
                'lang': 'zho-NetEase',
                'line': [
                  {'start': 0, 'value': 'CN-1'},
                  {'start': 1000, 'value': 'CN-2'},
                ],
              },
              {
                'lang': 'latn-NetEase',
                'line': [
                  {'start': 0, 'value': 'Ni Hao'},
                ],
              },
              {
                'lang': 'ori-Other',
                'line': [
                  {'start': 0, 'value': 'Other Source'},
                ],
              },
            ],
          },
        },
      };
    });

    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(() => FakeApiWithAdapter(adapter))],
    );
    addTearDown(container.dispose);

    final result = await container.read(lyricsProvider('song-1').future);
    final merged = result?.subsonicResponse?.lyricsList?.structuredLyrics;
    expect(merged, isNotNull);
    expect(merged!.length, 1);
    expect(merged.first.lang, 'NetEase');
    expect(merged.first.line, hasLength(2));
    expect(merged.first.line!.first.value, ['Hello', 'CN-1']);
    expect(merged.first.line!.last.value, ['World', 'CN-2']);
  });

  test('searchProvider parses payload and empty query returns null', () async {
    final adapter = RecordingRouteAdapter((options) {
      if (options.path != '/rest/search3') return null;
      return {
        'subsonic-response': {
          'status': 'ok',
          'searchResult3': {
            'song': [
              {'id': 's1', 'title': 'keyword'},
            ],
          },
        },
      };
    });

    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(() => FakeApiWithAdapter(adapter))],
    );
    addTearDown(container.dispose);

    expect(await container.read(searchProvider('').future), isNull);
    final result = await container.read(searchProvider('keyword').future);
    expect(result?.subsonicResponse?.status, 'ok');
    expect(
      result?.subsonicResponse?.searchResult3?.song?.first.title,
      'keyword',
    );
  });

  test('paginatedSongListProvider loads first search3 page', () async {
    final adapter = RecordingRouteAdapter((options) {
      if (options.path != '/rest/search3') return null;
      expect(options.queryParameters['songCount'], 2);
      expect(options.queryParameters['songOffset'], 0);
      expect(options.queryParameters['query'], '');
      return {
        'subsonic-response': {
          'status': 'ok',
          'searchResult3': {
            'song': [
              {'id': 's1', 'title': 'Song 1'},
              {'id': 's2', 'title': 'Song 2'},
            ],
          },
        },
      };
    });

    final container = ProviderContainer(
      overrides: [apiProvider.overrideWith(() => FakeApiWithAdapter(adapter))],
    );
    addTearDown(container.dispose);

    final query = SongSearchQuery(
      query: '',
      songCount: 2,
      albumCount: 0,
      artistCount: 0,
    );
    final notifier = container.read(paginatedSongListProvider(query).notifier);

    await notifier.loadInitial();

    final state = container.read(paginatedSongListProvider(query));
    expect(state.items, hasLength(2));
    expect(state.items.first.title, 'Song 1');
    expect(state.hasMore, isTrue);
  });
}
