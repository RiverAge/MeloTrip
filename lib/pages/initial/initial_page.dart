import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/model/response/play_queue/play_queue.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/login/login_page.dart';
import 'package:melo_trip/pages/tab/tab_page.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/server/cache_server.dart';

class InitialPage extends ConsumerStatefulWidget {
  const InitialPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InitState();
}

class _InitState extends ConsumerState<InitialPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<PlayQueueEntity?> _getPlayQueue() async {
    final api = await ref.read(apiProvider.future);
    final res = await api.get<Map<String, dynamic>>('/rest/getPlayQueue');
    final data = res.data;
    if (data == null) return null;
    final playQueue =
        SubsonicResponse.fromJson(data).subsonicResponse?.playQueue;

    return playQueue;
  }

  void _init() async {
    final navigator = Navigator.of(context);

    final player = await ref.read(appPlayerHandlerProvider.future);
    final authUser = await ref.read(currentUserProvider.future);

    // final user = await User.instance;
    final subsonicSalt = authUser?.subsonicSalt;
    final subsonicToken = authUser?.subsonicToken;
    final host = authUser?.host;

    if (subsonicSalt != null && subsonicToken != null && host != null) {
      final dirPath = await getCacheFilePath();
      await Isolate.spawn(runHttpServer, {'dirPath': dirPath, 'host': host});

      final config = await ref.read(userConfigProvider.future);
      final playQueue = await _getPlayQueue();
      final songs = playQueue?.entry;

      await player?.setPlaylist(
        songs: songs ?? [],
        initialId: playQueue?.current,
      );
      final playlistMode = config?.playlistMode;
      if (playlistMode != null) {
        await player?.setPlaylistMode(playlistMode);
      }

      navigator.pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, _, _) => const TabPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => false,
      );
      FlutterNativeSplash.remove();
    } else {
      FlutterNativeSplash.remove();
      navigator.pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, _, _) => const LoginPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}
