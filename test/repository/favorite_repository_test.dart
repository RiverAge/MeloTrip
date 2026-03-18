import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/favorite/favorite_repository.dart';

void main() {
  group('FavoriteRepository', () {
    late ProviderContainer container;
    late MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          favoriteRepositoryProvider.overrideWith((ref) {
            return FavoriteRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetchStarred sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'starred': {},
        },
      });

      final repository = container.read(favoriteRepositoryProvider);
      await repository.fetchStarred();

      expect(mockAdapter.lastRequest?.path, '/rest/getStarred');
    });

    test('fetchStarred returns parsed response with songs', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'starred': {
            'song': [
              {'id': 'song-1', 'title': 'Favorite Song'},
              {'id': 'song-2', 'title': 'Another Favorite'},
            ],
          },
        },
      });

      final repository = container.read(favoriteRepositoryProvider);
      final result = await repository.fetchStarred();

      expect(result, isNotNull);
      expect(result?.subsonicResponse?.starred?.song, hasLength(2));
      expect(result?.subsonicResponse?.starred?.song?.first.id, 'song-1');
    });

    test('fetchStarred returns parsed response with albums and artists', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'starred': {
            'album': [
              {'id': 'album-1', 'name': 'Favorite Album'},
            ],
            'artist': [
              {'id': 'artist-1', 'name': 'Favorite Artist'},
            ],
          },
        },
      });

      final repository = container.read(favoriteRepositoryProvider);
      final result = await repository.fetchStarred();

      expect(result, isNotNull);
      expect(result?.subsonicResponse?.starred?.album, hasLength(1));
      expect(result?.subsonicResponse?.starred?.artist, hasLength(1));
    });

    test('fetchStarred returns null for null data', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(favoriteRepositoryProvider);
      final result = await repository.fetchStarred();

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
