import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/play_queue/play_queue_repository.dart';

void main() {
  group('PlayQueueRepository', () {
    late ProviderContainer container;
    late MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          playQueueRepositoryProvider.overrideWith((ref) {
            return PlayQueueRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetchPlayQueue sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'playQueue': {},
        },
      });

      final repository = container.read(playQueueRepositoryProvider);
      await repository.fetchPlayQueue();

      expect(mockAdapter.lastRequest?.path, '/rest/getPlayQueue');
    });

    test('fetchPlayQueue returns parsed response', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'playQueue': {
            'current': 'song-1',
            'position': 30,
            'username': 'testuser',
            'entry': [
              {'id': 'song-1', 'title': 'First Song'},
              {'id': 'song-2', 'title': 'Second Song'},
            ],
          },
        },
      });

      final repository = container.read(playQueueRepositoryProvider);
      final result = await repository.fetchPlayQueue();

      expect(result, isNotNull);
      expect(result.subsonicResponse?.playQueue?.current, 'song-1');
      expect(result.subsonicResponse?.playQueue?.position, 30);
    });

    test('fetchPlayQueue returns null for null data', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(playQueueRepositoryProvider);
      final result = await repository.fetchPlayQueue();

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
