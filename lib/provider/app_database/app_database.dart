import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'app_database.g.dart';

@riverpod
class AppDatabase extends _$AppDatabase {
  @override
  Future<Database> build() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'melo_trip.db');
    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
           CREATE TABLE play_history (
             song_id TEXT NOT NULL,
             play_count INTEGER NOT NULL DEFAULT 0,
             last_played INTEGER NOT NULL,
             is_completed TEXT NOT NULL DEFAULT 0,
             is_skipped TEXT NOT NULL DEFAULT 0,
             user_id TEXT NOT NULL,
             PRIMARY KEY (song_id, user_id)
           )
         ''');
        await db.execute('''
           CREATE TABLE smart_suggestion (
             song_id TEXT NOT NULL,
             meta TEXT,
             user_id TEXT NOT NULL,
             update_at INTEGER NOT NULL,
             PRIMARY KEY (song_id, user_id)
           )
         ''');
        await db.execute('''
           CREATE TABLE user_config (
             user_id TEXT PRIMARY KEY,
             max_rate TEXT DEFAULT 32,
             playlist_mode TEXT DEFAULT loop,
             locale TEXT,
             recent_searches TEXT,
             theme TEXT DEFAULT system,
             update_at INTEGER NOT NULL
           )
         ''');

        await db.execute('''
           CREATE TABLE current_user (
             id TEXT PRIMARY KEY,
             is_admin TEXT,
             name TEXT NOT NULL,
             subsonic_salt TEXT NOT NULL,
             subsonic_token TEXT NOT NULL,
             token TEXT NOT NULL,
             username TEXT NOT NULL,
             host TEXT NOT NULL,
             update_at INTEGER NOT NULL
           )
         ''');
      },
    );

    return db;
  }
}
