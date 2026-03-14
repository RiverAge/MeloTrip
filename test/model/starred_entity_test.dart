import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/starred/starred.dart';

void main() {
  group('StarredEntity', () {
    test('parses empty starred entity', () {
      final json = <String, dynamic>{};
      final entity = StarredEntity.fromJson(json);

      expect(entity.song, isNull);
      expect(entity.album, isNull);
      expect(entity.artist, isNull);
    });

    test('parses starred songs', () {
      final json = {
        'song': [
          {'id': 'song-1', 'title': 'Starred Song 1', 'duration': 200},
          {'id': 'song-2', 'title': 'Starred Song 2', 'duration': 180},
        ],
      };

      final entity = StarredEntity.fromJson(json);

      expect(entity.song, isNotNull);
      expect(entity.song?.length, 2);
      expect(entity.song?.first.id, 'song-1');
      expect(entity.song?.last.id, 'song-2');
    });

    test('parses starred albums', () {
      final json = {
        'album': [
          {'id': 'alb-1', 'name': 'Starred Album'},
          {'id': 'alb-2', 'name': 'Another Album'},
        ],
      };

      final entity = StarredEntity.fromJson(json);

      expect(entity.album, isNotNull);
      expect(entity.album?.length, 2);
      expect(entity.album?.first.id, 'alb-1');
      expect(entity.album?.last.id, 'alb-2');
    });

    test('parses starred artists', () {
      final json = {
        'artist': [
          {'id': 'art-1', 'name': 'Starred Artist'},
        ],
      };

      final entity = StarredEntity.fromJson(json);

      expect(entity.artist, isNotNull);
      expect(entity.artist?.length, 1);
      expect(entity.artist?.first.id, 'art-1');
    });

    test('parses mixed starred content', () {
      final json = {
        'song': [
          {'id': 'song-1', 'title': 'Song', 'duration': 100},
        ],
        'album': [
          {'id': 'alb-1', 'name': 'Album'},
        ],
        'artist': [
          {'id': 'art-1', 'name': 'Artist'},
        ],
      };

      final entity = StarredEntity.fromJson(json);

      expect(entity.song?.length, 1);
      expect(entity.album?.length, 1);
      expect(entity.artist?.length, 1);
    });
  });
}
