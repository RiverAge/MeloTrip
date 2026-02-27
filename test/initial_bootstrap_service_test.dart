import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/model/response/play_queue/play_queue.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/initial/initial_bootstrap_service.dart';

void main() {
  test('bootstrap returns loggedOut when auth is missing', () async {
    var cacheServerStarted = false;
    var playlistRestored = false;
    var playlistModeRestored = false;

    final service = InitialBootstrapService(
      loadAuthUser: () async => null,
      loadConfig: () async => null,
      loadPlayQueue: () async => null,
      resolveCachePath: () async => 'unused',
      startCacheServer: (_, _) {
        cacheServerStarted = true;
      },
      restorePlaylist: ({required songs, initialId}) async {
        playlistRestored = true;
      },
      restorePlaylistMode: (_) async {
        playlistModeRestored = true;
      },
    );

    final result = await service.bootstrap();

    expect(result, InitialBootstrapResult.loggedOut);
    expect(cacheServerStarted, isFalse);
    expect(playlistRestored, isFalse);
    expect(playlistModeRestored, isFalse);
  });

  test('bootstrap restores queue and mode for logged in user', () async {
    var cacheServerStarted = false;
    String? startedDirPath;
    String? startedHost;
    List<SongEntity> restoredSongs = const [];
    String? restoredInitialId;
    PlaylistMode? restoredMode;

    final service = InitialBootstrapService(
      loadAuthUser: () async => const AuthUser(
        salt: 'salt',
        token: 'token',
        username: 'tester',
        host: 'https://example.com',
      ),
      loadConfig: () async => const Configuration(
        playlistMode: .loop,
      ),
      loadPlayQueue: () async => const PlayQueueEntity(
        current: 'song_1',
        entry: [SongEntity(id: 'song_1', title: 'Song 1')],
      ),
      resolveCachePath: () async => '/tmp/cache',
      startCacheServer: (dirPath, host) {
        cacheServerStarted = true;
        startedDirPath = dirPath;
        startedHost = host;
      },
      restorePlaylist: ({required songs, initialId}) async {
        restoredSongs = songs;
        restoredInitialId = initialId;
      },
      restorePlaylistMode: (mode) async {
        restoredMode = mode;
      },
    );

    final result = await service.bootstrap();

    expect(result, InitialBootstrapResult.loggedIn);
    expect(cacheServerStarted, isTrue);
    expect(startedDirPath, '/tmp/cache');
    expect(startedHost, 'https://example.com');
    expect(restoredSongs.length, 1);
    expect(restoredSongs.first.id, 'song_1');
    expect(restoredInitialId, 'song_1');
    expect(restoredMode, PlaylistMode.loop);
  });

  test('bootstrap returns loggedOut when startup throws', () async {
    final service = InitialBootstrapService(
      loadAuthUser: () async => throw StateError('boom'),
      loadConfig: () async => null,
      loadPlayQueue: () async => null,
      resolveCachePath: () async => 'unused',
      startCacheServer: (_, _) {},
      restorePlaylist: ({required songs, initialId}) async {},
      restorePlaylistMode: (_) async {},
    );

    final result = await service.bootstrap();
    expect(result, InitialBootstrapResult.loggedOut);
  });

  test('bootstrap returns loggedOut on timeout', () async {
    final service = InitialBootstrapService(
      loadAuthUser: () async {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return const AuthUser(
          salt: 'salt',
          token: 'token',
          host: 'https://example.com',
        );
      },
      loadConfig: () async => null,
      loadPlayQueue: () async => null,
      resolveCachePath: () async => '/tmp/cache',
      startCacheServer: (_, _) {},
      restorePlaylist: ({required songs, initialId}) async {},
      restorePlaylistMode: (_) async {},
      bootstrapTimeout: const Duration(milliseconds: 1),
    );

    final result = await service.bootstrap();
    expect(result, InitialBootstrapResult.loggedOut);
  });
}
