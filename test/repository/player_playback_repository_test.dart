import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/playback/player_playback_repository.dart';

void main() {
  group('PlayerPlaybackRepository', () {
    late ProviderContainer container;
    late _MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = _MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          playerPlaybackRepositoryProvider.overrideWith((ref) {
            return PlayerPlaybackRepository(
              () async => _createMockDio(mockAdapter),
            );
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('tryReportPlayback sends expected query parameters', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(playerPlaybackRepositoryProvider);
      final result = await repository.tryReportPlayback(
        mediaId: 'song-1',
        positionMs: 5000,
        state: PlaybackState.playing,
      );

      expect(result.isOk, isTrue);
      expect(mockAdapter.lastRequest?.path, '/rest/reportPlayback');
      expect(mockAdapter.lastRequest?.queryParameters['mediaId'], 'song-1');
      expect(mockAdapter.lastRequest?.queryParameters['mediaType'], 'song');
      expect(mockAdapter.lastRequest?.queryParameters['positionMs'], 5000);
      expect(mockAdapter.lastRequest?.queryParameters['state'], 'playing');
      expect(mockAdapter.lastRequest?.queryParameters['playbackRate'], 1.0);
      expect(mockAdapter.lastRequest?.queryParameters['ignoreScrobble'], false);
    });

    test('tryReportPlayback serializes stopped state', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(playerPlaybackRepositoryProvider);
      final result = await repository.tryReportPlayback(
        mediaId: 'song-2',
        positionMs: 12000,
        state: PlaybackState.stopped,
      );

      expect(result.isOk, isTrue);
      expect(mockAdapter.lastRequest?.queryParameters['state'], 'stopped');
    });

    test('trySavePlayQueue keeps repeated id query form', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(playerPlaybackRepositoryProvider);
      final result = await repository.trySavePlayQueue(
        songIds: const ['song-1', 'song-2'],
        currentSongId: 'song-2',
      );

      expect(result.isOk, isTrue);
      expect(
        mockAdapter.lastRequest?.path,
        '/rest/savePlayQueue?id=song-1&id=song-2&current=song-2',
      );
    });

    test('trySavePlayQueue without songs calls base endpoint', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(playerPlaybackRepositoryProvider);
      final result = await repository.trySavePlayQueue(songIds: const []);

      expect(result.isOk, isTrue);
      expect(mockAdapter.lastRequest?.path, '/rest/savePlayQueue');
    });
  });
}

Dio _createMockDio(HttpClientAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://test.example.com'));
  dio.httpClientAdapter = adapter;
  return dio;
}

class _MockApiAdapter implements HttpClientAdapter {
  Map<String, dynamic>? _response;
  RequestOptions? lastRequest;

  void setResponse(Map<String, dynamic>? response) {
    _response = response;
  }

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    if (_response == null) {
      return ResponseBody.fromBytes(
        utf8.encode(''),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
    }
    return ResponseBody.fromBytes(
      utf8.encode(jsonEncode(_response)),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}
