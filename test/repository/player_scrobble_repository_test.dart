import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/scrobble/player_scrobble_repository.dart';

void main() {
  group('PlayerScrobbleRepository', () {
    late ProviderContainer container;
    late _MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = _MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          playerScrobbleRepositoryProvider.overrideWith((ref) {
            return PlayerScrobbleRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('tryScrobble sends expected query parameters', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(playerScrobbleRepositoryProvider);
      final result = await repository.tryScrobble(
        songId: 'song-1',
        submission: true,
        time: 1234567890,
      );

      expect(result.isOk, isTrue);
      expect(mockAdapter.lastRequest?.path, '/rest/scrobble');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'song-1');
      expect(mockAdapter.lastRequest?.queryParameters['submission'], true);
      expect(mockAdapter.lastRequest?.queryParameters['time'], 1234567890);
    });

    test('trySavePlayQueue keeps repeated id query form', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(playerScrobbleRepositoryProvider);
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

      final repository = container.read(playerScrobbleRepositoryProvider);
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
        headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
      );
    }
    return ResponseBody.fromBytes(
      utf8.encode(jsonEncode(_response)),
      200,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );
  }
}
