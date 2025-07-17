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
            _animateVolume(volume / 2);
            _playInterrupted = false;
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            if (playing) {
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
            _animateVolume(min(100.0, volume * 2));
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

  /// Animates the player volume to a [target] value.
  void _animateVolume(double target) {
    // 如果有正在进行的动画，先取消掉
    _volumeAnimationTimer?.cancel();

    final double startVolume = volume; // 获取当前音量
    const Duration animationDuration = Duration(milliseconds: 300); // 动画总时长
    const int steps = 20; // 动画步数，越多越平滑
    final double stepValue = (target - startVolume) / steps; // 每一步的音量变化量
    final Duration stepDuration = animationDuration ~/ steps; // 每一步的间隔时间

    // 如果目标音量和当前音量几乎没差别，就不用动画了
    if ((target - startVolume).abs() < 0.01) {
      setVolume(target);
      return;
    }

    int currentStep = 0;
    _volumeAnimationTimer = Timer.periodic(stepDuration, (timer) {
      currentStep++;
      if (currentStep >= steps) {
        // 动画结束，确保音量精确到目标值并取消定时器
        setVolume(target);
        timer.cancel();
      } else {
        // 在动画过程中，逐步改变音量
        setVolume(startVolume + stepValue * currentStep);
      }
    });
  }
}
