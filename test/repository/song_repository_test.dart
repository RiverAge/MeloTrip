import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/song/song_repository.dart';
import 'package:melo_trip/provider/song/songs.dart';

void main() {
  group('SongRepository', () {
    late ProviderContainer container;
    late MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          songRepositoryProvider.overrideWith((ref) {
            return SongRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetchSongSearchResponse sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'searchResult3': {},
        },
      });

      final repository = container.read(songRepositoryProvider);
      await repository.fetchSongSearchResponse(
        query: const SongSearchQuery(query: 'test'),
      );

      expect(mockAdapter.lastRequest?.path, '/rest/search3');
      expect(mockAdapter.lastRequest?.queryParameters['query'], 'test');
    });

    test('fetchSongSearchResponse sends all query parameters', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok', 'searchResult3': {}},
      });

      final repository = container.read(songRepositoryProvider);
      await repository.fetchSongSearchResponse(
        query: const SongSearchQuery(
          query: 'rock',
          songCount: 20,
          songOffset: 10,
          albumCount: 5,
          artistCount: 3,
        ),
      );

      expect(mockAdapter.lastRequest?.queryParameters['query'], 'rock');
      expect(mockAdapter.lastRequest?.queryParameters['songCount'], 20);
      expect(mockAdapter.lastRequest?.queryParameters['songOffset'], 10);
      expect(mockAdapter.lastRequest?.queryParameters['albumCount'], 5);
      expect(mockAdapter.lastRequest?.queryParameters['artistCount'], 3);
    });

    test('fetchSongSearchResponse returns parsed response', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'searchResult3': {
            'song': [
              {'id': 'song-1', 'title': 'Test Song'},
            ],
          },
        },
      });

      final repository = container.read(songRepositoryProvider);
      final result = await repository.fetchSongSearchResponse(
        query: const SongSearchQuery(query: 'test'),
      );

      expect(result, isNotNull);
      expect(result.subsonicResponse?.searchResult3?.song, hasLength(1));
    });

    test('fetchSongSearchItems throws for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(songRepositoryProvider);
      await expectLater(
        repository.fetchSongSearchItems(
          query: const SongSearchQuery(query: 'test'),
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('fetchSongSearchItems returns songs from response', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'searchResult3': {
            'song': [
              {'id': 'song-1', 'title': 'Song One'},
              {'id': 'song-2', 'title': 'Song Two'},
              {'id': 'song-3', 'title': 'Song Three'},
            ],
          },
        },
      });

      final repository = container.read(songRepositoryProvider);
      final result = await repository.fetchSongSearchItems(
        query: const SongSearchQuery(query: 'test'),
      );

      expect(result, hasLength(3));
      expect(result[0].id, 'song-1');
      expect(result[1].id, 'song-2');
      expect(result[2].id, 'song-3');
    });

    test('fetchSongSearchResponse respects cancelToken', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok', 'searchResult3': {}},
      });

      final cancelToken = CancelToken();
      final repository = container.read(songRepositoryProvider);

      await repository.fetchSongSearchResponse(
        query: const SongSearchQuery(query: 'test'),
        cancelToken: cancelToken,
      );

      expect(cancelToken.isCancelled, isFalse);
    });
  });
}

Dio _createMockDio(MockApiAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://test.example.com'));
  dio.httpClientAdapter = adapter;
  return dio;
}

class MockApiAdapter implements HttpClientAdapter {
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
