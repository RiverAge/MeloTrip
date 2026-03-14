import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';

void main() {
  group('PlaylistEntity', () {
    test('parses basic playlist JSON', () {
      final json = {
        'id': 'pl-123',
        'name': 'My Playlist',
        'comment': 'Test playlist',
        'songCount': 10,
        'duration': 3600,
        'public': true,
        'owner': 'admin',
        'created': '2024-01-15T10:30:00Z',
        'changed': '2024-01-16T14:20:00Z',
        'coverArt': 'cover-123',
      };

      final entity = PlaylistEntity.fromJson(json);

      expect(entity.id, 'pl-123');
      expect(entity.name, 'My Playlist');
      expect(entity.comment, 'Test playlist');
      expect(entity.songCount, 10);
      expect(entity.duration, 3600);
      expect(entity.public, true);
      expect(entity.owner, 'admin');
      expect(entity.created, DateTime.parse('2024-01-15T10:30:00Z'));
      expect(entity.changed, DateTime.parse('2024-01-16T14:20:00Z'));
      expect(entity.coverArt, 'cover-123');
      expect(entity.entry, isNull);
    });

    test('parses playlist with songs', () {
      final json = {
        'id': 'pl-456',
        'name': 'Favorites',
        'songCount': 1,
        'duration': 180,
        'public': false,
        'entry': [
          {'id': 'song-1', 'title': 'Test Song', 'duration': 180},
        ],
      };

      final entity = PlaylistEntity.fromJson(json);

      expect(entity.id, 'pl-456');
      expect(entity.name, 'Favorites');
      expect(entity.public, false);
      expect(entity.entry, isNotNull);
      expect(entity.entry?.length, 1);
    });

    test('handles null fields', () {
      final json = <String, dynamic>{};
      final entity = PlaylistEntity.fromJson(json);

      expect(entity.id, isNull);
      expect(entity.name, isNull);
      expect(entity.songCount, isNull);
    });
  });

  group('PlaylistsEntity', () {
    test('parses playlists collection', () {
      final json = {
        'playlist': [
          {'id': 'pl-1', 'name': 'Playlist 1'},
          {'id': 'pl-2', 'name': 'Playlist 2'},
        ],
      };

      final entity = PlaylistsEntity.fromJson(json);

      expect(entity.playlist, isNotNull);
      expect(entity.playlist?.length, 2);
      expect(entity.playlist?.first.id, 'pl-1');
      expect(entity.playlist?.last.id, 'pl-2');
    });

    test('handles empty playlists', () {
      final json = {'playlist': []};
      final entity = PlaylistsEntity.fromJson(json);

      expect(entity.playlist, isEmpty);
    });

    test('handles missing playlist array', () {
      final json = <String, dynamic>{};
      final entity = PlaylistsEntity.fromJson(json);

      expect(entity.playlist, isNull);
    });
  });
}
