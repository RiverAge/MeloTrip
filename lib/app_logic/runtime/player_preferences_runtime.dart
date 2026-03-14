import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';

class PlayerPreferencesRuntimeBindings {
  PlayerPreferencesRuntimeBindings({
    this.playlistModeSubscription,
    this.shuffleSubscription,
  });

  final StreamSubscription<PlaylistMode>? playlistModeSubscription;
  final StreamSubscription<bool>? shuffleSubscription;

  Future<void> cancel() async {
    await playlistModeSubscription?.cancel();
    await shuffleSubscription?.cancel();
  }
}

class PlayerPreferencesRuntime {
  Future<PlayerPreferencesRuntimeBindings> attach(WidgetRef ref) async {
    final AppPlayer? player = await ref.read(appPlayerHandlerProvider.future);
    final config = ref.read(userConfigProvider.notifier);

    final playlistModeSubscription = player?.playlistModeStream.listen((mode) {
      config.setConfiguration(playlistMode: ValueUpdater(mode));
    });

    final shuffleSubscription = player?.shuffleStream.listen((enabled) {
      config.setConfiguration(shuffle: ValueUpdater(enabled));
    });

    return PlayerPreferencesRuntimeBindings(
      playlistModeSubscription: playlistModeSubscription,
      shuffleSubscription: shuffleSubscription,
    );
  }
}

final Provider<PlayerPreferencesRuntime> playerPreferencesRuntimeProvider =
    Provider<PlayerPreferencesRuntime>((_) {
      return PlayerPreferencesRuntime();
    });
