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
    final auth = await ref.read(currentUserProvider.future);
    final userId = auth?.id;
    if (songId == null || userId == null) return;
    final api = await ref.read(apiProvider.future);
    final res = await api.get<Map<String, dynamic>>(
      '/rest/getSimilarSongs2',
      queryParameters: {'id': songId, 'count': 10},
    );
    final data = res.data;
    if (data == null) return;
    final similarSongs =
        SubsonicResponse.fromJson(data).subsonicResponse?.similarSongs2?.song;
    if (similarSongs == null || similarSongs.isEmpty) {
      return;
    }

    final db = await ref.read(appDatabaseProvider.future);

    final now = DateTime.now().millisecondsSinceEpoch;
    final batch = db.batch();
    for (final song in similarSongs) {
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
