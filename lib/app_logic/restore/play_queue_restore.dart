import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/play_queue/play_queue.dart';

typedef ApplyRestoredPlayQueue =
    Future<void> Function(
      AppPlayer player,
      List<SongEntity> songs,
      String? initialId,
    );

String? _restoredPlayQueueUserKey;
Future<void>? _restorePlayQueueInFlight;

/// Restores the persisted queue lazily when a tab shell becomes active.
///
/// This is intentionally separate from bootstrap because queue restoration
/// depends on tab-scoped player usage rather than initial navigation.
Future<void> ensurePlayQueueRestored(
  WidgetRef ref, {
  ApplyRestoredPlayQueue applyRestoredPlayQueue = _defaultApplyRestoredPlayQueue,
}) async {
  final running = _restorePlayQueueInFlight;
  if (running != null) {
    return running;
  }

  final future = () async {
    try {
      final auth = await ref.read(currentUserProvider.future);
      final userKey = '${auth?.host}|${auth?.username}|${auth?.token}';
      if (_restoredPlayQueueUserKey == userKey) {
        return;
      }

      final queue =
          (await ref.read(playQueueProvider.future))?.subsonicResponse?.playQueue;

      final AppPlayer? player = await ref.read(appPlayerHandlerProvider.future);
      if (player == null) {
        return;
      }

      await applyRestoredPlayQueue(
        player,
        queue?.entry ?? const <SongEntity>[],
        queue?.current,
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

Future<void> _defaultApplyRestoredPlayQueue(
  AppPlayer player,
  List<SongEntity> songs,
  String? initialId,
) {
  return player.setPlaylist(songs: songs, initialId: initialId);
}

void resetPlayQueueRestoreStateForTest() {
  _restoredPlayQueueUserKey = null;
  _restorePlayQueueInFlight = null;
}
