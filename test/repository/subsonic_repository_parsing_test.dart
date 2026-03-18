import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/artist/artists_repository.dart';
import 'package:melo_trip/repository/folder/folders_repository.dart';

void main() {
  group('Subsonic repository parsing', () {
    test('ArtistsRepository parses artists list from SubsonicResponse model', () async {
      final dio = Dio();
      dio.httpClientAdapter = _JsonAdapter((options) {
        expect(options.path, '/rest/getArtists');
        return <String, dynamic>{
          'subsonic-response': {
            'status': 'ok',
            'artists': {
              'index': [
                {
                  'name': 'A',
                  'artist': [
                    {
                      'id': '1',
                      'name': 'Alpha',
                      'coverArt': 'cover-a',
                      'albumCount': 12,
                    },
                    {
                      'id': '2',
                      'name': 'Beta',
                    },
                  ],
                },
              ],
            },
          },
        };
      });

      final repository = ArtistsRepository(() async => dio);
      final entries = await repository.fetchAllArtists();

      expect(entries.length, 2);
      expect(entries.first.id, '1');
      expect(entries.first.name, 'Alpha');
      expect(entries.first.coverArt, 'cover-a');
      expect(entries.first.albumCount, 12);
      expect(entries.last.id, '2');
      expect(entries.last.name, 'Beta');
    });

    test('FoldersRepository parses indexes and directory children from SubsonicResponse model', () async {
      final dio = Dio();
      dio.httpClientAdapter = _JsonAdapter((options) {
        if (options.path == '/rest/getIndexes') {
          return <String, dynamic>{
            'subsonic-response': {
              'status': 'ok',
              'indexes': {
                'index': [
                  {
                    'name': 'A',
                    'artist': [
                      {'id': 'folder-1', 'name': 'Folder A'},
                      {'id': '', 'name': 'Ignored'},
                    ],
                  },
                ],
              },
            },
          };
        }

        if (options.path == '/rest/getMusicDirectory') {
          expect(options.queryParameters['id'], 'folder-1');
          return <String, dynamic>{
            'subsonic-response': {
              'status': 'ok',
              'directory': {
                'id': 'folder-1',
                'child': [
                  {
                    'id': 'song-1',
                    'title': 'Track 1',
                    'isDir': false,
                    'artist': 'Singer',
                    'duration': 120,
                  },
                ],
              },
            },
          };
        }

        throw StateError('Unexpected path: ${options.path}');
      });

      final repository = FoldersRepository(() async => dio);
      final indexes = await repository.fetchFolderIndexes();
      final children = await repository.fetchMusicDirectory('folder-1');

      expect(indexes.length, 1);
      expect(indexes.first.id, 'folder-1');
      expect(indexes.first.name, 'Folder A');

      expect(children.length, 1);
      expect(children.first.id, 'song-1');
      expect(children.first.name, 'Track 1');
      expect(children.first.isDir, isFalse);
      expect(children.first.artist, 'Singer');
      expect(children.first.duration, 120);
    });
  });
}

class _JsonAdapter implements HttpClientAdapter {
  _JsonAdapter(this._payloadBuilder);

  final Map<String, dynamic> Function(RequestOptions options) _payloadBuilder;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final payload = _payloadBuilder(options);
    return ResponseBody.fromBytes(
      utf8.encode(jsonEncode(payload)),
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }
}
