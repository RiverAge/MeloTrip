import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/playlist/playlist_repository.dart';

void main() {
  group('PlaylistRepository', () {
    late ProviderContainer container;
    late MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWith((ref) {
            return PlaylistRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetchPlaylists sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'playlists': {'playlist': []},
        },
      });

      final repository = container.read(playlistRepositoryProvider);
      await repository.fetchPlaylists();

      expect(mockAdapter.lastRequest?.path, '/rest/getPlaylists');
    });

    test('fetchPlaylists returns parsed response', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'playlists': {
            'playlist': [
              {'id': 'pl-1', 'name': 'My Playlist', 'songCount': 10},
            ],
          },
        },
      });

      final repository = container.read(playlistRepositoryProvider);
      final result = await repository.fetchPlaylists();

      expect(result, isNotNull);
      expect(result.subsonicResponse?.playlists?.playlist, hasLength(1));
    });

    test('fetchPlaylistDetail sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'playlist': {'id': 'pl-123'},
        },
      });

      final repository = container.read(playlistRepositoryProvider);
      await repository.fetchPlaylistDetail('pl-123');

      expect(mockAdapter.lastRequest?.path, '/rest/getPlaylist');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'pl-123');
    });

    test('createPlaylist sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'playlist': {'id': 'pl-new', 'name': 'New Playlist'},
        },
      });

      final repository = container.read(playlistRepositoryProvider);
      await repository.createPlaylist('New Playlist');

      expect(mockAdapter.lastRequest?.path, '/rest/createPlaylist');
      expect(mockAdapter.lastRequest?.queryParameters['name'], 'New Playlist');
    });

    test('deletePlaylist sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(playlistRepositoryProvider);
      await repository.deletePlaylist('pl-123');

      expect(mockAdapter.lastRequest?.path, '/rest/deletePlaylist');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'pl-123');
    });

    test('updatePlaylist sends all parameters', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(playlistRepositoryProvider);
      await repository.updatePlaylist(
        playlistId: 'pl-123',
        songIndexToRemove: 2,
        songIdToAdd: 'song-456',
        name: 'Updated Name',
        comment: 'Updated comment',
        public: true,
      );

      expect(mockAdapter.lastRequest?.path, '/rest/updatePlaylist');
      expect(mockAdapter.lastRequest?.queryParameters['playlistId'], 'pl-123');
      expect(mockAdapter.lastRequest?.queryParameters['songIndexToRemove'], 2);
      expect(mockAdapter.lastRequest?.queryParameters['songIdToAdd'], 'song-456');
      expect(mockAdapter.lastRequest?.queryParameters['name'], 'Updated Name');
      expect(mockAdapter.lastRequest?.queryParameters['comment'], 'Updated comment');
      expect(mockAdapter.lastRequest?.queryParameters['public'], true);
    });

    test('updatePlaylist only sends provided parameters', () async {
      mockAdapter.setResponse({
        'subsonic-response': {'status': 'ok'},
      });

      final repository = container.read(playlistRepositoryProvider);
      await repository.updatePlaylist(
        playlistId: 'pl-123',
        name: 'New Name',
      );

      expect(mockAdapter.lastRequest?.queryParameters['playlistId'], 'pl-123');
      expect(mockAdapter.lastRequest?.queryParameters['name'], 'New Name');
      expect(mockAdapter.lastRequest?.queryParameters.containsKey('songIndexToRemove'), isFalse);
      expect(mockAdapter.lastRequest?.queryParameters.containsKey('songIdToAdd'), isFalse);
    });

    test('updatePlaylist throws for failed status', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'failed',
          'error': {'message': 'Playlist not found'},
        },
      });

      final repository = container.read(playlistRepositoryProvider);
      await expectLater(
        repository.updatePlaylist(playlistId: 'pl-123'),
        throwsA(isA<StateError>()),
      );
    });

    test('fetchPlaylists throws for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(playlistRepositoryProvider);
      await expectLater(
        repository.fetchPlaylists(),
        throwsA(isA<StateError>()),
      );
    });

    test('tryFetchPlaylists returns Result.err for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(playlistRepositoryProvider);
      final result = await repository.tryFetchPlaylists();

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
