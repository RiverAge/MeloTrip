import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/artist/artists_repository.dart';

void main() {
  group('ArtistsRepository', () {
    late ProviderContainer container;
    late MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          artistsRepositoryProvider.overrideWith((ref) {
            return ArtistsRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetchAllArtists sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'artists': {'index': []},
        },
      });

      final repository = container.read(artistsRepositoryProvider);
      await repository.fetchAllArtists();

      expect(mockAdapter.lastRequest?.path, '/rest/getArtists');
    });

    test('fetchAllArtists parses artists from single index', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'artists': {
            'index': [
              {
                'name': 'A',
                'artist': [
                  {'id': 'artist-1', 'name': 'ABBA', 'albumCount': 5},
                  {'id': 'artist-2', 'name': 'AC/DC', 'albumCount': 12},
                ],
              },
            ],
          },
        },
      });

      final repository = container.read(artistsRepositoryProvider);
      final result = await repository.fetchAllArtists();

      expect(result, hasLength(2));
      expect(result[0].id, 'artist-1');
      expect(result[0].name, 'ABBA');
      expect(result[0].albumCount, 5);
      expect(result[1].id, 'artist-2');
      expect(result[1].name, 'AC/DC');
    });

    test('fetchAllArtists parses artists from multiple indexes', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'artists': {
            'index': [
              {
                'name': 'A',
                'artist': [
                  {'id': 'artist-1', 'name': 'Artist A'},
                ],
              },
              {
                'name': 'B',
                'artist': [
                  {'id': 'artist-2', 'name': 'Artist B'},
                  {'id': 'artist-3', 'name': 'Artist C'},
                ],
              },
            ],
          },
        },
      });

      final repository = container.read(artistsRepositoryProvider);
      final result = await repository.fetchAllArtists();

      expect(result, hasLength(3));
      expect(result[0].name, 'Artist A');
      expect(result[1].name, 'Artist B');
      expect(result[2].name, 'Artist C');
    });

    test('fetchAllArtists handles missing optional fields', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'artists': {
            'index': [
              {
                'artist': [
                  {'id': 'artist-1', 'name': 'Test Artist'},
                ],
              },
            ],
          },
        },
      });

      final repository = container.read(artistsRepositoryProvider);
      final result = await repository.fetchAllArtists();

      expect(result, hasLength(1));
      expect(result[0].coverArt, isNull);
      expect(result[0].albumCount, isNull);
    });

    test('fetchAllArtists throws for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(artistsRepositoryProvider);
      await expectLater(
        repository.fetchAllArtists(),
        throwsA(isA<StateError>()),
      );
    });

    test('fetchAllArtists returns empty list for missing artists', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(artistsRepositoryProvider);
      final result = await repository.fetchAllArtists();

      expect(result, isEmpty);
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
