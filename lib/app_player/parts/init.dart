part of '../player.dart';

extension PlayerInit on AppPlayer {
  void _init() async {
    _player.stream.completed.listen((_) => _updateCurrentMediaItemButton());
    _player.stream.rate.listen((_) => _updateCurrentMediaItemButton());
    _player.stream.shuffle.listen(_shuffleSubject.add);
    _player.stream.volume.listen(_volumeSubject.add);
    _player.stream.playlistMode.listen(_playlistModeSubject.add);
    _player.stream.duration.listen(_durationSubject.add);

    _positionSubscription = _player.stream.position.listen(_positionSubject.add);

    _player.stream.buffer.listen((duration) {
      _bufferedPositionSubject.add(duration);
      _updateCurrentMediaItemButton();
    });

    _player.stream.playing.listen((data) {
      _updateCurrentMediaItemButton();
      _playingSubject.add(data);
    });

    _player.stream.playlist.listen((playlist) {
      final playQueue = PlayQueue(
        songs: playlist.medias
            .map((media) => media.extras?['song'] as SongEntity? ?? SongEntity())
            .toList(),
        index: playlist.index,
      );
      _playQueueSubject.add(playQueue);
      _syncMediaItem(playQueue);
      _updateCurrentMediaItemButton();
    });

    _player.stream.log.listen((data) {
      log('stream log -> $data');
    });
    _player.stream.error.listen(_errorSubject.add);

    final session = await AudioSession.instance;
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
    final decision = resolveInterruptionDecision(
      type: event.type,
      isBegin: event.begin,
      isPlaying: playing,
      playbackState: _playbackInterruptionState,
      duckingState: _duckingState,
    );

    if (decision.beginDucking) {
      _handleDuckingBegin();
    }
    if (decision.endDucking) {
      _handleDuckingEnd();
    }
    if (decision.pausePlayback) {
      pause();
    }
    if (decision.resumePlayback) {
      play();
    }

    _playbackInterruptionState = decision.nextPlaybackState;
    _duckingState = decision.nextDuckingState;
  }

  void _handleDuckingBegin() {
    _duckingTimeout?.cancel();
    if (_duckingState == .normal) {
      _volumeBeforeDucking = volume;
    }
    _duckingState = .ducking;
    _animateVolume(volume / 2);

    _duckingTimeout = Timer(const Duration(seconds: 30), () {
      if (_duckingState == DuckingState.ducking) {
        _restoreVolumeAfterDucking();
      }
    });
  }

  void _handleDuckingEnd() {
    _duckingTimeout?.cancel();
    _restoreVolumeAfterDucking();
  }

  void _restoreVolumeAfterDucking() {
    final originalVolume = _volumeBeforeDucking;
    if (originalVolume == null) {
      _duckingState = .normal;
      return;
    }
    _animateVolume(originalVolume).then((_) {
      if (_volumeBeforeDucking == originalVolume) {
        _volumeBeforeDucking = null;
        _duckingState = .normal;
      }
    });
  }

  Future<void> _animateVolume(double target) {
    final completer = Completer<void>();
    _volumeAnimationTimer?.cancel();

    final startVolume = volume;
    const animationDuration = Duration(milliseconds: 300);
    const steps = 20;

    if ((target - startVolume).abs() < 0.01) {
      setVolume(target);
      completer.complete();
      return completer.future;
    }

    final stepValue = (target - startVolume) / steps;
    final stepDuration = animationDuration ~/ steps;

    var currentStep = 0;
    _volumeAnimationTimer = Timer.periodic(stepDuration, (timer) {
      currentStep++;
      if (currentStep >= steps) {
        setVolume(target);
        timer.cancel();
        completer.complete();
      } else {
        setVolume(startVolume + stepValue * currentStep);
      }
    });

    return completer.future;
  }
}
