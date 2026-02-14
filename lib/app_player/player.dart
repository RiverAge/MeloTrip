import 'dart:async';
import 'dart:developer';
// import 'dart:math' hide log;

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
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
  final _shuffleSubject = BehaviorSubject<bool>();
  final _playingSubject = BehaviorSubject<bool>.seeded(false);
  final _playlistModeSubject = BehaviorSubject<PlaylistMode>();
  final _volumeSubject = BehaviorSubject<double>.seeded(100.0);
  final _playQueueSubject = BehaviorSubject<PlayQueue>();
  final _errorSubject = BehaviorSubject<String>();

  StreamSubscription<Duration>? _positionSubscription;

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

  void setBackgroundMode(bool isBackground) {
    if (isBackground) {
      _positionSubscription?.cancel();
      _positionSubscription = null;
    } else {
      _positionSubscription ??= _player.stream.position.listen(
        _postionSubject.add,
      );
    }
  }

  bool _playInterrupted = false;
  Timer? _volumeAnimationTimer;
  double? _volumeBeforeDucking;
  Timer? _duckingTimeout;

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
  Future<void> seek(Duration position) async {
    await _player.seek(position);
    // 这里seek之后发现获取state下的duration还是之前的
    _updateCurrentMediaItemButton(position: position);
  }

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
    _shuffleSubject.close();
    _playQueueSubject.close();
    _errorSubject.close();

    _becomingNoisyEventSubscription?.cancel();
    _interruptionEventSubscription?.cancel();

    _positionSubscription?.cancel();

    _player.dispose();
  }
}
