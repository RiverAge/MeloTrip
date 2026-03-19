import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/genre/genres_repository.dart';

void main() {
  group('GenresRepository', () {
    late ProviderContainer container;
    late MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          genresRepositoryProvider.overrideWith((ref) {
            return GenresRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetchGenresResponse sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'genres': {'genre': []},
        },
      });

      final repository = container.read(genresRepositoryProvider);
      await repository.fetchGenresResponse();

      expect(mockAdapter.lastRequest?.path, '/rest/getGenres');
    });

    test('fetchGenresResponse returns parsed response', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'genres': {
            'genre': [
              {'id': '1', 'name': 'Rock', 'songCount': 100, 'albumCount': 20},
              {'id': '2', 'name': 'Jazz', 'songCount': 50, 'albumCount': 10},
            ],
          },
        },
      });

      final repository = container.read(genresRepositoryProvider);
      final result = await repository.fetchGenresResponse();

      expect(result, isNotNull);
      expect(result.subsonicResponse?.genres?.genre, hasLength(2));
    });

    test('fetchGenresItems throws for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(genresRepositoryProvider);
      await expectLater(
        repository.fetchGenresItems(),
        throwsA(isA<StateError>()),
      );
    });

    test('fetchGenresItems returns genres from response', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'genres': {
            'genre': [
              {'value': 'Rock', 'songCount': 100},
              {'value': 'Pop', 'songCount': 50},
              {'value': 'Jazz', 'songCount': 30},
            ],
          },
        },
      });

      final repository = container.read(genresRepositoryProvider);
      final result = await repository.fetchGenresItems();

      expect(result, hasLength(3));
      expect(result[0].value, 'Rock');
      expect(result[1].value, 'Pop');
      expect(result[2].value, 'Jazz');
    });

    test('fetchGenresResponse throws for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(genresRepositoryProvider);
      await expectLater(
        repository.fetchGenresResponse(),
        throwsA(isA<StateError>()),
      );
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
