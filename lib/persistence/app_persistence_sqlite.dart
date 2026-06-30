import 'package:path/path.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/persistence/app_persistence.dart';
import 'package:sqflite/sqflite.dart';

class SqliteAppPersistence implements AppPersistence {
  SqliteAppPersistence._(this._database);

  static const String _createUserConfigSql = '''
           CREATE TABLE user_config (
             username TEXT PRIMARY KEY,
             max_rate TEXT,
             playlist_mode TEXT,
             shuffle INTEGER,
             locale TEXT,
             recent_searches TEXT,
             desktop_lyrics_config TEXT,
             recommend_refresh_state TEXT,
             theme TEXT,
             theme_seed TEXT,
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
      version: 5,
      onCreate: (Database db, int version) async {
        await db.execute(_createUserConfigSql);
        await db.execute(_createCurrentUserSql);
        // Note: server_capability table removed - Sonic API is always available on Navidrome 0.61+
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        // User config migrations
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE user_config ADD COLUMN desktop_lyrics_config TEXT',
          );
          await db.execute(
            'ALTER TABLE user_config ADD COLUMN shuffle INTEGER DEFAULT 0',
          );
        }

        // Drop deprecated server_capability table if it exists (cleanup from older versions)
        if (oldVersion < 5) {
          await db.execute('DROP TABLE IF EXISTS server_capability');
          // Drop deprecated play_history table (never read/written, replaced by
          // server-side scrobble + recommend_refresh_state in user_config).
          await db.execute('DROP TABLE IF EXISTS play_history');
        }
      },
    );
    await _ensureUserConfigSchema(database);
    return SqliteAppPersistence._(database);
  }

  static Future<void> _ensureUserConfigSchema(Database db) async {
    final columns = await db.rawQuery('PRAGMA table_info(user_config)');
    final hasThemeSeed = columns.any((row) => row['name'] == 'theme_seed');
    if (!hasThemeSeed) {
      await db.execute('ALTER TABLE user_config ADD COLUMN theme_seed TEXT');
    }
    final hasRecommendRefresh = columns.any(
      (row) => row['name'] == 'recommend_refresh_state',
    );
    if (!hasRecommendRefresh) {
      await db.execute(
        'ALTER TABLE user_config ADD COLUMN recommend_refresh_state TEXT',
      );
    }
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
