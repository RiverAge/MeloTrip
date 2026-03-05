import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/app_player/command_serializer.dart';
import 'package:melo_trip/app_player/interruption_state.dart';
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
  final BehaviorSubject<Duration> _positionSubject = BehaviorSubject<Duration>();
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

  AppPlayer._internal() {
    _init();
  }
  static final AppPlayer _instance = AppPlayer._internal();

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
        _positionSubject.add,
      );
    }
  }

  PlaybackInterruptionState _playbackInterruptionState =
      PlaybackInterruptionState.normal;
  DuckingState _duckingState = .normal;
  Timer? _volumeAnimationTimer;
  double? _volumeBeforeDucking;
  Timer? _duckingTimeout;
  final _commandSerializer = AppPlayerCommandSerializer();

  Future<T> _runSerialized<T>(Future<T> Function() action) {
    return _commandSerializer.run(action);
  }

  @override
  Future<void> play() {
    return _runSerialized(() async {
      final session = await AudioSession.instance;
      await session.setActive(true);
      await _player.play();
    });
  }

  @override
  Future<void> pause() => _runSerialized(() => _player.pause());

  @override
  Future<void> stop() => _runSerialized(() => _player.stop());

  @override
  Future<void> skipToPrevious() => _runSerialized(() => _player.previous());

  @override
  Future<void> skipToNext() => _runSerialized(() => _player.next());

  @override
  Future<void> seek(Duration position) {
    return _runSerialized(() async {
      await _player.seek(position);
      _updateCurrentMediaItemButton(position: position);
    });
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) {
    return _runSerialized(() => _player.setShuffle(shuffleMode != .none));
  }

  @override
  Future<void> removeQueueItemAt(int index) {
    return _runSerialized(() => _player.remove(index));
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) {
    return _runSerialized(() async {
      if (repeatMode == .all) {
        await _player.setPlaylistMode(PlaylistMode.loop);
      } else if (repeatMode == .none) {
        await _player.setPlaylistMode(PlaylistMode.none);
      } else if (repeatMode == .one) {
        await _player.setPlaylistMode(PlaylistMode.single);
      }
    });
  }

  @override
  Future<void> skipToQueueItem(int index) {
    return _runSerialized(() => _player.jump(index));
  }

  void dispose() {
    _positionSubject.close();
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
