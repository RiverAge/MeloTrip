import 'package:path/path.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/persistence/app_persistence.dart';
import 'package:sqflite/sqflite.dart';

class SqliteAppPersistence implements AppPersistence {
  SqliteAppPersistence._(this._database);

  static const String _createPlayHistorySql = '''
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
  static const String _createUserConfigSql = '''
           CREATE TABLE user_config (
             username TEXT PRIMARY KEY,
             max_rate TEXT DEFAULT 32,
             playlist_mode TEXT DEFAULT loop,
             locale TEXT,
             recent_searches TEXT,
             desktop_lyrics_config TEXT,
             theme TEXT DEFAULT system,
             update_at INTEGER NOT NULL
           )
         ''';
  static const String _createCurrentUserSql = '''
           CREATE TABLE current_user (
             salt TEXT NOT NULL,
             token TEXT NOT NULL,
             username TEXT PRIMARY KEY,
             host TEXT NOT NULL,
             update_at INTEGER NOT NULL
           )
         ''';

  final Database _database;

  static Future<SqliteAppPersistence> open() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'melo_trip.db');
    final database = await openDatabase(
      path,
      version: 2,
      onCreate: (Database db, int version) async {
        await db.execute(_createPlayHistorySql);
        await db.execute(_createUserConfigSql);
        await db.execute(_createCurrentUserSql);
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE user_config ADD COLUMN desktop_lyrics_config TEXT',
          );
        }
      },
    );
    return SqliteAppPersistence._(database);
  }

  @override
  Future<AuthUser?> loadCurrentUser() async {
    return _database.transaction<AuthUser?>((tnx) async {
      final rows = await tnx.query('current_user', orderBy: 'update_at DESC');
      if (rows.isEmpty) {
        return null;
      }
      return AuthUser.fromJson(Map<String, dynamic>.from(rows.first));
    });
  }

  @override
  Future<void> saveCurrentUser(AuthUser user) {
    return _database.transaction<void>((tnx) async {
      await tnx.insert('current_user', {
        'salt': user.salt,
        'token': user.token,
        'username': user.username,
        'host': user.host,
        'update_at': DateTime.now().millisecondsSinceEpoch,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  @override
  Future<void> clearCurrentUser() {
    return _database.transaction<void>((tnx) async {
      await tnx.delete('current_user', where: '1=1');
    });
  }

  @override
  Future<Configuration?> loadUserConfig(String username) async {
    return _database.transaction<Configuration?>((tnx) async {
      final rows = await tnx.query(
        'user_config',
        where: 'username = ?',
        whereArgs: [username],
      );
      if (rows.isEmpty) {
        return null;
      }
      return Configuration.fromJson(Map<String, dynamic>.from(rows.first));
    });
  }

  @override
  Future<void> saveUserConfig(Configuration configuration) {
    final data = configuration.toJson()
      ..['update_at'] = DateTime.now().millisecondsSinceEpoch;
    return _database.transaction<void>((tnx) async {
      await tnx.insert(
        'user_config',
        data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  @override
  Future<void> close() {
    return _database.close();
  }
}
