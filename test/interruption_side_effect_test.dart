import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:audio_session/audio_session.dart';
import 'package:melo_trip/app_player/interruption_state.dart';
import 'package:melo_trip/app_player/duck_volume_state_machine.dart';
import 'package:melo_trip/app_player/interruption_side_effect_serializer.dart';

/// A testable interruption event processor that tracks side effect order
/// and uses fake async effects via Completers.
class TestableInterruptionProcessor {
  final InterruptionSideEffectSerializer _serializer =
      InterruptionSideEffectSerializer();

  PlaybackInterruptionState playbackState = PlaybackInterruptionState.normal;
  DuckVolumeState duckState = const DuckVolumeState(
    duckingState: DuckingState.normal,
    volumeBeforeDucking: null,
  );

  /// Recorded side effects in order of execution start.
  final List<String> sideEffects = [];

  /// Completers that can be used to control when side effects complete.
  final Map<String, Completer<void>> _completers = {};

  /// Creates a completer for a side effect that can be awaited.
  Completer<void> createCompleter(String name) {
    final completer = Completer<void>();
    _completers[name] = completer;
    return completer;
  }

  /// Completes a side effect by name.
  void completeSideEffect(String name) {
    _completers[name]?.complete();
    _completers.remove(name);
  }

  /// Whether a side effect has started (completer exists).
  bool hasStartedSideEffect(String name) {
    return _completers.containsKey(name);
  }

  /// Process an interruption event.
  /// State is updated synchronously, side effects are serialized.
  void processEvent({
    required AudioInterruptionType type,
    required bool isBegin,
    required bool isPlaying,
    double currentVolume = 100.0,
  }) {
    final decision = resolveInterruptionDecision(
      type: type,
      isBegin: isBegin,
      isPlaying: isPlaying,
      playbackState: playbackState,
      duckingState: duckState.duckingState,
    );

    // SYNCHRONOUS state update
    playbackState = decision.nextPlaybackState;

    // SYNCHRONOUS duck state computation
    final duckActions = _computeDuckActions(decision, currentVolume);

    // Enqueue side effects to serializer
    _serializer.run(() async {
      await _executeDuckActions(duckActions, currentVolume);

      if (decision.pausePlayback) {
        final completer = createCompleter('pause');
        sideEffects.add('pause');
        await completer.future;
      }
      if (decision.resumePlayback) {
        final completer = createCompleter('play');
        sideEffects.add('play');
        await completer.future;
      }
    });
  }

  List<_DuckAsyncAction> _computeDuckActions(
    InterruptionDecision decision,
    double currentVolume,
  ) {
    final actions = <_DuckAsyncAction>[];

    if (decision.beginDucking) {
      final action = handleDuckingBegin(
        state: duckState,
        currentVolume: currentVolume,
      );
      duckState = action.nextState;
      actions.add(_DuckAsyncAction.beginDuck(action));
    } else if (decision.endDucking) {
      final action = handleDuckingEnd(
        state: duckState,
        currentVolume: currentVolume,
      );
      duckState = action.nextState;
      actions.add(_DuckAsyncAction.endDuck(action));
    } else if (decision.endDuckingImmediately) {
      final action = handleDuckingEndImmediately(
        state: duckState,
        currentVolume: currentVolume,
      );
      duckState = action.nextState;
      actions.add(_DuckAsyncAction.endDuckImmediately(action));
    } else {
      duckState = duckState.copyWith(duckingState: decision.nextDuckingState);
    }

    return actions;
  }

  Future<void> _executeDuckActions(
    List<_DuckAsyncAction> actions,
    double currentVolume,
  ) async {
    for (final action in actions) {
      switch (action.type) {
        case _DuckActionType.beginDuck:
          // Fire-and-forget animation
          sideEffects.add('duckAnimation:${action.duckAction!.targetVolume}');
        case _DuckActionType.endDuck:
          // Fire-and-forget restore animation
          sideEffects.add('restoreAnimation:${action.duckAction!.targetVolume}');
        case _DuckActionType.endDuckImmediately:
          // Must await setVolume
          final completer = createCompleter('setVolume');
          sideEffects.add('setVolume:${action.duckAction!.targetVolume}');
          await completer.future;
      }
    }
  }
}

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

