import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/genre/genre.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/random_song/random_song.dart';
import 'package:melo_trip/model/response/scan_status/scan_status.dart';

void main() {
  group('response model json', () {
    test('GenreEntity and GenresEntity parse and serialize', () {
      final genres = GenresEntity.fromJson({
        'genre': [
          {'value': 'Rock', 'songCount': 12, 'albumCount': 3},
        ],
      });

      expect(genres.genre, isNotNull);
      expect(genres.genre!.single.value, 'Rock');
      expect(genres.genre!.single.songCount, 12);
      expect(genres.toJson()['genre'], isA<List<dynamic>>());
    });

    test('PlaylistEntity parses nested song entries', () {
      final playlist = PlaylistEntity.fromJson({
        'id': 'p1',
        'name': 'Fav',
        'songCount': 1,
        'entry': [
          {
            'id': 's1',
            'title': 'Song One',
            'artist': 'A',
            'duration': 120,
          },
        ],
      });

      expect(playlist.id, 'p1');
      expect(playlist.entry, isNotNull);
      expect(playlist.entry!.single.id, 's1');
      expect(playlist.entry!.single.duration, 120);
      expect(playlist.toJson()['entry'], isA<List<dynamic>>());
    });

    test('RandomSongsEntity parses list payload', () {
      final randomSongs = RandomSongsEntity.fromJson({
        'song': [
          {'id': 'r1', 'title': 'Random 1'},
          {'id': 'r2', 'title': 'Random 2'},
        ],
      });

      expect(randomSongs.song, hasLength(2));
      expect(randomSongs.song!.first.title, 'Random 1');
      expect(randomSongs.toJson()['song'], isA<List<dynamic>>());
    });

    test('ArtistEntity parses nested albums', () {
      final artist = ArtistEntity.fromJson({
        'id': 'a1',
        'name': 'Artist',
        'album': [
          {'id': 'al1', 'name': 'Album 1'},
        ],
      });

      expect(artist.id, 'a1');
      expect(artist.album, isNotNull);
      expect(artist.album!.single.id, 'al1');
      expect(artist.toJson()['album'], isA<List<dynamic>>());
    });

    test('ScanStatusEntity parses DateTime and counters', () {
      final status = ScanStatusEntity.fromJson({
        'scanning': true,
        'count': 10,
        'folderCount': 2,
        'lastScan': '2026-03-05T10:20:30.000Z',
      });

      expect(status.scanning, isTrue);
      expect(status.count, 10);
      expect(status.folderCount, 2);
      expect(status.lastScan, DateTime.parse('2026-03-05T10:20:30.000Z'));
      expect(status.toJson()['lastScan'], isA<String>());
    });
  });
}
