import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/model/response/play_queue/play_queue.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/login/login_page.dart';
import 'package:melo_trip/pages/tab/tab_page.dart';
import 'package:melo_trip/server/cache_server.dart';
import 'package:melo_trip/svc/app_player/player_handler.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:melo_trip/svc/user.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});

  @override
  State<StatefulWidget> createState() => _InitState();
}

class _InitState extends State<InitialPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<PlayQueueEntity?> _getPlayQueue() async {
    final res = await Http.get<Map<String, dynamic>>('/rest/getPlayQueue');
    final data = res?.data;
    if (data == null) return null;
    final playQueue =
        SubsonicResponse.fromJson(data).subsonicResponse?.playQueue;

    return playQueue;
  }

  _init() async {
    final navigator = Navigator.of(context);

    final user = await User.instance;
    final subsonicSalt = user.auth?.subsonicSalt;
    final subsonicToken = user.auth?.subsonicToken;
    final host = user.auth?.host;

    if (subsonicSalt != null && subsonicToken != null && host != null) {
      final dirPath = await getCacheFilePath();
      await Isolate.spawn(runHttpServer, {'dirPath': dirPath, 'host': host});

      final handler = await AppPlayerHandler.instance;
      final player = handler.player;

      final playQueue = await _getPlayQueue();
      final songs = playQueue?.entry;

      await player.setPlaylist(
        songs: songs ?? [],
        initialId: playQueue?.current,
      );

      navigator.pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, _, __) => const TabPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => false,
      );
    } else {
      navigator.pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, _, __) => const LoginPage(),
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
