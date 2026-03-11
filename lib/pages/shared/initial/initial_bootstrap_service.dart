import 'dart:isolate';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/play_queue/play_queue.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/server/cache_server.dart';

enum InitialBootstrapResult { loggedIn, loggedOut }

class InitialBootstrapService {
  InitialBootstrapService({
    required this.loadAuthUser,
    required this.loadConfig,
    required this.resolveCachePath,
    required this.startCacheServer,
    required this.restorePlaylistMode,
    this.bootstrapTimeout = const Duration(seconds: 8),
  });

  final Future<AuthUser?> Function() loadAuthUser;
  final Future<Configuration?> Function() loadConfig;
  final Future<String> Function() resolveCachePath;
  final void Function(String dirPath, String host) startCacheServer;
  final Future<void> Function(PlaylistMode mode) restorePlaylistMode;
  final Duration bootstrapTimeout;

  Future<InitialBootstrapResult> bootstrap() async {
    try {
      return await _bootstrapInternal().timeout(bootstrapTimeout);
    } on TimeoutException {
      return .loggedOut;
    } catch (_) {
      return .loggedOut;
    }
  }

  Future<InitialBootstrapResult> _bootstrapInternal() async {
    final authUser = await loadAuthUser();
    final salt = authUser?.salt;
    final token = authUser?.token;
    final host = authUser?.host;
    if (salt == null || token == null || host == null) {
      return .loggedOut;
    }

    final dirPath = await resolveCachePath();
    startCacheServer(dirPath, host);
    final config = await loadConfig();
    final playlistMode = config?.playlistMode;
    if (playlistMode != null) {
      await restorePlaylistMode(playlistMode);
    }

    return .loggedIn;
  }
}

final initialBootstrapServiceProvider = Provider<InitialBootstrapService>((
  ref,
) {
  Future<AppPlayer?>? playerFuture;
  Future<AppPlayer?> ensurePlayerFuture() {
    playerFuture ??= ref.read(appPlayerHandlerProvider.future);
    return playerFuture!;
  }

  return InitialBootstrapService(
    loadAuthUser: () => ref.read(currentUserProvider.future),
    loadConfig: () => ref.read(userConfigProvider.future),
    resolveCachePath: getCacheFilePath,
    startCacheServer: (dirPath, host) {
      Isolate.spawn(runHttpServer, {'dirPath': dirPath, 'host': host});
    },
    restorePlaylistMode: (mode) async {
      final player = await ensurePlayerFuture();
      if (player != null) {
        await player.setPlaylistMode(mode);
      }
    },
  );
});

final initialBootstrapResultProvider =
    FutureProvider.autoDispose<InitialBootstrapResult>((ref) {
      final service = ref.read(initialBootstrapServiceProvider);
      return service.bootstrap();
    });

String? _restoredPlayQueueUserKey;
Future<void>? _restorePlayQueueInFlight;

Future<void> ensurePlayQueueRestored(WidgetRef ref) async {
  final running = _restorePlayQueueInFlight;
  if (running != null) return running;

  final future = () async {
    try {
      final auth = await ref.read(currentUserProvider.future);
      final userKey = '${auth?.host}|${auth?.username}|${auth?.token}';
      if (_restoredPlayQueueUserKey == userKey) return;

      final api = await ref.read(apiProvider.future);
      final queue =
          (await fetchPlayQueueResponse(api))?.subsonicResponse?.playQueue;

      final player = await ref.read(appPlayerHandlerProvider.future);
      if (player == null) return;

      await player.setPlaylist(
        songs: queue?.entry ?? const <SongEntity>[],
        initialId: queue?.current,
      );
      _restoredPlayQueueUserKey = userKey;
    } catch (_) {
      // Keep tab rendering resilient when queue restore dependencies are missing.
    }
  }();

  _restorePlayQueueInFlight = future;
  await future.whenComplete(() {
    if (identical(_restorePlayQueueInFlight, future)) {
      _restorePlayQueueInFlight = null;
    }
  });
}

void resetPlayQueueRestoreStateForTest() {
  _restoredPlayQueueUserKey = null;
  _restorePlayQueueInFlight = null;
}
