import 'dart:isolate';
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/model/response/play_queue/play_queue.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
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

class PlayQueueBootstrapService {
  PlayQueueBootstrapService({
    required this.loadAuthUser,
    required this.loadPlayQueue,
    required this.ensurePlayer,
  });

  final Future<AuthUser?> Function() loadAuthUser;
  final Future<PlayQueueEntity?> Function() loadPlayQueue;
  final Future<AppPlayer?> Function() ensurePlayer;

  String? _restoredUserKey;
  Future<void>? _inFlight;

  Future<void> ensureRestored() {
    final running = _inFlight;
    if (running != null) return running;
    final future = _restoreInternal();
    _inFlight = future;
    return future.whenComplete(() {
      if (identical(_inFlight, future)) {
        _inFlight = null;
      }
    });
  }

  Future<void> _restoreInternal() async {
    try {
      final auth = await loadAuthUser();
      final userKey = '${auth?.host}|${auth?.username}|${auth?.token}';
      if (_restoredUserKey == userKey) return;

      final queue = await loadPlayQueue();
      final player = await ensurePlayer();
      if (player == null) return;

      await player.setPlaylist(
        songs: queue?.entry ?? const <SongEntity>[],
        initialId: queue?.current,
      );
      _restoredUserKey = userKey;
    } catch (_) {
      // Keep tab rendering resilient when queue restore dependencies are missing.
    }
  }
}

final playQueueBootstrapServiceProvider = Provider<PlayQueueBootstrapService>((
  ref,
) {
  Future<PlayQueueEntity?> loadPlayQueue() async {
    final api = await ref.read(apiProvider.future);
    final res = await api.get<Map<String, dynamic>>('/rest/getPlayQueue');
    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data).subsonicResponse?.playQueue;
  }

  Future<AppPlayer?> ensurePlayer() async {
    return ref.read(appPlayerHandlerProvider.future);
  }

  return PlayQueueBootstrapService(
    loadAuthUser: () => ref.read(currentUserProvider.future),
    loadPlayQueue: loadPlayQueue,
    ensurePlayer: ensurePlayer,
  );
});
