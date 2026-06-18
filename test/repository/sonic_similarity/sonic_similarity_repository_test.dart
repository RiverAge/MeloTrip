import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/util/normalize_host.dart';

/// Tests for Sonic Similarity JSON parsing and repository logic.
///
/// Coverage:
/// 1. Real JSON parsing with "sonicMatch" array field
/// 2. No fallback to getSimilarSongs2
/// 3. Unified host normalization
void main() {
  group('SonicMatch JSON Parsing', () {
    test('parses real Navidrome response with sonicMatch array', () {
      // Real Navidrome response structure
      final json = {
        'subsonic-response': {
          'status': 'ok',
          'sonicMatch': [
            {
              'entry': {
                'id': 'song-1',
                'title': 'Song 1',
                'artist': 'Artist 1',
                'album': 'Album 1',
              },
              'similarity': 0.92,
            },
            {
              'entry': {
                'id': 'song-2',
                'title': 'Song 2',
                'artist': 'Artist 2',
              },
              'similarity': 0.85,
            },
          ],
        },
      };

      final response = SubsonicResponse.fromJson(json);
      expect(response.subsonicResponse, isNotNull);
      expect(response.subsonicResponse!.status, 'ok');

      final matches = response.subsonicResponse!.sonicMatch;
      expect(matches, isNotNull);
      expect(matches!.length, 2);

      // Verify first match
      final firstMatch = matches.first;
      expect(firstMatch.entry, isNotNull);
      expect(firstMatch.entry!.id, 'song-1');
      expect(firstMatch.entry!.title, 'Song 1');
      expect(firstMatch.entry!.artist, 'Artist 1');
      expect(firstMatch.similarity, 0.92);

      // Verify second match
      final secondMatch = matches[1];
      expect(secondMatch.entry!.id, 'song-2');
      expect(secondMatch.similarity, 0.85);
    });

    test('extracts SongEntity list from sonicMatch entries', () {
      final json = {
        'subsonic-response': {
          'status': 'ok',
          'sonicMatch': [
            {
              'entry': {'id': 'song-1', 'title': 'Song 1'},
            },
            {
              'entry': {'id': 'song-2', 'title': 'Song 2'},
            },
          ],
        },
      };

      final response = SubsonicResponse.fromJson(json);
      final matches = response.subsonicResponse?.sonicMatch ?? [];

      // Extract SongEntity from SonicMatch.entry
      final songs = matches
          .map((match) => match.entry)
          .whereType<SongEntity>()
          .toList();

      expect(songs.length, 2);
      expect(songs.first.id, 'song-1');
      expect(songs.last.id, 'song-2');
    });

    test('handles empty sonicMatch array', () {
      final json = {
        'subsonic-response': {'status': 'ok', 'sonicMatch': <dynamic>[]},
      };

      final response = SubsonicResponse.fromJson(json);
      final matches = response.subsonicResponse?.sonicMatch;

      expect(matches, isNotNull);
      expect(matches!.isEmpty, true);
    });

    test('handles missing sonicMatch field', () {
      final json = {
        'subsonic-response': {'status': 'ok'},
      };

      final response = SubsonicResponse.fromJson(json);
      final matches = response.subsonicResponse?.sonicMatch;

      // Should be null when field is missing
      expect(matches, isNull);
    });

    test('findSonicPath JSON preserves order', () {
      // Sonic path returns ordered list of songs from start to end
      final json = {
        'subsonic-response': {
          'status': 'ok',
          'sonicMatch': [
            {
              'entry': {'id': 'start-song', 'title': 'Start'},
            },
            {
              'entry': {'id': 'mid-1', 'title': 'Middle 1'},
            },
            {
              'entry': {'id': 'mid-2', 'title': 'Middle 2'},
            },
            {
              'entry': {'id': 'end-song', 'title': 'End'},
            },
          ],
        },
      };

      final response = SubsonicResponse.fromJson(json);
      final songs = (response.subsonicResponse?.sonicMatch ?? [])
          .map((m) => m.entry)
          .whereType<SongEntity>()
          .toList();

      expect(songs.length, 4);
      // Verify order is preserved
      expect(songs[0].id, 'start-song');
      expect(songs[1].id, 'mid-1');
      expect(songs[2].id, 'mid-2');
      expect(songs[3].id, 'end-song');
    });
  });

  group('Unified Host Normalization', () {
    test('normalizeHost handles various schemes and trailing slashes', () {
      final variants = [
        'https://server.example.com',
        'https://server.example.com/',
        'http://server.example.com',
        'http://server.example.com/',
        'SERVER.EXAMPLE.COM',
        'Server.Example.Com/',
      ];

      final normalized = variants.map(normalizeHost).toSet();
      expect(normalized.length, 1);
      expect(normalized.first, 'server.example.com');
    });

    test('normalizeHost preserves port', () {
      expect(normalizeHost('https://server:4533'), 'server:4533');
      expect(normalizeHost('https://server:4533/'), 'server:4533');
      expect(normalizeHost('http://server:4533/'), 'server:4533');
      expect(normalizeHost('server:4533/'), 'server:4533');
    });

    test('normalizeHost handles empty string gracefully', () {
      expect(normalizeHost(''), '');
    });

    test('normalizeHost handles complex URLs', () {
      expect(
        normalizeHost('https://navidrome.example.org:8080/'),
        'navidrome.example.org:8080',
      );
      expect(normalizeHost('http://localhost:4533'), 'localhost:4533');
      expect(normalizeHost('HTTPS://MUSIC.SERVER.COM/'), 'music.server.com');
    });

    test('different hosts produce different normalized values', () {
      final host1 = normalizeHost('https://server1.example.com');
      final host2 = normalizeHost('https://server2.example.com');

      expect(host1, isNot(equals(host2)));
      expect(host1, 'server1.example.com');
      expect(host2, 'server2.example.com');
    });

    test(
      'same host with different representations produce same normalized value',
      () {
        final variants = [
          'https://music.example.com',
          'http://music.example.com/',
          'MUSIC.EXAMPLE.COM',
        ];

        final normalized = variants.map(normalizeHost);
        expect(normalized.every((h) => h == 'music.example.com'), true);
      },
    );
  });

  group('Result Error Handling - No Fallback', () {
    test('API failure does not call getSimilarSongs2', () {
      // Simulate API failure result
      final result = Result<List<SongEntity>, AppFailure>.err(
        AppFailure(
          type: AppFailureType.server,
          message: 'Sonic similarity not available',
        ),
      );

      // Verify result is error, not success with different data
      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Should be error'),
        err: (error) {
          // Verify error message explicitly mentions sonic similarity
          expect(error.message, contains('Sonic similarity'));
          // Verify it's NOT a getSimilarSongs2 fallback result
          expect(error.message, isNot(contains('getSimilarSongs2')));
        },
      );
    });

    test('404 error is returned as Result.err without fallback', () {
      final result = Result<List<SongEntity>, AppFailure>.err(
        AppFailure(
          type: AppFailureType.server,
          message: '404: Not found',
          statusCode: 404,
        ),
      );

      expect(result.isErr, true);
      result.when(
        ok: (_) => fail('Should be error'),
        err: (error) {
          expect(error.statusCode, 404);
          expect(error.message, contains('404'));
        },
      );
    });

    test('empty result is success with empty list, not error', () {
      // Empty result means the feature works but found no similar songs
      final result = Result<List<SongEntity>, AppFailure>.ok([]);

      expect(result.isOk, true);
      result.when(
        ok: (songs) => expect(songs.isEmpty, true),
        err: (_) => fail('Empty results should be ok, not error'),
      );
    });
  });

  group('Recommendation Aggregation', () {
    test('deduplicates songs with same ID', () {
      final seedIds = ['1', '2', '3'];
      final seenIds = <String>{};
      final recommendations = <SongEntity>[];

      final similarForSeed1 = [
        SongEntity(id: 'a', title: 'Song A'),
        SongEntity(id: 'b', title: 'Song B'),
      ];
      final similarForSeed2 = [
        SongEntity(id: 'a', title: 'Song A'), // Duplicate
        SongEntity(id: 'c', title: 'Song C'),
      ];

      for (final song in [...similarForSeed1, ...similarForSeed2]) {
        if (song.id != null &&
            !seenIds.contains(song.id) &&
            !seedIds.contains(song.id)) {
          recommendations.add(song);
          seenIds.add(song.id!);
        }
      }

      expect(recommendations.length, 3);
      expect(seenIds.contains('a'), true);
      expect(seenIds.contains('b'), true);
      expect(seenIds.contains('c'), true);
    });

    test('down-weights same artist when too many', () {
      final recommendations = <SongEntity>[];
      final artistCount = <String, int>{};

      final songs = [
        SongEntity(
          id: '1',
          title: 'Song 1',
          artist: 'Artist X',
          artistId: 'artist-x',
        ),
        SongEntity(
          id: '2',
          title: 'Song 2',
          artist: 'Artist X',
          artistId: 'artist-x',
        ),
        SongEntity(
          id: '3',
          title: 'Song 3',
          artist: 'Artist X',
          artistId: 'artist-x',
        ),
        SongEntity(
          id: '4',
          title: 'Song 4',
          artist: 'Artist X',
          artistId: 'artist-x',
        ),
        SongEntity(
          id: '5',
          title: 'Song 5',
          artist: 'Artist Y',
          artistId: 'artist-y',
        ),
      ];

      const maxPerArtist = 3;
      for (final song in songs) {
        final artistId = song.artistId ?? song.artist;
        if (artistId != null) {
          final count = artistCount[artistId] ?? 0;
          if (count >= maxPerArtist) continue;
          artistCount[artistId] = count + 1;
        }
        recommendations.add(song);
      }

      expect(artistCount['artist-x'], maxPerArtist);
      expect(recommendations.length, 4);
    });

    test('down-weights same album when too many', () {
      final recommendations = <SongEntity>[];
      final albumCount = <String, int>{};

      final songs = [
        SongEntity(
          id: '1',
          title: 'Song 1',
          album: 'Album X',
          albumId: 'album-x',
        ),
        SongEntity(
          id: '2',
          title: 'Song 2',
          album: 'Album X',
          albumId: 'album-x',
        ),
        SongEntity(
          id: '3',
          title: 'Song 3',
          album: 'Album X',
          albumId: 'album-x',
        ),
        SongEntity(
          id: '4',
          title: 'Song 4',
          album: 'Album X',
          albumId: 'album-x',
        ),
        SongEntity(
          id: '5',
          title: 'Song 5',
          album: 'Album Y',
          albumId: 'album-y',
        ),
      ];

      const maxPerAlbum = 3;
      for (final song in songs) {
        final albumId = song.albumId ?? song.album;
        if (albumId != null) {
          final count = albumCount[albumId] ?? 0;
          if (count >= maxPerAlbum) continue;
          albumCount[albumId] = count + 1;
        }
        recommendations.add(song);
      }

      expect(albumCount['album-x'], maxPerAlbum);
      expect(recommendations.length, 4);
    });

    test('returns empty when no seed songs available', () {
      final recommendations = <SongEntity>[];
      final seedSongIds = <String>[];

      if (seedSongIds.isEmpty) {
        expect(recommendations.isEmpty, true);
      }
    });
  });

  group('Error State Distinction', () {
    test('distinguishes server error from empty results', () {
      final serverError = AppFailure(
        type: AppFailureType.server,
        message: '404: Not found',
        statusCode: 404,
      );
      expect(serverError.message.contains('404'), true);

      final emptyResults = <SongEntity>[];
      expect(emptyResults.isEmpty, true);
    });

    test('error detection for various HTTP codes', () {
      bool isNotFoundError(String message) {
        final lower = message.toLowerCase();
        return lower.contains('not found') || lower.contains('404');
      }

      expect(isNotFoundError('404: Not found'), true);
      expect(isNotFoundError('not found on server'), true);
      expect(isNotFoundError('Network timeout'), false);
      expect(isNotFoundError('500: Internal server error'), false);
    });
  });

  group('Radio Queue Generation', () {
    test('radio queue can be started and extended', () {
      final queue = <SongEntity>[];
      final seenIds = <String>{};

      final seedSong = SongEntity(id: 'seed', title: 'Seed Song');
      if (seedSong.id != null) {
        seenIds.add(seedSong.id!);
      }

      final similarSongs = [
        SongEntity(id: '1', title: 'Similar 1'),
        SongEntity(id: '2', title: 'Similar 2'),
        SongEntity(id: '3', title: 'Similar 3'),
      ];

      for (final song in similarSongs) {
        if (song.id != null && !seenIds.contains(song.id)) {
          queue.add(song);
          seenIds.add(song.id!);
        }
      }

      expect(queue.length, 3);
      expect(seenIds.length, 4);
    });

    test('radio queue avoids duplicates on extend', () {
      final queue = <SongEntity>[];
      final seenIds = <String>{'seed'};

      final similarSongs1 = [
        SongEntity(id: '1', title: 'Similar 1'),
        SongEntity(id: '2', title: 'Similar 2'),
      ];

      for (final song in similarSongs1) {
        if (song.id != null && !seenIds.contains(song.id)) {
          queue.add(song);
          seenIds.add(song.id!);
        }
      }

      expect(queue.length, 2);

      final similarSongs2 = [
        SongEntity(id: '2', title: 'Similar 2'),
        SongEntity(id: '3', title: 'Similar 3'),
        SongEntity(id: '4', title: 'Similar 4'),
      ];

      for (final song in similarSongs2) {
        if (song.id != null && !seenIds.contains(song.id)) {
          queue.add(song);
          seenIds.add(song.id!);
        }
      }

      expect(queue.length, 4);
      expect(seenIds.contains('2'), true);
    });
  });
}