void main() {
  group('Side effect ordering', () {
    test('mixed duck -> pause begin -> pause end: setVolume, pause, play', () async {
      final processor = TestableInterruptionProcessor();

      // Event 1: duck begin
      processor.processEvent(
        type: AudioInterruptionType.duck,
        isBegin: true,
        isPlaying: true,
        currentVolume: 100.0,
      );

      // Wait for duck animation to be recorded (fire-and-forget)
      await Future.delayed(Duration.zero);

      // Event 2: pause begin (while ducking)
      // This should: setVolume(100), then pause
      processor.processEvent(
        type: AudioInterruptionType.pause,
        isBegin: true,
        isPlaying: true,
        currentVolume: 50.0,
      );

      // At this point, state is already pausedByInterruption
      expect(processor.playbackState, PlaybackInterruptionState.pausedByInterruption);

      // Wait for serializer to start processing event 2
      await Future.delayed(Duration.zero);

      // setVolume should have started but not completed
      expect(processor.hasStartedSideEffect('setVolume'), isTrue);
      expect(processor.sideEffects, contains('setVolume:100.0'));

      // pause should not have started yet (waiting for setVolume to complete)
      expect(processor.hasStartedSideEffect('pause'), isFalse);

      // Event 3: pause end arrives BEFORE setVolume completes
      // State decision will be correct (resumePlayback: true) because state was updated synchronously
      processor.processEvent(
        type: AudioInterruptionType.pause,
        isBegin: false,
        isPlaying: false,
        currentVolume: 100.0,
      );

      // At this point, play is enqueued but can't start yet
      // because setVolume and pause from event 2 haven't completed

      // Complete setVolume from event 2
      processor.completeSideEffect('setVolume');

      // Wait for serializer to proceed
      await Future.delayed(Duration.zero);

      // Now pause should start
      expect(processor.hasStartedSideEffect('pause'), isTrue);
      expect(processor.sideEffects, contains('pause'));

      // Complete pause
      processor.completeSideEffect('pause');

      // Wait for serializer to proceed
      await Future.delayed(Duration.zero);

      // Now play should start
      expect(processor.hasStartedSideEffect('play'), isTrue);
      expect(processor.sideEffects, contains('play'));

      // Verify final order
      expect(processor.sideEffects, equals([
        'duckAnimation:50.0',
        'setVolume:100.0',
        'pause',
        'play',
      ]));
    });

    test('pause begin -> pause end fast: pause before play', () async {
      final processor = TestableInterruptionProcessor();

      // Event 1: pause begin
      processor.processEvent(
        type: AudioInterruptionType.pause,
        isBegin: true,
        isPlaying: true,
      );

      expect(processor.playbackState, PlaybackInterruptionState.pausedByInterruption);

      // Wait for serializer to start processing
      await Future.delayed(Duration.zero);

      expect(processor.hasStartedSideEffect('pause'), isTrue);

      // Event 2: pause end arrives BEFORE pause completes
      processor.processEvent(
        type: AudioInterruptionType.pause,
        isBegin: false,
        isPlaying: false,
      );

      // State decision is correct because state was updated synchronously
      // Play is enqueued but won't start until pause completes

      // Complete pause
      processor.completeSideEffect('pause');

      // Wait for serializer to proceed
      await Future.delayed(Duration.zero);

      // Now play should start
      expect(processor.hasStartedSideEffect('play'), isTrue);

      // Verify order
      expect(processor.sideEffects, equals(['pause', 'play']));
    });

    test('state visible to subsequent event before side effects complete', () async {
      final processor = TestableInterruptionProcessor();

      // Event 1: pause begin
      processor.processEvent(
        type: AudioInterruptionType.pause,
        isBegin: true,
        isPlaying: true,
      );

      // State is immediately updated
      expect(processor.playbackState, PlaybackInterruptionState.pausedByInterruption);

      // Wait for serializer to start processing
      await Future.delayed(Duration.zero);

      // pause side effect has started but not completed
      expect(processor.hasStartedSideEffect('pause'), isTrue);

      // Event 2: pause end - should see pausedByInterruption state
      // because state was updated synchronously BEFORE side effects
      final decision = resolveInterruptionDecision(
        type: AudioInterruptionType.pause,
        isBegin: false,
        isPlaying: false,
        playbackState: processor.playbackState,
        duckingState: processor.duckState.duckingState,
      );

      expect(decision.resumePlayback, isTrue,
          reason: 'pause end should resume because state is pausedByInterruption');
    });

    test('multiple duck begin/end events: animations fire-and-forget', () async {
      final processor = TestableInterruptionProcessor();

      // Multiple rapid duck events
      processor.processEvent(type: AudioInterruptionType.duck, isBegin: true, isPlaying: true);
      processor.processEvent(type: AudioInterruptionType.duck, isBegin: false, isPlaying: true);
      processor.processEvent(type: AudioInterruptionType.duck, isBegin: true, isPlaying: true);
      processor.processEvent(type: AudioInterruptionType.duck, isBegin: false, isPlaying: true);

      // Wait for all animations to be recorded
      await Future.delayed(Duration.zero);
      await Future.delayed(Duration.zero);
      await Future.delayed(Duration.zero);
      await Future.delayed(Duration.zero);

      // Animations are fire-and-forget, so all should be recorded
      expect(processor.sideEffects, contains('duckAnimation:50.0'));
      expect(processor.sideEffects, contains('restoreAnimation:100.0'));
    });
  });

  group('Serializer ordering guarantee', () {
    test('serializer processes actions in FIFO order', () async {
      final serializer = InterruptionSideEffectSerializer();
      final order = <int>[];

      // Enqueue multiple actions
      serializer.run(() async {
        order.add(1);
      });
      serializer.run(() async {
        order.add(2);
      });
      serializer.run(() async {
        order.add(3);
      });

      // Wait for all to complete
      await Future.delayed(const Duration(milliseconds: 100));

      expect(order, equals([1, 2, 3]));
    });

    test('serializer waits for async actions to complete', () async {
      final serializer = InterruptionSideEffectSerializer();
      final order = <String>[];
      final completer1 = Completer<void>();
      final completer2 = Completer<void>();

      // Action 1: async with completer
      serializer.run(() async {
        order.add('1-start');
        await completer1.future;
        order.add('1-end');
      });

      // Action 2: should wait for action 1
      serializer.run(() async {
        order.add('2-start');
        await completer2.future;
        order.add('2-end');
      });

      // Give time for first action to start
      await Future.delayed(Duration.zero);

      // At this point, action 1 should be waiting, action 2 should not have started
      expect(order, equals(['1-start']));

      // Complete action 1
      completer1.complete();
      await Future.delayed(Duration.zero);

      // Action 2 should now be waiting
      expect(order, equals(['1-start', '1-end', '2-start']));

      // Complete action 2
      completer2.complete();
      await Future.delayed(Duration.zero);

      expect(order, equals(['1-start', '1-end', '2-start', '2-end']));
    });
  });
}
