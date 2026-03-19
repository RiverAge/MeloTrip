import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/folder/folders_repository.dart';

void main() {
  group('FoldersRepository', () {
    late ProviderContainer container;
    late MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          foldersRepositoryProvider.overrideWith((ref) {
            return FoldersRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetchFolderIndexes sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'indexes': {'index': []},
        },
      });

      final repository = container.read(foldersRepositoryProvider);
      await repository.fetchFolderIndexes();

      expect(mockAdapter.lastRequest?.path, '/rest/getIndexes');
    });

    test('fetchFolderIndexes parses artists from indexes', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'indexes': {
            'index': [
              {
                'name': 'A',
                'artist': [
                  {'id': 'folder-1', 'name': 'Artist A'},
                  {'id': 'folder-2', 'name': 'Artist B'},
                ],
              },
            ],
          },
        },
      });

      final repository = container.read(foldersRepositoryProvider);
      final result = await repository.fetchFolderIndexes();

      expect(result, hasLength(2));
      expect(result[0].id, 'folder-1');
      expect(result[0].name, 'Artist A');
    });

    test('fetchFolderIndexes skips entries with empty id', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'indexes': {
            'index': [
              {
                'artist': [
                  {'id': '', 'name': 'Invalid'},
                  {'id': 'folder-1', 'name': 'Valid'},
                ],
              },
            ],
          },
        },
      });

      final repository = container.read(foldersRepositoryProvider);
      final result = await repository.fetchFolderIndexes();

      expect(result, hasLength(1));
      expect(result[0].id, 'folder-1');
    });

    test('fetchFolderIndexes throws for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(foldersRepositoryProvider);
      await expectLater(
        repository.fetchFolderIndexes(),
        throwsA(isA<StateError>()),
      );
    });

    test('fetchMusicDirectory sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'directory': {'child': []},
        },
      });

      final repository = container.read(foldersRepositoryProvider);
      await repository.fetchMusicDirectory('dir-123');

      expect(mockAdapter.lastRequest?.path, '/rest/getMusicDirectory');
      expect(mockAdapter.lastRequest?.queryParameters['id'], 'dir-123');
    });

    test('fetchMusicDirectory parses children', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'directory': {
            'id': 'dir-123',
            'child': [
              {
                'id': 'child-1',
                'title': 'Subfolder',
                'isDir': true,
              },
              {
                'id': 'child-2',
                'title': 'Song Title',
                'isDir': false,
                'artist': 'Artist Name',
                'album': 'Album Name',
                'year': 2023,
                'duration': 180,
              },
            ],
          },
        },
      });

      final repository = container.read(foldersRepositoryProvider);
      final result = await repository.fetchMusicDirectory('dir-123');

      expect(result, hasLength(2));
      expect(result[0].id, 'child-1');
      expect(result[0].isDir, true);
      expect(result[1].id, 'child-2');
      expect(result[1].isDir, false);
      expect(result[1].artist, 'Artist Name');
      expect(result[1].album, 'Album Name');
      expect(result[1].year, 2023);
      expect(result[1].duration, 180);
    });

    test('fetchMusicDirectory throws for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(foldersRepositoryProvider);
      await expectLater(
        repository.fetchMusicDirectory('dir-123'),
        throwsA(isA<StateError>()),
      );
    });

    test('fetchMusicDirectory uses name when title is missing', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'directory': {
            'child': [
              {'id': 'child-1', 'name': 'Folder Name'},
            ],
          },
        },
      });

      final repository = container.read(foldersRepositoryProvider);
      final result = await repository.fetchMusicDirectory('dir-123');

      expect(result[0].name, 'Folder Name');
    });

    test('fetchDirectoryFolders keeps only directory entries', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'directory': {
            'child': [
              {'id': 'dir-1', 'title': 'Folder', 'isDir': true},
              {'id': 'song-1', 'title': 'Song', 'isDir': false},
            ],
          },
        },
      });

      final repository = container.read(foldersRepositoryProvider);
      final result = await repository.fetchDirectoryFolders('root');

      expect(result, hasLength(1));
      expect(result.first.id, 'dir-1');
      expect(result.first.isDir, isTrue);
    });

    test('tryFetchFolderIndexes returns Result.err for empty payload', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(foldersRepositoryProvider);
      final result = await repository.tryFetchFolderIndexes();

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
