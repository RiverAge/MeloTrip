import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/album/album_detail_repository.dart';

void main() {
  group('AlbumDetailRepository', () {
    late ProviderContainer container;
    late MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWith((ref) {
            return AlbumDetailRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetchAlbumDetail sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'album': {'id': 'album-123', 'name': 'Test Album'},
        },
      });

      final repository = container.read(albumDetailRepositoryProvider);
      await repository.fetchAlbumDetail('album-123');

      expect(mockAdapter.lastRequest?.path, '/rest/getAlbum');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'album-123');
    });

    test('fetchAlbumDetail returns parsed response', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'album': {'id': 'album-123', 'name': 'Test Album', 'songCount': 10},
        },
      });

      final repository = container.read(albumDetailRepositoryProvider);
      final result = await repository.fetchAlbumDetail('album-123');

      expect(result, isNotNull);
      expect(result.subsonicResponse?.album?.id, 'album-123');
      expect(result.subsonicResponse?.album?.name, 'Test Album');
    });

    test('toggleFavorite calls star when not starred', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(albumDetailRepositoryProvider);
      await repository.toggleFavorite(albumId: 'album-123', isStarred: false);

      expect(mockAdapter.lastRequest?.path, '/rest/star');
      expect(mockAdapter.lastRequest?.queryParameters['albumId'], 'album-123');
    });

    test('toggleFavorite calls unstar when starred', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(albumDetailRepositoryProvider);
      await repository.toggleFavorite(albumId: 'album-123', isStarred: true);

      expect(mockAdapter.lastRequest?.path, '/rest/unstar');
      expect(mockAdapter.lastRequest?.queryParameters['albumId'], 'album-123');
    });

    test('setRating sends correct parameters', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(albumDetailRepositoryProvider);
      await repository.setRating(albumId: 'album-123', rating: 5);

      expect(mockAdapter.lastRequest?.path, '/rest/setRating');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'album-123');
      expect(mockAdapter.lastRequest?.queryParameters['rating'], 5);
    });

    test('fetchAlbumDetail returns null for null data', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(albumDetailRepositoryProvider);
      final result = await repository.fetchAlbumDetail('album-123');

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
