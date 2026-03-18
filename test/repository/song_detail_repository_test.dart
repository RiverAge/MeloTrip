import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/song/song_detail_repository.dart';

void main() {
  group('SongDetailRepository', () {
    late ProviderContainer container;
    late MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          songDetailRepositoryProvider.overrideWith((ref) {
            return SongDetailRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetchSongDetail sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'song': {'id': 'song-789', 'title': 'Test Song'},
        },
      });

      final repository = container.read(songDetailRepositoryProvider);
      await repository.fetchSongDetail('song-789');

      expect(mockAdapter.lastRequest?.path, '/rest/getSong');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'song-789');
    });

    test('fetchSongDetail returns parsed response', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'song': {
            'id': 'song-789',
            'title': 'Test Song',
            'artist': 'Test Artist',
            'album': 'Test Album',
            'duration': 180,
          },
        },
      });

      final repository = container.read(songDetailRepositoryProvider);
      final result = await repository.fetchSongDetail('song-789');

      expect(result, isNotNull);
      expect(result.subsonicResponse?.song?.id, 'song-789');
      expect(result.subsonicResponse?.song?.title, 'Test Song');
    });

    test('toggleFavoriteResult calls star when not starred', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(songDetailRepositoryProvider);
      final result = await repository.toggleFavoriteResult(
        songId: 'song-789',
        isStarred: false,
      );

      expect(result.isOk, isTrue);
      expect(mockAdapter.lastRequest?.path, '/rest/star');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'song-789');
    });

    test('toggleFavoriteResult calls unstar when starred', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(songDetailRepositoryProvider);
      final result = await repository.toggleFavoriteResult(
        songId: 'song-789',
        isStarred: true,
      );

      expect(result.isOk, isTrue);
      expect(mockAdapter.lastRequest?.path, '/rest/unstar');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'song-789');
    });

    test('setRatingResult sends correct parameters', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(songDetailRepositoryProvider);
      final result = await repository.setRatingResult(songId: 'song-789', rating: 4);

      expect(result.isOk, isTrue);
      expect(mockAdapter.lastRequest?.path, '/rest/setRating');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'song-789');
      expect(mockAdapter.lastRequest?.queryParameters['rating'], 4);
    });

    test('fetchSongDetail throws for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(songDetailRepositoryProvider);
      await expectLater(
        repository.fetchSongDetail('song-789'),
        throwsA(isA<StateError>()),
      );
    });

    test('fetchSongDetailResult returns Result.err for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(songDetailRepositoryProvider);
      final result = await repository.fetchSongDetailResult('song-789');

      expect(result.isErr, isTrue);
      expect(result.error, isNotNull);
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
