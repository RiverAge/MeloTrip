import 'dart:convert';

import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app_database/app_database.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sql.dart';
part 'smart_suggestion.g.dart';

@riverpod
class SmartSuggestion extends _$SmartSuggestion {
  @override
  Future<List<SongEntity>?> build() async {
    final auth = await ref.read(currentUserProvider.future);
    final db = await ref.read(appDatabaseProvider.future);
    final userId = auth?.id;

    if (userId == null) {
      return null;
    }

    final List<Map<String, Object?>> result = await db.rawQuery(
      '''
          SELECT
            ss.*
          FROM
            smart_suggestion AS ss
          LEFT JOIN
            play_history AS ph
          ON
            ss.song_id = ph.song_id AND ss.user_id = ph.user_id
          WHERE
            ss.user_id = ?
            AND (ph.is_skipped IS NULL OR ph.is_skipped != 1)
          ORDER BY
            ss.update_at DESC
          LIMIT 100
        ''',
      [userId],
    ); //
    if (result.isEmpty) return null;
    final suggestionSongs = result.toList().map(
      (e) => SongEntity.fromJson(jsonDecode(e['meta'] as String)),
    );
    return suggestionSongs.toList();
  }

  Future<void> playHistory({
    required SongEntity song,
    bool? isComplted,
    bool? isSkipped,
  }) async {
    final auth = await ref.read(currentUserProvider.future);
    final db = await ref.read(appDatabaseProvider.future);
    final songId = song.id;
    final userId = auth?.id;

    if (songId != null && userId != null) {
      await db.transaction((tnx) async {
        final existing = await tnx.query(
          'play_history',
          where: 'song_id = ? AND user_id = ?',
          whereArgs: [songId, userId],
        );
        final now = DateTime.now().millisecondsSinceEpoch;
        if (existing.isEmpty) {
          await tnx.insert('play_history', {
            'song_id': songId,
            'user_id': userId,
            'is_completed': isComplted == true ? '1' : '0',
            'is_skipped': isSkipped == true ? '1' : '0',
            'play_count': 1,
            'last_played': now,
          });
        } else {
          final currentCount = (existing.first['play_count'] as int?) ?? 0;
          await tnx.update(
            'play_history',
            {
              'play_count': currentCount + 1,
              'is_completed': isComplted == true ? '1' : '0',
              'is_skipped': isSkipped == true ? '1' : '0',
              'last_played': now,
            },
            where: 'song_id = ? AND user_id = ?',
            whereArgs: [songId, userId],
          );
        }
      });

      if (isComplted == true) {
        similarSongs(song);
      }
    }
    return;
  }

  Future<void> similarSongs(SongEntity song) async {
    final songId = song.id;
    final albumId = song.albumId;
    final genre = song.genre;
    final artist = song.artist;

    final auth = await ref.read(currentUserProvider.future);
    final userId = auth?.id;
    if (songId == null || userId == null) return;
    final api = await ref.read(apiProvider.future);

    // 2. Fetch from 3 sources in parallel
    final futures = [
      // Source 1: Similar songs (5)
      api.get<Map<String, dynamic>>(
        '/rest/getSimilarSongs2',
        queryParameters: {'id': songId, 'count': 5},
      ),
      // Source 2: Same album songs (2)
      if (albumId != null)
        api.get<Map<String, dynamic>>(
          '/rest/getAlbum',
          queryParameters: {'id': albumId},
        ),
      // Source 3: Same genre, different artist (3)
      if (genre != null)
        api.get<Map<String, dynamic>>(
          '/rest/getSongsByGenre',
          queryParameters: {'genre': genre, 'count': 20},
        ),
    ];

    final results = await Future.wait(futures);

    final allSongs = <SongEntity>{};

    // Process results
    final similarSongsResData = results[0].data;
    if (similarSongsResData != null) {
      allSongs.addAll(
        SubsonicResponse.fromJson(
              similarSongsResData,
            ).subsonicResponse?.similarSongs2?.song ??
            [],
      );
    }

    if (results.length >= 2) {
      final albumSongsResData = results[1].data;
      if (albumSongsResData != null) {
        final items =
            SubsonicResponse.fromJson(albumSongsResData)
                .subsonicResponse
                ?.album
                ?.song
                ?.where((s) => s.id != songId)
                .toList() ??
            [];
        items.shuffle();
        allSongs.addAll(items.take(2));
      }
    }

    if (results.length >= 3) {
      final genreSongsResData = results[2].data;
      if (genreSongsResData != null) {
        final items =
            SubsonicResponse.fromJson(genreSongsResData)
                .subsonicResponse
                ?.songsByGenre
                ?.song
                ?.where((s) => s.artist != artist)
                .toList() ??
            [];

        items.shuffle();
        allSongs.addAll(items.take(3));
      }
    }

    final finalSongs = allSongs.toList()..shuffle();
    if (finalSongs.isEmpty) {
      return;
    }

    final db = await ref.read(appDatabaseProvider.future);

    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = db.batch();
    for (final song in finalSongs) {
      batch.insert('smart_suggestion', {
        'song_id': song.id,
        'meta': jsonEncode(song.toJson()),
        'update_at': now,
        'user_id': userId,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
    ref.invalidateSelf();
  }
}
