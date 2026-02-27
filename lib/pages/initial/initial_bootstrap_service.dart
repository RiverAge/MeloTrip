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
    required this.loadPlayQueue,
    required this.resolveCachePath,
    required this.startCacheServer,
    required this.restorePlaylist,
    required this.restorePlaylistMode,
    this.bootstrapTimeout = const Duration(seconds: 8),
  });

  final Future<AuthUser?> Function() loadAuthUser;
  final Future<Configuration?> Function() loadConfig;
  final Future<PlayQueueEntity?> Function() loadPlayQueue;
  final Future<String> Function() resolveCachePath;
  final void Function(String dirPath, String host) startCacheServer;
  final Future<void> Function({
    required List<SongEntity> songs,
    String? initialId,
  })
  restorePlaylist;
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
    final playQueue = await loadPlayQueue();
    await restorePlaylist(
      songs: playQueue?.entry ?? const <SongEntity>[],
      initialId: playQueue?.current,
    );

    final playlistMode = config?.playlistMode;
    if (playlistMode != null) {
      await restorePlaylistMode(playlistMode);
    }

    return .loggedIn;
  }
}

final initialBootstrapServiceProvider = Provider<InitialBootstrapService>((ref) {
  Future<PlayQueueEntity?> loadPlayQueue() async {
    final api = await ref.read(apiProvider.future);
    final res = await api.get<Map<String, dynamic>>('/rest/getPlayQueue');
    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data).subsonicResponse?.playQueue;
  }

  final playerFuture = ref.read(appPlayerHandlerProvider.future);

  return InitialBootstrapService(
    loadAuthUser: () => ref.read(currentUserProvider.future),
    loadConfig: () => ref.read(userConfigProvider.future),
    loadPlayQueue: loadPlayQueue,
    resolveCachePath: getCacheFilePath,
    startCacheServer: (dirPath, host) {
      Isolate.spawn(runHttpServer, {'dirPath': dirPath, 'host': host});
    },
    restorePlaylist: ({required songs, initialId}) async {
      final player = await playerFuture;
      if (player != null) {
        await player.setPlaylist(songs: songs, initialId: initialId);
      }
    },
    restorePlaylistMode: (mode) async {
      final player = await playerFuture;
      if (player != null) {
        await player.setPlaylistMode(mode);
      }
    },
  );
});

final initialBootstrapResultProvider = FutureProvider.autoDispose<
  InitialBootstrapResult
>((ref) {
  final service = ref.read(initialBootstrapServiceProvider);
  return service.bootstrap();
});
