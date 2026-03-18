import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/artist/artist_detail_repository.dart';

void main() {
  group('ArtistDetailRepository', () {
    late ProviderContainer container;
    late MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          artistDetailRepositoryProvider.overrideWith((ref) {
            return ArtistDetailRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetchArtistDetail sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'artist': {'id': 'artist-456', 'name': 'Test Artist'},
        },
      });

      final repository = container.read(artistDetailRepositoryProvider);
      await repository.fetchArtistDetail('artist-456');

      expect(mockAdapter.lastRequest?.path, '/rest/getArtist');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'artist-456');
    });

    test('fetchArtistDetail returns parsed response', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'artist': {
            'id': 'artist-456',
            'name': 'Test Artist',
            'albumCount': 10,
            'album': [
              {'id': 'album-1', 'name': 'Album One'},
            ],
          },
        },
      });

      final repository = container.read(artistDetailRepositoryProvider);
      final result = await repository.fetchArtistDetail('artist-456');

      expect(result, isNotNull);
      expect(result.subsonicResponse?.artist?.id, 'artist-456');
      expect(result.subsonicResponse?.artist?.name, 'Test Artist');
    });

    test('fetchArtistDetail throws for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(artistDetailRepositoryProvider);
      await expectLater(
        repository.fetchArtistDetail('artist-456'),
        throwsA(isA<StateError>()),
      );
    });

    test('fetchArtistDetailResult returns Result.err for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(artistDetailRepositoryProvider);
      final result = await repository.fetchArtistDetailResult('artist-456');

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
