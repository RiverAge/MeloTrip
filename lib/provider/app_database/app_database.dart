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
             user_id TEXT NOT NULL,
             PRIMARY KEY (song_id, user_id)
           )
         ''';
  final _createSmartSuggestionSql = '''
           CREATE TABLE smart_suggestion (
             song_id TEXT NOT NULL,
             meta TEXT,
             user_id TEXT NOT NULL,
             update_at INTEGER NOT NULL,
             PRIMARY KEY (song_id, user_id)
           )
         ''';
  final _createUserConfigSql = '''
           CREATE TABLE user_config (
             user_id TEXT PRIMARY KEY,
             max_rate TEXT DEFAULT 32,
             playlist_mode TEXT DEFAULT loop,
             locale TEXT,
             recent_searches TEXT,
             theme TEXT DEFAULT system,
             ai_api_key TEXT, 
             ai_api_url TEXT, 
             ai_model TEXT, 
             update_at INTEGER NOT NULL
           )
         ''';
  final _createCurrentUserSql = '''
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
         ''';
  final _createAiChatConversationSql = '''
           CREATE TABLE ai_chat_conversation (
             id TEXT PRIMARY KEY,
             user_id TEXT NOT NULL,
             title TEXT,
             update_at INTEGER NOT NULL
           )
         ''';

  final _createAiChatMessageSql = '''
           CREATE TABLE ai_chat_message (
             id TEXT PRIMARY KEY,
             conversation_id TEXT NOT NULL, 
             role TEXT,
             content TEXT,
             reasoning_content TEXT,
             model TEXT,
             reasoning_duration INTEGER,
             total_duration INTEGER,
             is_streaming INTEGER,
             error TEXT,
             timestamp INTEGER,
             update_at INTEGER NOT NULL
           )
         ''';
  @override
  Future<Database> build() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'melo_trip.db');
    final db = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute(_createPlayHistorySql);
        await db.execute(_createSmartSuggestionSql);
        await db.execute(_createUserConfigSql);
        await db.execute(_createCurrentUserSql);

        await db.execute(_createAiChatConversationSql);
        await db.execute(_createAiChatMessageSql);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE user_config ADD COLUMN ai_api_key TEXT',
          );
          await db.execute(
            'ALTER TABLE user_config ADD COLUMN ai_api_url TEXT',
          );
          await db.execute('ALTER TABLE user_config ADD COLUMN ai_model TEXT');

          await db.execute(_createAiChatConversationSql);
          await db.execute(_createAiChatMessageSql);
        }
      },
    );

    return db;
  }
}
