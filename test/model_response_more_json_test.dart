import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/error/error.dart';
import 'package:melo_trip/model/response/play_queue/play_queue.dart';
import 'package:melo_trip/model/response/search_result/search_result3.dart';
import 'package:melo_trip/model/response/similar_songs/similar_songs2.dart';
import 'package:melo_trip/model/response/songs_by_genre/songs_by_gener.dart';
import 'package:melo_trip/model/response/starred/starred.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';

void main() {
  group('more response json coverage', () {
    test('ErrorEntity parse/serialize', () {
      final error = ErrorEntity.fromJson({'code': 40, 'message': 'not found'});
      expect(error.code, 40);
      expect(error.message, 'not found');
      expect(error.toJson()['code'], 40);
      expect(error.toJson()['message'], 'not found');
    });

    test('PlayQueueEntity parse with DateTime and entries', () {
      final queue = PlayQueueEntity.fromJson({
        'entry': [
          {'id': 's1', 'title': 'Song 1'},
          {'id': 's2', 'title': 'Song 2'},
        ],
        'current': 's1',
        'position': 12000,
        'username': 'u1',
        'changed': '2026-03-05T10:20:30.000Z',
        'changedBy': 'system',
      });
      expect(queue.entry, hasLength(2));
      expect(queue.current, 's1');
      expect(queue.position, 12000);
      expect(queue.username, 'u1');
      expect(queue.changed, DateTime.parse('2026-03-05T10:20:30.000Z'));
      expect(queue.changedBy, 'system');
      expect(queue.toJson()['entry'], isA<List<dynamic>>());
      expect(queue.toJson()['changed'], isA<String>());
    });

    test('SimilarSongs2Entity and SongsByGenreEntity parse list', () {
      final similar = SimilarSongs2Entity.fromJson({
        'song': [
          {'id': 's1', 'title': 'A'},
          {'id': 's2', 'title': 'B'},
        ],
      });
      expect(similar.song, hasLength(2));
      expect(similar.toJson()['song'], isA<List<dynamic>>());

      final byGenre = SongsByGenreEntity.fromJson({
        'song': [
          {'id': 'g1', 'title': 'Rock One'},
        ],
      });
      expect(byGenre.song, hasLength(1));
      expect(byGenre.song!.single.id, 'g1');
      expect(byGenre.toJson()['song'], isA<List<dynamic>>());
    });

    test('StarredEntity and SearchResult3Entity parse nested lists', () {
      final starred = StarredEntity.fromJson({
        'song': [
          {'id': 's1', 'title': 'Song'},
        ],
        'album': [
          {'id': 'a1', 'name': 'Album'},
        ],
        'artist': [
          {'id': 'ar1', 'name': 'Artist'},
        ],
      });
      expect(starred.song!.single.id, 's1');
      expect(starred.album!.single.id, 'a1');
      expect(starred.artist!.single.id, 'ar1');
      expect(starred.toJson()['song'], isA<List<dynamic>>());

      final search = SearchResult3Entity.fromJson({
        'song': [
          {'id': 's1', 'title': 'Hit'},
        ],
        'album': [
          {'id': 'a1', 'name': 'Best'},
        ],
        'artist': [
          {'id': 'ar1', 'name': 'Top'},
        ],
      });
      expect(search.song!.single.id, 's1');
      expect(search.album!.single.id, 'a1');
      expect(search.artist!.single.id, 'ar1');
      expect(search.toJson()['album'], isA<List<dynamic>>());
    });

    test(
      'SubsonicResponse maps error/playQueue/similar/songsByGenre fields',
      () {
        final response = SubsonicResponse.fromJson({
          'subsonic-response': {
            'status': 'failed',
            'error': {'code': 70, 'message': 'boom'},
            'playQueue': {
              'current': 's1',
              'entry': [
                {'id': 's1', 'title': 'Song'},
              ],
            },
            'similarSongs2': {
              'song': [
                {'id': 's2', 'title': 'Similar'},
              ],
            },
            'songsByGenre': {
              'song': [
                {'id': 's3', 'title': 'Genre Song'},
              ],
            },
          },
        });

        final root = response.subsonicResponse;
        expect(root?.status, 'failed');
        expect(root?.error?.code, 70);
        expect(root?.playQueue?.current, 's1');
        expect(root?.similarSongs2?.song?.single.id, 's2');
        expect(root?.songsByGenre?.song?.single.id, 's3');
        expect(response.toJson().containsKey('subsonic-response'), isTrue);
      },
    );
  });
}
