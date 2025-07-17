part of '../player.dart';

extension PlayerInit on AppPlayer {
  void _init() async {
    _player.stream.completed.listen((_) => _updateCurrentMediaItemButton());
    _player.stream.rate.listen((_) => _updateCurrentMediaItemButton());
    _player.stream.buffer.listen((_) => _updateCurrentMediaItemButton());
    // 光年之外的 pos 是负数
    _player.stream.position.listen((pos) {
      _postionSubject.add(pos.isNegative ? Duration.zero : pos);
    });
    _player.stream.duration.listen(_durationSubject.add);
    _player.stream.buffer.listen(_bufferedPositionSubject.add);
    _player.stream.playing.listen((data) {
      _updateCurrentMediaItemButton();
      _playingSubject.add(data);
    });
    _player.stream.playlistMode.listen((data) {
      _playlistModeSubject.add(data);
    });
    _player.stream.volume.listen(_volumeSubject.add);
    _player.stream.playlist.listen((e) {
      _playQueueSubject.add(
        PlayQueue(
          songs:
              e.medias
                  .map((s) => s.extras?['song'] as SongEntity? ?? SongEntity())
                  .toList(),
          index: e.index,
        ),
      );
    });

    final session = await AudioSession.instance;
    // 配置音频会话。这里我们声明这是一个音乐播放器。
    await session.configure(const AudioSessionConfiguration.music());
    _becomingNoisyEventSubscription = session.becomingNoisyEventStream.listen((
      _,
    ) {
      pause();
    });
    _interruptionEventSubscription = session.interruptionEventStream.listen((
      event,
    ) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            assert(!kIsWeb && Platform.isAndroid);
            if (session.androidAudioAttributes!.usage ==
                AndroidAudioUsage.game) {
              setVolume(_player.state.volume / 2);
            }
            _playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (_player.state.playing) {
              pause();
              // Although pause is async and sets _playInterrupted = false,
              // this is done in the sync portion.
              _playInterrupted = true;
            }
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            assert(!kIsWeb && Platform.isAndroid);
            setVolume(min(100.0, volume * 2));
            _playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
            if (_playInterrupted) play();
            _playInterrupted = false;
            break;
          case AudioInterruptionType.unknown:
            _playInterrupted = false;
            break;
        }
      }
    });
  }
}
