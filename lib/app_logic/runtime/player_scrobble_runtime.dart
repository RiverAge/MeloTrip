import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:rxdart/rxdart.dart';

class PlayerScrobbleRuntimeBindings {
  PlayerScrobbleRuntimeBindings({
    required this.subscription,
    required this.cancelTimer,
  });

  final StreamSubscription<dynamic> subscription;
  final void Function() cancelTimer;

  Future<void> cancel() async {
    cancelTimer();
    await subscription.cancel();
  }
}

class PlayerScrobbleRuntime {
  String? _lastProcessedId;
  double? _lastSongDuration;
  Duration _activeDuration = Duration.zero;
  DateTime? _lastStateChangeTime;
  bool _wasPlaying = false;

  Future<PlayerScrobbleRuntimeBindings?> attach(WidgetRef ref) async {
    final AppPlayer? player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) {
      return null;
    }

    Timer? nowPlayingTimer;

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
          final api = await ref.read(apiProvider.future);
          final now = DateTime.now();

          if (_lastStateChangeTime != null && _wasPlaying) {
            _activeDuration += now.difference(_lastStateChangeTime!);
          }

          if (_lastProcessedId != currentId) {
            if (_lastProcessedId != null && _lastSongDuration != null) {
              if (_activeDuration.inSeconds >= 30 &&
                  _activeDuration.inSeconds >= _lastSongDuration! * 0.9) {
                unawaited(
                  api.get(
                    '/rest/scrobble',
                    queryParameters: {
                      'id': _lastProcessedId,
                      'time': now.millisecondsSinceEpoch,
                      'submission': true,
                    },
                  ),
                );
              }
            }

            _lastProcessedId = currentId;
            _lastSongDuration = currentSong.duration?.toDouble();
            _activeDuration = Duration.zero;
            nowPlayingTimer?.cancel();
            _savePlayQueue(player, api);
          }

          _lastStateChangeTime = now;
          _wasPlaying = playing;

          if (playing) {
            if (nowPlayingTimer == null || !nowPlayingTimer!.isActive) {
              nowPlayingTimer = Timer(const Duration(seconds: 10), () {
                if (player.playing && _lastProcessedId != null) {
                  unawaited(
                    api.get(
                      '/rest/scrobble',
                      queryParameters: {
                        'id': _lastProcessedId,
                        'submission': false,
                      },
                    ),
                  );
                }
              });
            }
          } else {
            nowPlayingTimer?.cancel();
          }
        });

    return PlayerScrobbleRuntimeBindings(
      subscription: subscription,
      cancelTimer: () => nowPlayingTimer?.cancel(),
    );
  }

  void _savePlayQueue(AppPlayer player, dynamic api) {
    final playQueue = player.playQueue;
    if (playQueue.index >= playQueue.songs.length) {
      unawaited(api.get('/rest/savePlayQueue'));
      return;
    }

    final currentSong = playQueue.songs[playQueue.index];
    final ids = playQueue.songs.map((e) => 'id=${e.id}').join('&');
    unawaited(api.get('/rest/savePlayQueue?$ids&current=${currentSong.id}'));
  }
}

final Provider<PlayerScrobbleRuntime> playerScrobbleRuntimeProvider =
    Provider<PlayerScrobbleRuntime>((_) {
      return PlayerScrobbleRuntime();
    });
