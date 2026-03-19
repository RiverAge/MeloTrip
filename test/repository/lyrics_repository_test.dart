import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/lyrics/lyrics_repository.dart';

void main() {
  group('LyricsRepository', () {
    late ProviderContainer container;
    late MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          lyricsRepositoryProvider.overrideWith((ref) {
            return LyricsRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetchLyrics sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'lyrics': {'text': 'Test lyrics'},
        },
      });

      final repository = container.read(lyricsRepositoryProvider);
      await repository.fetchLyrics('song-123');

      expect(mockAdapter.lastRequest?.path, '/rest/getLyricsBySongId');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'song-123');
    });

    test('fetchLyrics returns parsed response', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'lyricsList': {
            'structuredLyrics': [
              {
                'displayArtist': 'Test Artist',
                'displayTitle': 'Test Song',
                'synced': true,
              },
            ],
          },
        },
      });

      final repository = container.read(lyricsRepositoryProvider);
      final result = await repository.fetchLyrics('song-123');

      expect(result, isNotNull);
      expect(result.subsonicResponse?.lyricsList?.structuredLyrics?.first.displayArtist, 'Test Artist');
      expect(result.subsonicResponse?.lyricsList?.structuredLyrics?.first.displayTitle, 'Test Song');
    });

    test('fetchLyrics throws for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(lyricsRepositoryProvider);
      await expectLater(
        repository.fetchLyrics('song-123'),
        throwsA(isA<StateError>()),
      );
    });

    test('fetchLyricsResult returns Result.err for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(lyricsRepositoryProvider);
      final result = await repository.fetchLyricsResult('song-123');

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
