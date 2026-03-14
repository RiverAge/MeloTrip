import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/search_result/search_result3.dart';

void main() {
  group('SearchResult3Entity', () {
    test('parses empty search results', () {
      final json = <String, dynamic>{};
      final entity = SearchResult3Entity.fromJson(json);

      expect(entity.album, isNull);
      expect(entity.song, isNull);
      expect(entity.artist, isNull);
    });

    test('parses search results with albums', () {
      final json = {
        'album': [
          {'id': 'alb-1', 'name': 'Search Album 1'},
          {'id': 'alb-2', 'name': 'Search Album 2'},
        ],
      };

      final entity = SearchResult3Entity.fromJson(json);

      expect(entity.album, isNotNull);
      expect(entity.album?.length, 2);
      expect(entity.album?.first.id, 'alb-1');
      expect(entity.album?.first.name, 'Search Album 1');
    });

    test('parses search results with songs', () {
      final json = {
        'song': [
          {'id': 'song-1', 'title': 'Search Song', 'duration': 240},
        ],
      };

      final entity = SearchResult3Entity.fromJson(json);

      expect(entity.song, isNotNull);
      expect(entity.song?.length, 1);
      expect(entity.song?.first.id, 'song-1');
    });

    test('parses search results with artists', () {
      final json = {
        'artist': [
          {'id': 'art-1', 'name': 'Search Artist'},
          {'id': 'art-2', 'name': 'Another Artist'},
        ],
      };

      final entity = SearchResult3Entity.fromJson(json);

      expect(entity.artist, isNotNull);
      expect(entity.artist?.length, 2);
      expect(entity.artist?.first.name, 'Search Artist');
    });

    test('parses comprehensive search results', () {
      final json = {
        'album': [
          {'id': 'alb-1', 'name': 'Album Result'},
        ],
        'song': [
          {'id': 'song-1', 'title': 'Song Result', 'duration': 180},
          {'id': 'song-2', 'title': 'Another Song', 'duration': 200},
        ],
        'artist': [
          {'id': 'art-1', 'name': 'Artist Result'},
        ],
      };

      final entity = SearchResult3Entity.fromJson(json);

      expect(entity.album?.length, 1);
      expect(entity.song?.length, 2);
      expect(entity.artist?.length, 1);
    });
  });
}
