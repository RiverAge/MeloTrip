import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/interruption_state.dart';
import 'package:melo_trip/app_player/duck_volume_state_machine.dart';

void main() {
  group('Event processing race conditions', () {
    test('pause begin updates state before async pause() completes', () {
      // Simulate: pause begin -> pause end arriving rapidly
      // The second event must see state as pausedByInterruption

      var playbackState = PlaybackInterruptionState.normal;

      // Event 1: pause begin
      final decision1 = resolveInterruptionDecision(
        type: .pause,
        isBegin: true,
        isPlaying: true,
        playbackState: playbackState,
        duckingState: .normal,
      );

      // State MUST be updated synchronously BEFORE pause() is executed
      playbackState = decision1.nextPlaybackState;
      expect(playbackState, PlaybackInterruptionState.pausedByInterruption);

      // Even though pause() hasn't completed yet, state is already updated

      // Event 2: pause end arrives before pause() async completes
      final decision2 = resolveInterruptionDecision(
        type: .pause,
        isBegin: false,
        isPlaying: false, // pause() started but not necessarily completed
        playbackState: playbackState, // Uses the SYNCHRONOUSLY updated state
        duckingState: .normal,
      );

      // Because playbackState was updated synchronously to pausedByInterruption,
      // pause end will correctly decide to resume
      expect(decision2.resumePlayback, isTrue);
      expect(decision2.nextPlaybackState, PlaybackInterruptionState.normal);
    });

    test('duck begin updates state before animation completes', () {
      var duckState = const DuckVolumeState(
        duckingState: DuckingState.normal,
        volumeBeforeDucking: null,
      );
      const currentVolume = 100.0;

      // Event 1: duck begin
      final action1 = handleDuckingBegin(
        state: duckState,
        currentVolume: currentVolume,
      );

      // State MUST be updated synchronously BEFORE animation starts
      duckState = action1.nextState;
      expect(duckState.duckingState, DuckingState.ducking);
      expect(duckState.volumeBeforeDucking, equals(100.0));

      // Animation is running in background...

      // Event 2: duck begin again (e.g., second navigation prompt)
      // Even though first animation hasn't completed, state is ducking
      final action2 = handleDuckingBegin(
        state: duckState,
        currentVolume: 50.0, // Current volume might be mid-animation
      );

      // State update preserves original volume
      expect(action2.nextState.volumeBeforeDucking, equals(100.0));
      // Target still 50, not 25
      expect(action2.targetVolume, equals(50.0));
    });

    test('duck end updates state to restoring before animation', () {
      var duckState = const DuckVolumeState(
        duckingState: DuckingState.ducking,
        volumeBeforeDucking: 100.0,
      );

      // Event: duck end
      final action = handleDuckingEnd(state: duckState, currentVolume: 50.0);

      // State MUST be updated synchronously BEFORE animation starts
      duckState = action.nextState;
      expect(duckState.duckingState, DuckingState.restoring);
      expect(duckState.volumeBeforeDucking, equals(100.0));

      // Animation target is correct
      expect(action.targetVolume, equals(100.0));
    });

    test('pause begin while restoring updates state before pause()', () {
      var playbackState = PlaybackInterruptionState.normal;
      var duckState = const DuckVolumeState(
        duckingState: DuckingState.restoring,
        volumeBeforeDucking: 100.0,
      );

      // Event: pause begin (phone call during restore)
      final decision = resolveInterruptionDecision(
        type: .pause,
        isBegin: true,
        isPlaying: true,
        playbackState: playbackState,
        duckingState: duckState.duckingState,
      );

      // State updates MUST happen synchronously
      playbackState = decision.nextPlaybackState;
      expect(playbackState, PlaybackInterruptionState.pausedByInterruption);
      expect(decision.endDuckingImmediately, isTrue);

      // Duck state computed synchronously
      final duckAction = handleDuckingEndImmediately(
        state: duckState,
        currentVolume: 75.0, // Mid-restore
      );
      duckState = duckAction.nextState;

      expect(duckState.duckingState, DuckingState.normal);
      expect(duckState.volumeBeforeDucking, isNull);
      expect(duckAction.targetVolume, equals(100.0));
    });
  });

  group('Animation cancellation scenarios', () {
    test(
      'restore animation cancelled by new duck begin preserves original volume',
      () {
        // Start: ducking state with original volume
        var duckState = const DuckVolumeState(
          duckingState: DuckingState.ducking,
          volumeBeforeDucking: 100.0,
        );

        // Duck end -> enters restoring state
        final endAction = handleDuckingEnd(
          state: duckState,
          currentVolume: 50.0,
        );
        duckState = endAction.nextState;
        expect(duckState.duckingState, DuckingState.restoring);

        // While restoring (animation running), new duck begin arrives
        final beginAction = handleDuckingBegin(
          state: duckState,
          currentVolume: 75.0, // Mid-animation volume
        );
        duckState = beginAction.nextState;

        // Original volume preserved (not overwritten by 75)
        expect(duckState.volumeBeforeDucking, equals(100.0));
        // Target is 50 (100 * 0.5), not 37.5 (75 * 0.5)
        expect(beginAction.targetVolume, equals(50.0));
      },
    );

    test('restore animation cancelled by immediate end clears state', () {
      // Start: restoring state
      var duckState = const DuckVolumeState(
        duckingState: DuckingState.restoring,
        volumeBeforeDucking: 100.0,
      );

      // Immediate end (pause begin while restoring)
      final action = handleDuckingEndImmediately(
        state: duckState,
        currentVolume: 75.0,
      );
      duckState = action.nextState;

      // State cleared immediately
      expect(duckState.duckingState, DuckingState.normal);
      expect(duckState.volumeBeforeDucking, isNull);
      // Volume target is original (not current 75)
      expect(action.targetVolume, equals(100.0));
    });

    test('restore complete only clears if still in restoring state', () {
      // Case 1: Still restoring -> clears state
      var restoringState = const DuckVolumeState(
        duckingState: DuckingState.restoring,
        volumeBeforeDucking: 100.0,
      );
      var newState = handleRestoreComplete(state: restoringState);
      expect(newState.duckingState, DuckingState.normal);
      expect(newState.volumeBeforeDucking, isNull);

      // Case 2: State changed to ducking during animation -> don't clear
      var duckingState = const DuckVolumeState(
        duckingState: DuckingState.ducking,
        volumeBeforeDucking: 100.0,
      );
      newState = handleRestoreComplete(state: duckingState);
      expect(newState.duckingState, DuckingState.ducking);
      expect(newState.volumeBeforeDucking, equals(100.0));
    });
  });

  group('Full event sequences', () {
    test('pause begin -> pause end sequence works correctly', () {
      var playbackState = PlaybackInterruptionState.normal;

      // pause begin
      final decision1 = resolveInterruptionDecision(
        type: .pause,
        isBegin: true,
        isPlaying: true,
        playbackState: playbackState,
        duckingState: .normal,
      );
      playbackState = decision1.nextPlaybackState;
      expect(decision1.pausePlayback, isTrue);

      // pause end
      final decision2 = resolveInterruptionDecision(
        type: .pause,
        isBegin: false,
        isPlaying: false,
        playbackState: playbackState,
        duckingState: .normal,
      );
      expect(decision2.resumePlayback, isTrue);
      playbackState = decision2.nextPlaybackState;
      expect(playbackState, PlaybackInterruptionState.normal);
    });

    test('duck begin -> pause begin -> pause end restores volume', () {
      var playbackState = PlaybackInterruptionState.normal;
      var duckState = const DuckVolumeState(
        duckingState: DuckingState.normal,
        volumeBeforeDucking: null,
      );

      // duck begin
      final duckAction1 = handleDuckingBegin(
        state: duckState,
        currentVolume: 100.0,
      );
      duckState = duckAction1.nextState;
      expect(duckState.volumeBeforeDucking, equals(100.0));
      expect(duckAction1.targetVolume, equals(50.0));

      // pause begin (decision includes endDuckingImmediately)
      final pauseDecision1 = resolveInterruptionDecision(
        type: .pause,
        isBegin: true,
        isPlaying: true,
        playbackState: playbackState,
        duckingState: duckState.duckingState,
      );
      playbackState = pauseDecision1.nextPlaybackState;
      expect(pauseDecision1.endDuckingImmediately, isTrue);

      // duck end immediately
      final duckAction2 = handleDuckingEndImmediately(
        state: duckState,
        currentVolume: 50.0,
      );
      duckState = duckAction2.nextState;
      expect(duckAction2.targetVolume, equals(100.0));
      expect(duckState.duckingState, DuckingState.normal);

      // pause end
      final pauseDecision2 = resolveInterruptionDecision(
        type: .pause,
        isBegin: false,
        isPlaying: false,
        playbackState: playbackState,
        duckingState: duckState.duckingState,
      );
      expect(pauseDecision2.resumePlayback, isTrue);
    });
  });
}
