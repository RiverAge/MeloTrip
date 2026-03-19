import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/artist/artist_detail.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:melo_trip/provider/lyrics/lyrics.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/provider/search/search.dart';
import 'package:melo_trip/provider/song/song_detail.dart';
import 'package:melo_trip/provider/song/songs.dart';

part 'parts/providers_extended_smoke_fakes.dart';

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
    expect(result.isOk, isTrue);
    expect(result.data?.subsonicResponse?.status, 'ok');
    expect(result.data?.subsonicResponse?.starred?.song?.first.id, 's1');
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
    expect(playlists.data?.subsonicResponse?.playlists?.playlist?.first.id, 'p1');

    final playlistsNotifier = container.read(playlistActionsProvider.notifier);
    expect(await playlistsNotifier.createPlaylist(null), isNull);

    final detail = await container.read(playlistDetailProvider('p1').future);
    expect(detail?.data?.subsonicResponse?.status, 'ok');
    expect(
      await container.read(playlistDetailProvider(null).notifier).deleteResult(),
      isNull,
    );
  });

  test('playlistDetailProvider supports songIdToAdd branch', () async {
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
      playlistDetailProvider('p1'),
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    final result = await container
        .read(playlistDetailProvider('p1').notifier)
        .modifyResult(songIdToAdd: 's1');

    expect(result?.isOk, isTrue);
  });

  test('song favorite null guards return null', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final songDetail = container.read(songDetailProvider(null).notifier);

    expect(await songDetail.toggleFavoriteResult(), isNull);
    expect(await songDetail.updateRatingResult(5), isNull);
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
    expect(result?.isOk, isTrue);
    final merged = result?.data?.subsonicResponse?.lyricsList?.structuredLyrics;
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
    expect(result?.isOk, isTrue);
    expect(
      result?.data?.subsonicResponse?.searchResult3?.song?.first.title,
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

