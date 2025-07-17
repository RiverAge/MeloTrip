import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:rxdart/rxdart.dart';

part 'parts/init.dart';
part 'parts/queue.dart';
part 'parts/media_item.dart';
part 'parts/state.dart';
part 'parts/stream.dart';
part 'parts/controls.dart';

class AppPlayer extends BaseAudioHandler {
  final _player = Player();
  final BehaviorSubject<Duration> _postionSubject = BehaviorSubject<Duration>();
  final _durationSubject = BehaviorSubject<Duration>();
  final _bufferedPositionSubject = BehaviorSubject<Duration>();
  final _playingSubject = BehaviorSubject<bool>.seeded(false);
  final _playlistModeSubject = BehaviorSubject<PlaylistMode>();
  final _volumeSubject = BehaviorSubject<double>.seeded(100.0);
  final _playQueueSubject = BehaviorSubject<PlayQueue>.seeded(
    PlayQueue(songs: [], index: 0),
  );

  StreamSubscription<void>? _becomingNoisyEventSubscription;
  StreamSubscription<AudioInterruptionEvent>? _interruptionEventSubscription;

  AppPlayer._interal() {
    _init();
  }
  static final AppPlayer _instance = AppPlayer._interal();

  factory AppPlayer() {
    return _instance;
  }

  Future<Media> Function(SongEntity song)? _mediaResolver;

  void setMediaResolver(Future<Media> Function(SongEntity song) resolver) {
    _mediaResolver = resolver;
  }

  bool _playInterrupted = false;
  Timer? _volumeAnimationTimer;

  @override
  Future<void> play() async {
    final session = await AudioSession.instance;
    await session.setActive(true);
    _player.play();
  }

  @override
  Future<void> pause() async => _player.pause();
  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> skipToPrevious() async => _player.previous();
  @override
  Future<void> skipToNext() async => _player.next();
  @override
  Future<void> seek(Duration position) => _player.seek(position);
  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    _player.setShuffle(shuffleMode != AudioServiceShuffleMode.none);
  }

  @override
  Future<void> removeQueueItemAt(int index) async => _player.remove(index);

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    if (repeatMode == AudioServiceRepeatMode.all) {
      await _player.setPlaylistMode(PlaylistMode.loop);
    } else if (repeatMode == AudioServiceRepeatMode.none) {
      await _player.setPlaylistMode(PlaylistMode.none);
    } else if (repeatMode == AudioServiceRepeatMode.one) {
      await _player.setPlaylistMode(PlaylistMode.single);
    }
  }

  @override
  Future<void> skipToQueueItem(int index) => _player.jump(index);

  void dispose() {
    _postionSubject.close();
    _durationSubject.close();
    _bufferedPositionSubject.close();
    _playingSubject.close();
    _playlistModeSubject.close();
    _volumeSubject.close();
    _playQueueSubject.close();

    _becomingNoisyEventSubscription?.cancel();
    _interruptionEventSubscription?.cancel();

    _player.dispose();
  }
}
