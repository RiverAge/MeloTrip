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
      expect(result?.subsonicResponse?.song?.id, 'song-789');
      expect(result?.subsonicResponse?.song?.title, 'Test Song');
    });

    test('toggleFavorite calls star when not starred', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(songDetailRepositoryProvider);
      await repository.toggleFavorite(songId: 'song-789', isStarred: false);

      expect(mockAdapter.lastRequest?.path, '/rest/star');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'song-789');
    });

    test('toggleFavorite calls unstar when starred', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(songDetailRepositoryProvider);
      await repository.toggleFavorite(songId: 'song-789', isStarred: true);

      expect(mockAdapter.lastRequest?.path, '/rest/unstar');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'song-789');
    });

    test('setRating sends correct parameters', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(songDetailRepositoryProvider);
      await repository.setRating(songId: 'song-789', rating: 4);

      expect(mockAdapter.lastRequest?.path, '/rest/setRating');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'song-789');
      expect(mockAdapter.lastRequest?.queryParameters['rating'], 4);
    });

    test('fetchSongDetail returns null for null data', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(songDetailRepositoryProvider);
      final result = await repository.fetchSongDetail('song-789');

      expect(result, isNull);
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
