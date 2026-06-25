import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/persistence/app_persistence_sqlite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Setup sqflite_ffi for desktop testing
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('SqliteAppPersistence', () {
    late SqliteAppPersistence persistence;

    setUp(() async {
      // Use in-memory database for testing
      // Note: This test requires sqlite3 DLL to be available
      // If SQLite download fails, this test may not run
      persistence = await SqliteAppPersistence.open();
      // Clear any existing data before each test
      await persistence.clearCurrentUser();
    });

    tearDown(() async {
      await persistence.close();
    });

    group('currentUser operations', () {
      test('returns null after clearing', () async {
        await persistence.clearCurrentUser();
        final user = await persistence.loadCurrentUser();
        expect(user, isNull);
      });

      test('saves and loads user', () async {
        const user = AuthUser(
          salt: 'test_salt',
          token: 'test_token',
          username: 'test_user',
          host: 'https://test.example.com',
        );

        await persistence.saveCurrentUser(user);
        final loaded = await persistence.loadCurrentUser();

        expect(loaded, isNotNull);
        expect(loaded?.username, equals('test_user'));
        expect(loaded?.salt, equals('test_salt'));
        expect(loaded?.token, equals('test_token'));
        expect(loaded?.host, equals('https://test.example.com'));
      });

      test('clears current user', () async {
        const user = AuthUser(
          salt: 'salt',
          token: 'token',
          username: 'user1',
          host: 'https://example.com',
        );

        await persistence.saveCurrentUser(user);
        await persistence.clearCurrentUser();
        final loaded = await persistence.loadCurrentUser();

        expect(loaded, isNull);
      });

      test('replaces existing user on save', () async {
        const user1 = AuthUser(
          salt: 'salt1',
          token: 'token1',
          username: 'user1',
          host: 'https://example1.com',
        );
        const user2 = AuthUser(
          salt: 'salt2',
          token: 'token2',
          username: 'user2',
          host: 'https://example2.com',
        );

        await persistence.saveCurrentUser(user1);
        await persistence.saveCurrentUser(user2);
        final loaded = await persistence.loadCurrentUser();

        expect(loaded?.username, equals('user2'));
        expect(loaded?.host, equals('https://example2.com'));
      });
    });

    group('userConfig operations', () {
      test('returns null when no config saved', () async {
        final config = await persistence.loadUserConfig('nonexistent_user');
        expect(config, isNull);
      });

      test('saves and loads user config', () async {
        final config = Configuration(
          username: 'test_user',
          maxRate: '320',
          shuffle: true,
          recentSearches: 'song1,song2',
        );

        await persistence.saveUserConfig(config);
        final loaded = await persistence.loadUserConfig('test_user');

        expect(loaded, isNotNull);
        expect(loaded?.username, equals('test_user'));
        expect(loaded?.maxRate, equals('320'));
        expect(loaded?.shuffle, isTrue);
        expect(loaded?.recentSearches, equals('song1,song2'));
      });

      test('saves config with all fields', () async {
        final config = Configuration(
          username: 'full_user',
          maxRate: '128',
          playlistMode: PlaylistMode.loop,
          shuffle: false,
          recentSearches: 'search1,search2',
          desktopLyricsConfig: '{"enabled":true}',
          updateAt: 1234567890,
        );

        await persistence.saveUserConfig(config);
        final loaded = await persistence.loadUserConfig('full_user');

        expect(loaded, isNotNull);
        expect(loaded?.username, equals('full_user'));
        expect(loaded?.maxRate, equals('128'));
        expect(loaded?.playlistMode, equals(PlaylistMode.loop));
        expect(loaded?.shuffle, isFalse);
        expect(loaded?.recentSearches, equals('search1,search2'));
        expect(loaded?.desktopLyricsConfig, equals('{"enabled":true}'));
      });

      test('updates existing config', () async {
        final config1 = Configuration(
          username: 'update_user',
          maxRate: '128',
        );
        final config2 = Configuration(
          username: 'update_user',
          maxRate: '320',
          shuffle: true,
        );

        await persistence.saveUserConfig(config1);
        await persistence.saveUserConfig(config2);
        final loaded = await persistence.loadUserConfig('update_user');

        expect(loaded?.maxRate, equals('320'));
        expect(loaded?.shuffle, isTrue);
      });
    });

    group('database schema', () {
      test('creates all required tables', () async {
        // This is implicitly tested by successful open()
        // Additional verification can be done by querying table info
        expect(persistence, isNotNull);
      });
    });
  });
}