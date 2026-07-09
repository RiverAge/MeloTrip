import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/repository/playback/player_playback_repository.dart';
import 'package:rxdart/rxdart.dart';

/// Low-frequency keep-alive interval for an active playback session.
///
/// While playing, we periodically re-send `playing` + the current position so
/// the server's now-playing state stays fresh and the session TTL is renewed.
/// The server also estimates position from the last report, so this only needs
/// to be frequent enough to bound drift; 30s is a good traffic/accuracy trade.
const Duration _keepAliveInterval = Duration(seconds: 30);

class PlayerPlaybackReportRuntimeBindings {
  PlayerPlaybackReportRuntimeBindings({
    required this.queuePlayingSubscription,
    required this.keepAliveTimer,
  });

  final StreamSubscription<(PlayQueue, bool)> queuePlayingSubscription;
  final Timer? keepAliveTimer;

  Future<void> cancel() async {
    keepAliveTimer?.cancel();
    await queuePlayingSubscription.cancel();
  }
}

/// Reports playback events to the server via the OpenSubsonic
/// `reportPlayback` endpoint.
///
/// Unlike the legacy `scrobble` flow, the server owns scrobble submission:
/// it tracks a per-client `PlaybackSession` and auto-scrobbles when a track
/// crosses the threshold on `stopped`. This runtime therefore only reports
/// state transitions (start/pause/resume/stop) and the current position,
/// derived from the real player position rather than a wall-clock estimate.
class PlayerPlaybackReportRuntime {
  String? _lastReportedId;

  Future<PlayerPlaybackReportRuntimeBindings?> attach(WidgetRef ref) async {
    final AppPlayer? player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) {
      return null;
    }
    final repository = ref.read(playerPlaybackRepositoryProvider);

    Timer? keepAliveTimer;

    final subscription =
        CombineLatestStream.combine2(
          player.playQueueStream,
          player.playingStream,
          (queue, playing) => (queue, playing),
        ).listen((data) async {
          final queue = data.$1;
          final playing = data.$2;

          if (queue.songs.isEmpty) {
            return;
          }

          final currentSong = queue.songs[queue.index];
          final currentId = currentSong.id;
          if (currentId == null || currentId.isEmpty) {
            return;
          }

          if (_lastReportedId != currentId) {
            // Song changed: close the previous session and open a new one.
            // The server decides whether the previous track scrobbles based on
            // the reported position, so we don't compute thresholds here.
            if (_lastReportedId != null) {
              unawaited(
                repository.tryReportPlayback(
                  mediaId: _lastReportedId!,
                  positionMs: player.position.inMilliseconds,
                  state: PlaybackState.stopped,
                ),
              );
            }

            _lastReportedId = currentId;
            unawaited(
              repository.tryReportPlayback(
                mediaId: currentId,
                positionMs: 0,
                state: PlaybackState.starting,
              ),
            );
            _savePlayQueue(player, repository);

            if (playing) {
              unawaited(
                repository.tryReportPlayback(
                  mediaId: currentId,
                  positionMs: player.position.inMilliseconds,
                  state: PlaybackState.playing,
                ),
              );
            }
          } else {
            // Same song: surface play/pause transitions.
            unawaited(
              repository.tryReportPlayback(
                mediaId: currentId,
                positionMs: player.position.inMilliseconds,
                state: playing ? PlaybackState.playing : PlaybackState.paused,
              ),
            );
          }

          keepAliveTimer?.cancel();
          if (playing) {
            keepAliveTimer = Timer.periodic(_keepAliveInterval, (_) {
              if (!player.playing || _lastReportedId == null) {
                return;
              }
              unawaited(
                repository.tryReportPlayback(
                  mediaId: _lastReportedId!,
                  positionMs: player.position.inMilliseconds,
                  state: PlaybackState.playing,
                ),
              );
            });
          }
        });

    return PlayerPlaybackReportRuntimeBindings(
      queuePlayingSubscription: subscription,
      keepAliveTimer: keepAliveTimer,
    );
  }

  void _savePlayQueue(
    AppPlayer player,
    PlayerPlaybackRepository repository,
  ) {
    final playQueue = player.playQueue;
    if (playQueue.index >= playQueue.songs.length) {
      unawaited(repository.trySavePlayQueue(songIds: const <String>[]));
      return;
    }

    final songIds =
        playQueue.songs
            .map((song) => song.id)
            .whereType<String>()
            .where((id) => id.isNotEmpty)
            .toList(growable: false);
    final currentSong = playQueue.songs[playQueue.index];
    unawaited(
      repository.trySavePlayQueue(
        songIds: songIds,
        currentSongId: currentSong.id,
      ),
    );
  }
}

final Provider<PlayerPlaybackReportRuntime>
playerPlaybackReportRuntimeProvider = Provider<PlayerPlaybackReportRuntime>((_) {
  return PlayerPlaybackReportRuntime();
});
