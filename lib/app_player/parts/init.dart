part of '../player.dart';

extension PlayerInit on AppPlayer {
  void _init() async {
    _player.stream.completed.listen((_) => _updateCurrentMediaItemButton());
    _player.stream.rate.listen((_) => _updateCurrentMediaItemButton());
    _player.stream.shuffle.listen(_shuffleSubject.add);
    _player.stream.volume.listen(_volumeSubject.add);
    _player.stream.playlistMode.listen(_playlistModeSubject.add);
    _player.stream.duration.listen(_durationSubject.add);
    // _player.stream.buffer.listen((_) => _updateCurrentMediaItemButton());
    _positionSubscription = _player.stream.position.listen(_postionSubject.add);
    _player.stream.buffer.listen((duration) {
      _bufferedPositionSubject.add(duration);
      _updateCurrentMediaItemButton();
    });
    _player.stream.playing.listen((data) {
      _updateCurrentMediaItemButton();
      _playingSubject.add(data);
    });
    _player.stream.playlist.listen((e) {
      _playQueueSubject.add(
        PlayQueue(
          songs: e.medias
              .map((s) => s.extras?['song'] as SongEntity? ?? SongEntity())
              .toList(),
          index: e.index,
        ),
      );
      // 这里只监听队列不行，队列变了这个state.position没有变为0
      _updateCurrentMediaItemButton();
    });

    _player.stream.log.listen((data) {
      log('stream log -> $data');
    });
    _player.stream.error.listen(_errorSubject.add);

    final session = await AudioSession.instance;
    // 配置音频会话。这里我们声明这是一个音乐播放器。
    await session.configure(const AudioSessionConfiguration.music());
    _becomingNoisyEventSubscription = session.becomingNoisyEventStream.listen((
      _,
    ) {
      pause();
    });
    _interruptionEventSubscription = session.interruptionEventStream.listen(
      handleInterruptionEvent,
    );
  }

  void handleInterruptionEvent(AudioInterruptionEvent event) {
    if (event.begin) {
      switch (event.type) {
        case AudioInterruptionType.duck:
          // 无论如何，先取消掉可能存在的上一个超时定时器
          _duckingTimeout?.cancel();

          // 只在非 ducking 状态下才保存音量，防止状态被覆盖
          _volumeBeforeDucking ??= volume;

          _animateVolume(volume / 2);

          // 启动一个新的“看门狗”定时器
          _duckingTimeout = Timer(const Duration(seconds: 30), () {
            // 30秒后，如果还没收到结束事件，就主动恢复音量
            if (_volumeBeforeDucking != null) {
              final originalVolume = _volumeBeforeDucking!;
              _animateVolume(originalVolume).then((_) {
                if (_volumeBeforeDucking == originalVolume) {
                  _volumeBeforeDucking = null;
                }
              });
            }
          });
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
          // 收到了正常的结束事件，取消“看门狗”定时器
          _duckingTimeout?.cancel();

          if (_volumeBeforeDucking != null) {
            final originalVolume = _volumeBeforeDucking!;
            // 开始恢复动画，动画结束后再重置状态
            _animateVolume(originalVolume).then((_) {
              // 动画播放完毕后，才会执行这里的代码
              // 为防止在恢复期间又开始了新的ducking，再做一次检查
              if (_volumeBeforeDucking == originalVolume) {
                _volumeBeforeDucking = null;
              }
            });
          }
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
  }

  /// Animates the player volume to a [target] value.
  Future<void> _animateVolume(double target) {
    final completer = Completer<void>();

    // 如果有正在进行的动画，先取消掉
    _volumeAnimationTimer?.cancel();

    final double startVolume = volume; // 获取当前音量
    const Duration animationDuration = Duration(milliseconds: 300); // 动画总时长
    const int steps = 20; // 动画步数，越多越平滑

    // 如果目标音量和当前音量几乎没差别，就不用动画了
    if ((target - startVolume).abs() < 0.01) {
      setVolume(target);
      completer.complete();
      return completer.future;
    }

    final double stepValue = (target - startVolume) / steps; // 每一步的音量变化量
    final Duration stepDuration = animationDuration ~/ steps; // 每一步的间隔时间

    int currentStep = 0;
    _volumeAnimationTimer = Timer.periodic(stepDuration, (timer) {
      currentStep++;
      if (currentStep >= steps) {
        // 动画结束，确保音量精确到目标值并取消定时器
        setVolume(target);
        timer.cancel();
        completer.complete(); // **动画完成，通知 Future**
      } else {
        // 在动画过程中，逐步改变音量
        setVolume(startVolume + stepValue * currentStep);
      }
    });

    return completer.future;
  }
}
