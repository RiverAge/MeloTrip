import 'package:path/path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sqflite/sqflite.dart';

part 'app_database.g.dart';

@riverpod
class AppDatabase extends _$AppDatabase {
  final _createPlayHistorySql = '''
           CREATE TABLE play_history (
             song_id TEXT NOT NULL,
             play_count INTEGER NOT NULL DEFAULT 0,
             last_played INTEGER NOT NULL,
             is_completed TEXT NOT NULL DEFAULT 0,
             is_skipped TEXT NOT NULL DEFAULT 0,
             username TEXT NOT NULL,
             PRIMARY KEY (song_id, username)
           )
         ''';
  final _createUserConfigSql = '''
           CREATE TABLE user_config (
             username TEXT PRIMARY KEY,
             max_rate TEXT DEFAULT 32,
             playlist_mode TEXT DEFAULT loop,
             locale TEXT,
             recent_searches TEXT,
             theme TEXT DEFAULT system,
             update_at INTEGER NOT NULL
           )
         ''';
  final _createCurrentUserSql = '''
           CREATE TABLE current_user (
             salt TEXT NOT NULL,
             token TEXT NOT NULL,
             username TEXT PRIMARY KEY,
             host TEXT NOT NULL,
             update_at INTEGER NOT NULL
           )
         ''';
  @override
  Future<Database> build() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'melo_trip.db');
    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(_createPlayHistorySql);
        await db.execute(_createUserConfigSql);
        await db.execute(_createCurrentUserSql);
      },
    );

    return db;
  }
}
