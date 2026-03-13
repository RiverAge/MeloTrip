import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_logic/runtime/desktop_lyrics_runtime.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/app_logic/runtime/player_media_resolver_runtime.dart';
import 'package:melo_trip/app_logic/runtime/player_playlist_mode_runtime.dart';
import 'package:melo_trip/app_logic/runtime/player_scrobble_runtime.dart';
import 'package:melo_trip/provider/app_error/app_error.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';

class AppRuntimeCoordinatorBindings {
  AppRuntimeCoordinatorBindings({
    this.playlistModeSubscription,
    this.errorSubscription,
    this.desktopLyricsBindings,
    this.playerScrobbleBindings,
  });

  final StreamSubscription<dynamic>? playlistModeSubscription;
  final StreamSubscription<dynamic>? errorSubscription;
  final DesktopLyricsRuntimeBindings? desktopLyricsBindings;
  final PlayerScrobbleRuntimeBindings? playerScrobbleBindings;

  Future<void> cancel() async {
    await playlistModeSubscription?.cancel();
    await errorSubscription?.cancel();
    await playerScrobbleBindings?.cancel();
    await desktopLyricsBindings?.cancel();
  }
}

/// Starts long-lived runtime side effects after app startup has completed.
class AppRuntimeCoordinator {
  Future<AppRuntimeCoordinatorBindings> start(WidgetRef ref) async {
    // These bindings are runtime concerns, not bootstrap concerns. They stay
    // alive with the app shell and are cancelled when the app widget disposes.
    await ref.read(playerMediaResolverRuntimeProvider).attach(ref);

    final playlistModeSubscription = await ref
        .read(playerPlaylistModeRuntimeProvider)
        .attach(ref);
    final playerScrobbleBindings = await ref
        .read(playerScrobbleRuntimeProvider)
        .attach(ref);

    final AppPlayer? player = await ref.read(appPlayerHandlerProvider.future);
    final errorSubscription = player?.errorStream.listen(
      (err) => ref.read(appErrorProvider.notifier).emit(err),
    );

    DesktopLyricsRuntimeBindings? desktopLyricsBindings;
    final isDesktop =
        !kIsWeb &&
        (defaultTargetPlatform == .windows ||
            defaultTargetPlatform == .linux ||
            defaultTargetPlatform == .macOS);
    if (isDesktop) {
      desktopLyricsBindings = await ref
          .read(desktopLyricsRuntimeProvider)
          .attach(ref);
    }

    return AppRuntimeCoordinatorBindings(
      playlistModeSubscription: playlistModeSubscription,
      errorSubscription: errorSubscription,
      desktopLyricsBindings: desktopLyricsBindings,
      playerScrobbleBindings: playerScrobbleBindings,
    );
  }
}

final Provider<AppRuntimeCoordinator> appRuntimeCoordinatorProvider =
    Provider<AppRuntimeCoordinator>((_) {
      return AppRuntimeCoordinator();
    });
