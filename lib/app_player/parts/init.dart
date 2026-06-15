part of '../player.dart';

extension PlayerInit on AppPlayer {
  void _init() async {
    _player.stream.completed.listen((_) => _updateCurrentMediaItemButton());
    _player.stream.rate.listen((_) => _updateCurrentMediaItemButton());
    _player.stream.shuffle.listen(_shuffleSubject.add);
    _player.stream.volume.listen(_volumeSubject.add);
    _player.stream.playlistMode.listen(_playlistModeSubject.add);
    _player.stream.duration.listen(_durationSubject.add);

    _positionSubscription = _player.stream.position.listen(
      _positionSubject.add,
    );

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
        songs: playlist.medias.map(readMediaSong).toList(),
        index: playlist.index,
      );
      final currentMedia = (playlist.index >= 0 &&
              playlist.index < playlist.medias.length)
          ? playlist.medias[playlist.index]
          : null;
      final artUri = currentMedia == null
          ? null
          : readMediaArtUri(currentMedia);
      _playQueueSubject.add(playQueue);
      _syncMediaItem(playQueue, artUri: artUri);
      _updateCurrentMediaItemButton();
    });

    _player.stream.log.listen((data) {
      log('stream log -> $data');
    });
    _player.stream.audioDevices.listen((devices) {
      final summary = devices
          .map((d) => '${d.name}(${d.description})')
          .join(', ');
      log('audio devices -> [$summary]');
    });
    _player.stream.audioDevice.listen((device) {
      log('audio device active -> ${device.name}(${device.description})');
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
      (event) {
        // Process event synchronously for state, enqueue side effects
        _handleInterruptionEvent(event);
      },
    );
  }

  /// Handles an interruption event.
  /// State is updated synchronously immediately.
  /// Side effects are enqueued to the serializer for ordered execution.
  void _handleInterruptionEvent(AudioInterruptionEvent event) {
    log(
      '[AppPlayer][Interruption] event begin=${event.begin} type=${event.type} '
      'playing=$playing volume=$volume ducking=${_duckVolumeState.duckingState} '
      'playbackState=$_playbackInterruptionState',
    );

    final decision = resolveInterruptionDecision(
      type: event.type,
      isBegin: event.begin,
      isPlaying: playing,
      playbackState: _playbackInterruptionState,
      duckingState: _duckVolumeState.duckingState,
    );

    log(
      '[AppPlayer][Interruption] decision beginDucking=${decision.beginDucking} '
      'endDucking=${decision.endDucking} endDuckingImmediately=${decision.endDuckingImmediately} '
      'pausePlayback=${decision.pausePlayback} '
      'resumePlayback=${decision.resumePlayback} '
      'nextDucking=${decision.nextDuckingState} '
      'nextPlayback=${decision.nextPlaybackState}',
    );

    // SYNCHRONOUS state updates - happen immediately before any side effects.
    // This ensures rapid consecutive events see correct state.
    _playbackInterruptionState = decision.nextPlaybackState;

    // SYNCHRONOUS duck state computation and update.
    final duckActions = _computeDuckActions(decision);

    // Enqueue side effects to serializer for ordered execution.
    // This ensures side effects from multiple events execute in order.
    // pause() and play() go through _commandSerializer, ensuring all player
    // operations are serialized through the same queue.
    _interruptionSerializer.run(() async {
      try {
        await _executeDuckActions(duckActions);

        if (decision.pausePlayback) {
          await pause();
        }
        if (decision.resumePlayback) {
          await play();
        }
      } catch (error, stackTrace) {
        log(
          '[AppPlayer][Interruption] error in side effect: $error\n$stackTrace',
        );
      }
    });
  }

  /// Computes duck actions and updates duck state synchronously.
  /// Returns actions that need async execution.
  List<_DuckAsyncAction> _computeDuckActions(InterruptionDecision decision) {
    final actions = <_DuckAsyncAction>[];

    if (decision.beginDucking) {
      final action = handleDuckingBegin(
        state: _duckVolumeState,
        currentVolume: volume,
      );
      _duckVolumeState = action.nextState;
      actions.add(_DuckAsyncAction.beginDuck(action));
    } else if (decision.endDucking) {
      final action = handleDuckingEnd(
        state: _duckVolumeState,
        currentVolume: volume,
      );
      _duckVolumeState = action.nextState;
      actions.add(_DuckAsyncAction.endDuck(action));
    } else if (decision.endDuckingImmediately) {
      final action = handleDuckingEndImmediately(
        state: _duckVolumeState,
        currentVolume: volume,
      );
      _duckVolumeState = action.nextState;
      actions.add(_DuckAsyncAction.endDuckImmediately(action));
    } else {
      // For non-duck events, update duckingState from decision if needed
      _duckVolumeState = _duckVolumeState.copyWith(
        duckingState: decision.nextDuckingState,
      );
    }

    return actions;
  }

  /// Executes async duck actions (volume animations, setVolume calls).
  Future<void> _executeDuckActions(List<_DuckAsyncAction> actions) async {
    for (final action in actions) {
      switch (action.type) {
        case _DuckActionType.beginDuck:
          await _executeDuckingBegin(action.duckAction!);
        case _DuckActionType.endDuck:
          await _executeDuckingEnd(action.duckAction!);
        case _DuckActionType.endDuckImmediately:
          await _executeDuckingEndImmediately(action.duckAction!);
      }
    }
  }

  /// Executes duck begin side effects (volume animation, timeout).
  Future<void> _executeDuckingBegin(DuckAction action) async {
    log(
      '[AppPlayer][Interruption] _executeDuckingBegin '
      'volumeBeforeDucking=${action.nextState.volumeBeforeDucking} '
      'targetVolume=${action.targetVolume}',
    );

    _duckingTimeout?.cancel();

    // Execute volume change (fire-and-forget animation, don't await)
    if (action.shouldAnimate) {
      _startVolumeAnimation(
        targetVolume: action.targetVolume,
        onComplete: () {
          log('[AppPlayer][Interruption] duck animation complete');
        },
      );
    } else {
      await setVolume(action.targetVolume);
    }

    // Set timeout for safety
    _duckingTimeout = Timer(const Duration(seconds: 30), () {
      if (_duckVolumeState.duckingState == DuckingState.ducking) {
        _startVolumeRestoreAnimation();
      }
    });
  }

  /// Executes duck end side effects (restore animation).
  /// Does NOT block the event handler - animation runs independently.
  Future<void> _executeDuckingEnd(DuckAction action) async {
    log(
      '[AppPlayer][Interruption] _executeDuckingEnd '
      'targetVolume=${action.targetVolume}',
    );

    _duckingTimeout?.cancel();

    if (action.nextState.duckingState == DuckingState.normal) {
      // No original volume recorded, nothing to restore
      return;
    }

    // Start restore animation (fire-and-forget, don't await)
    _startVolumeRestoreAnimation();
  }

  /// Executes immediate duck end side effects (synchronous volume restore).
  /// This MUST be awaited to ensure volume is restored before pause.
  Future<void> _executeDuckingEndImmediately(DuckAction action) async {
    log(
      '[AppPlayer][Interruption] _executeDuckingEndImmediately '
      'restoring volume to ${action.targetVolume}',
    );

    _duckingTimeout?.cancel();
    _cancelVolumeAnimation();

    // Execute volume change immediately (must await)
    await setVolume(action.targetVolume);
  }

  /// Starts volume restore animation (fire-and-forget).
  /// Animation completion will check state and clear volumeBeforeDucking.
  void _startVolumeRestoreAnimation() {
    final targetVolume = _duckVolumeState.volumeBeforeDucking;
    if (targetVolume == null) {
      return;
    }

    _startVolumeAnimation(
      targetVolume: targetVolume,
      onComplete: () {
        // Check if we should complete the restore
        // This runs asynchronously after animation completes
        final newState = handleRestoreComplete(state: _duckVolumeState);
        if (newState != _duckVolumeState) {
          _duckVolumeState = newState;
          log(
            '[AppPlayer][Interruption] restore animation complete, '
            'cleared volumeBeforeDucking, ducking=${_duckVolumeState.duckingState}',
          );
        } else {
          log(
            '[AppPlayer][Interruption] restore animation complete, '
            'skip clear (duckingState=${_duckVolumeState.duckingState})',
          );
        }
      },
    );
  }

  /// Starts a volume animation (fire-and-forget).
  /// Returns immediately; animation runs in background via timer.
  void _startVolumeAnimation({
    required double targetVolume,
    required void Function() onComplete,
  }) {
    // Cancel any existing animation
    _cancelVolumeAnimation();

    final startVolume = volume;
    const animationDuration = Duration(milliseconds: 300);
    const steps = 20;

    log(
      '[AppPlayer][Interruption] _startVolumeAnimation start '
      'startVolume=$startVolume targetVolume=$targetVolume',
    );

    if ((targetVolume - startVolume).abs() < 0.01) {
      log(
        '[AppPlayer][Interruption] _startVolumeAnimation diff<0.01, '
        'setVolume directly to $targetVolume',
      );
      setVolume(targetVolume);
      onComplete();
      return;
    }

    final stepValue = (targetVolume - startVolume) / steps;
    final stepDuration = animationDuration ~/ steps;

    var currentStep = 0;
    _volumeAnimationTimer = Timer.periodic(stepDuration, (timer) {
      currentStep++;
      if (currentStep >= steps) {
        setVolume(targetVolume);
        timer.cancel();
        log(
          '[AppPlayer][Interruption] _startVolumeAnimation done '
          'finalTarget=$targetVolume',
        );
        onComplete();
      } else {
        setVolume(startVolume + stepValue * currentStep);
      }
    });
  }

  /// Cancels any ongoing volume animation.
  void _cancelVolumeAnimation() {
    _volumeAnimationTimer?.cancel();
    _volumeAnimationTimer = null;
  }
}

/// Represents an async action to execute for duck handling.
enum _DuckActionType { beginDuck, endDuck, endDuckImmediately }

class _DuckAsyncAction {
  const _DuckAsyncAction.beginDuck(this.duckAction)
      : type = _DuckActionType.beginDuck;
  const _DuckAsyncAction.endDuck(this.duckAction)
      : type = _DuckActionType.endDuck;
  const _DuckAsyncAction.endDuckImmediately(this.duckAction)
      : type = _DuckActionType.endDuckImmediately;

  final _DuckActionType type;
  final DuckAction? duckAction;
}
