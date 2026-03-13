import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';

class PlayerPlaylistModeRuntime {
  Future<StreamSubscription<dynamic>?> attach(WidgetRef ref) async {
    final AppPlayer? player = await ref.read(appPlayerHandlerProvider.future);
    return player?.playlistModeStream.listen((mode) {
      final config = ref.read(userConfigProvider.notifier);
      config.setConfiguration(playlistMode: ValueUpdater(mode));
    });
  }
}

final Provider<PlayerPlaylistModeRuntime> playerPlaylistModeRuntimeProvider =
    Provider<PlayerPlaylistModeRuntime>((_) {
      return PlayerPlaylistModeRuntime();
    });
