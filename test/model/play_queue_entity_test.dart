import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/play_queue/play_queue.dart';

void main() {
  group('PlayQueueEntity', () {
    test('parses basic play queue', () {
      final json = {
        'current': 'song-123',
        'position': 5,
        'username': 'admin',
        'changed': '2024-01-15T10:30:00Z',
        'changedBy': 'user1',
      };

      final entity = PlayQueueEntity.fromJson(json);

      expect(entity.current, 'song-123');
      expect(entity.position, 5);
      expect(entity.username, 'admin');
      expect(entity.changed, DateTime.parse('2024-01-15T10:30:00Z'));
      expect(entity.changedBy, 'user1');
      expect(entity.entry, isNull);
    });

    test('parses play queue with songs', () {
      final json = {
        'entry': [
          {'id': 'song-1', 'title': 'Song 1', 'duration': 180},
          {'id': 'song-2', 'title': 'Song 2', 'duration': 200},
        ],
        'current': 'song-1',
        'position': 0,
      };

      final entity = PlayQueueEntity.fromJson(json);

      expect(entity.entry, isNotNull);
      expect(entity.entry?.length, 2);
      expect(entity.entry?.first.id, 'song-1');
      expect(entity.entry?.last.id, 'song-2');
      expect(entity.current, 'song-1');
      expect(entity.position, 0);
    });

    test('handles null fields', () {
      final json = <String, dynamic>{};
      final entity = PlayQueueEntity.fromJson(json);

      expect(entity.entry, isNull);
      expect(entity.current, isNull);
      expect(entity.position, isNull);
      expect(entity.username, isNull);
      expect(entity.changed, isNull);
      expect(entity.changedBy, isNull);
    });

    test('handles empty entry list', () {
      final json = {
        'entry': [],
        'current': null,
        'position': -1,
      };

      final entity = PlayQueueEntity.fromJson(json);

      expect(entity.entry, isEmpty);
      expect(entity.current, isNull);
      expect(entity.position, -1);
    });
  });
}
