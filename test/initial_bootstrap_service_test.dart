import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/pages/shared/initial/initial_bootstrap_service.dart';

void main() {
  test('bootstrap returns loggedOut when auth is missing', () async {
    var cacheServerStarted = false;
    var playlistModeRestored = false;

    final service = InitialBootstrapService(
      loadAuthUser: () async => null,
      loadConfig: () async => null,
      resolveCachePath: () async => 'unused',
      startCacheServer: (_, _) {
        cacheServerStarted = true;
      },
      restorePlaylistMode: (_) async {
        playlistModeRestored = true;
      },
    );

    final result = await service.bootstrap();

    expect(result, InitialBootstrapResult.loggedOut);
    expect(cacheServerStarted, isFalse);
    expect(playlistModeRestored, isFalse);
  });

  test('bootstrap restores mode for logged in user', () async {
    var cacheServerStarted = false;
    String? startedDirPath;
    String? startedHost;
    PlaylistMode? restoredMode;

    final service = InitialBootstrapService(
      loadAuthUser: () async => const AuthUser(
        salt: 'salt',
        token: 'token',
        username: 'tester',
        host: 'https://example.com',
      ),
      loadConfig: () async => const Configuration(playlistMode: .loop),
      resolveCachePath: () async => '/tmp/cache',
      startCacheServer: (dirPath, host) {
        cacheServerStarted = true;
        startedDirPath = dirPath;
        startedHost = host;
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
    expect(restoredMode, PlaylistMode.loop);
  });

  test('bootstrap returns loggedOut when startup throws', () async {
    final service = InitialBootstrapService(
      loadAuthUser: () async => throw StateError('boom'),
      loadConfig: () async => null,
      resolveCachePath: () async => 'unused',
      startCacheServer: (_, _) {},
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
      resolveCachePath: () async => '/tmp/cache',
      startCacheServer: (_, _) {},
      restorePlaylistMode: (_) async {},
      bootstrapTimeout: const Duration(milliseconds: 1),
    );

    final result = await service.bootstrap();
    expect(result, InitialBootstrapResult.loggedOut);
  });
}
