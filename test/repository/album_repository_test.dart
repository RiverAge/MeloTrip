import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/repository/album/album_repository.dart';

void main() {
  group('AlbumRepository', () {
    late ProviderContainer container;
    late MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          albumRepositoryProvider.overrideWith((ref) {
            return AlbumRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetchAlbumListResponse returns parsed response', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'albumList': {
            'album': [
              {'id': 'album-1', 'name': 'Test Album'},
            ],
          },
        },
      });

      final repository = container.read(albumRepositoryProvider);
      final result = await repository.fetchAlbumListResponse(
        query: const AlbumListQuery(type: 'newest'),
      );

      expect(result, isNotNull);
      expect(result.subsonicResponse?.status, 'ok');
      expect(result.subsonicResponse?.albumList?.album, hasLength(1));
      expect(result.subsonicResponse?.albumList?.album?.first.id, 'album-1');
    });

    test('fetchAlbumListResponse sends correct query parameters', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok', 'albumList': {'album': []}},
      });

      final repository = container.read(albumRepositoryProvider);
      await repository.fetchAlbumListResponse(
        query: const AlbumListQuery(
          type: 'random',
          size: 10,
          offset: 5,
          genre: 'Rock',
        ),
      );

      expect(mockAdapter.lastRequest?.path, '/rest/getAlbumList');
      expect(mockAdapter.lastRequest?.queryParameters['type'], 'random');
      expect(mockAdapter.lastRequest?.queryParameters['size'], 10);
      expect(mockAdapter.lastRequest?.queryParameters['offset'], 5);
      expect(mockAdapter.lastRequest?.queryParameters['genre'], 'Rock');
    });

    test('fetchAlbumListItems throws for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(albumRepositoryProvider);
      await expectLater(
        repository.fetchAlbumListItems(
          query: const AlbumListQuery(type: 'newest'),
        ),
        throwsA(isA<StateError>()),
      );
    });

    test('fetchAlbumListItems returns albums from response', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'albumList': {
            'album': [
              {'id': 'album-1', 'name': 'Album One'},
              {'id': 'album-2', 'name': 'Album Two'},
            ],
          },
        },
      });

      final repository = container.read(albumRepositoryProvider);
      final result = await repository.fetchAlbumListItems(
        query: const AlbumListQuery(type: 'newest'),
      );

      expect(result, hasLength(2));
      expect(result[0].id, 'album-1');
      expect(result[1].id, 'album-2');
    });

    test('tryFetchAlbumListResponse returns Result.err for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(albumRepositoryProvider);
      final result = await repository.tryFetchAlbumListResponse(
        query: const AlbumListQuery(type: 'newest'),
      );

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
