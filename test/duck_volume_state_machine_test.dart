import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/duck_volume_state_machine.dart';
import 'package:melo_trip/app_player/interruption_state.dart';

void main() {
  group('DuckVolumeStateMachine - consecutive duck begin', () {
    test('first duck begin records original volume and targets 50%', () {
      final initialState = const DuckVolumeState(
        duckingState: DuckingState.normal,
        volumeBeforeDucking: null,
      );
      const originalVolume = 100.0;

      final action = handleDuckingBegin(
        state: initialState,
        currentVolume: originalVolume,
      );

      expect(action.targetVolume, equals(50.0)); // 100 * 0.5
      expect(action.nextState.duckingState, DuckingState.ducking);
      expect(action.nextState.volumeBeforeDucking, equals(100.0));
      expect(action.shouldAnimate, isTrue);
    });

    test('second duck begin while ducking preserves original volume', () {
      // Start with ducking state (volume already at 50)
      final duckingState = const DuckVolumeState(
        duckingState: DuckingState.ducking,
        volumeBeforeDucking: 100.0,
      );
      const currentVolume = 50.0;

      final action = handleDuckingBegin(
        state: duckingState,
        currentVolume: currentVolume,
      );

      // Target should still be 50 (100 * 0.5), NOT 25 (50 * 0.5)
      expect(action.targetVolume, equals(50.0));
      expect(action.nextState.duckingState, DuckingState.ducking);
      // Original volume should be preserved
      expect(action.nextState.volumeBeforeDucking, equals(100.0));
    });

    test('third duck begin while ducking still targets 50%', () {
      final duckingState = const DuckVolumeState(
        duckingState: DuckingState.ducking,
        volumeBeforeDucking: 100.0,
      );

      // Even if current volume somehow drifted to 40
      const currentVolume = 40.0;

      final action = handleDuckingBegin(
        state: duckingState,
        currentVolume: currentVolume,
      );

      // Target should still be 50 (100 * 0.5)
      expect(action.targetVolume, equals(50.0));
      expect(action.nextState.volumeBeforeDucking, equals(100.0));
    });
  });

  group('DuckVolumeStateMachine - duck during restore', () {
    test('duck begin during restore preserves original volume', () {
      // Simulate being in restoring state (volume animating back to 100)
      final restoringState = const DuckVolumeState(
        duckingState: DuckingState.restoring,
        volumeBeforeDucking: 100.0,
      );
      // Current volume is somewhere between 50 and 100 during restore
      const currentVolume = 75.0;

      final action = handleDuckingBegin(
        state: restoringState,
        currentVolume: currentVolume,
      );

      // Target should be 50 (100 * 0.5), NOT 37.5 (75 * 0.5)
      expect(action.targetVolume, equals(50.0));
      // Original volume should be preserved
      expect(action.nextState.volumeBeforeDucking, equals(100.0));
      expect(action.nextState.duckingState, DuckingState.ducking);
    });
  });

  group('DuckVolumeStateMachine - duck end and restore', () {
    test('duck end starts restore to original volume', () {
      final duckingState = const DuckVolumeState(
        duckingState: DuckingState.ducking,
        volumeBeforeDucking: 100.0,
      );
      const currentVolume = 50.0;

      final action = handleDuckingEnd(
        state: duckingState,
        currentVolume: currentVolume,
      );

      expect(action.targetVolume, equals(100.0));
      expect(action.nextState.duckingState, DuckingState.restoring);
      expect(action.nextState.volumeBeforeDucking, equals(100.0));
      expect(action.shouldAnimate, isTrue);
    });

    test('restore complete clears state', () {
      final restoringState = const DuckVolumeState(
        duckingState: DuckingState.restoring,
        volumeBeforeDucking: 100.0,
      );

      final newState = handleRestoreComplete(state: restoringState);

      expect(newState.duckingState, DuckingState.normal);
      expect(newState.volumeBeforeDucking, isNull);
    });

    test('restore complete while already ducking does not change state', () {
      // This can happen if another duck began during restore
      final duckingState = const DuckVolumeState(
        duckingState: DuckingState.ducking,
        volumeBeforeDucking: 100.0,
      );

      final newState = handleRestoreComplete(state: duckingState);

      // State should remain unchanged
      expect(newState.duckingState, DuckingState.ducking);
      expect(newState.volumeBeforeDucking, equals(100.0));
    });
  });

  group('DuckVolumeStateMachine - immediate duck end', () {
    test('immediate end restores to original volume synchronously', () {
      final duckingState = const DuckVolumeState(
        duckingState: DuckingState.ducking,
        volumeBeforeDucking: 100.0,
      );
      const currentVolume = 50.0;

      final action = handleDuckingEndImmediately(
        state: duckingState,
        currentVolume: currentVolume,
      );

      expect(action.targetVolume, equals(100.0));
      expect(action.shouldAnimate, isFalse); // Immediate, not animated
      expect(action.nextState.duckingState, DuckingState.normal);
      expect(action.nextState.volumeBeforeDucking, isNull);
    });

    test('immediate end during restoring also works', () {
      final restoringState = const DuckVolumeState(
        duckingState: DuckingState.restoring,
        volumeBeforeDucking: 100.0,
      );
      const currentVolume = 75.0;

      final action = handleDuckingEndImmediately(
        state: restoringState,
        currentVolume: currentVolume,
      );

      expect(action.targetVolume, equals(100.0));
      expect(action.shouldAnimate, isFalse);
      expect(action.nextState.duckingState, DuckingState.normal);
    });
  });

  group('DuckVolumeStateMachine - full scenario simulations', () {
    test('consecutive duck begin/end cycles restore to original volume', () {
      const originalVolume = 100.0;
      var state = const DuckVolumeState(
        duckingState: DuckingState.normal,
        volumeBeforeDucking: null,
      );
      var currentVolume = originalVolume;

      // First duck begin
      var action = handleDuckingBegin(
        state: state,
        currentVolume: currentVolume,
      );
      state = action.nextState;
      currentVolume = action.targetVolume;
      expect(currentVolume, equals(50.0));

      // Second duck begin (while already ducking)
      action = handleDuckingBegin(
        state: state,
        currentVolume: currentVolume,
      );
      state = action.nextState;
      currentVolume = action.targetVolume;
      expect(currentVolume, equals(50.0)); // Still 50, not 25

      // Duck end
      action = handleDuckingEnd(
        state: state,
        currentVolume: currentVolume,
      );
      state = action.nextState;
      currentVolume = action.targetVolume;
      expect(currentVolume, equals(100.0)); // Restoring to original

      // Restore complete
      state = handleRestoreComplete(state: state);
      expect(state.duckingState, DuckingState.normal);
      expect(state.volumeBeforeDucking, isNull);
    });

    test('duck during restore preserves original volume', () {
      const originalVolume = 100.0;
      var state = const DuckVolumeState(
        duckingState: DuckingState.normal,
        volumeBeforeDucking: null,
      );
      var currentVolume = originalVolume;

      // Duck begin
      var action = handleDuckingBegin(
        state: state,
        currentVolume: currentVolume,
      );
      state = action.nextState;
      currentVolume = action.targetVolume;
      expect(currentVolume, equals(50.0));

      // Duck end (starts restore)
      action = handleDuckingEnd(
        state: state,
        currentVolume: currentVolume,
      );
      state = action.nextState;
      expect(state.duckingState, DuckingState.restoring);

      // During restore, volume is at 75 (mid-animation)
      currentVolume = 75.0;

      // Another duck begin during restore
      action = handleDuckingBegin(
        state: state,
        currentVolume: currentVolume,
      );
      state = action.nextState;
      currentVolume = action.targetVolume;

      // Target should be 50 (100 * 0.5), NOT 37.5 (75 * 0.5)
      expect(currentVolume, equals(50.0));
      expect(state.volumeBeforeDucking, equals(100.0));

      // Final duck end
      action = handleDuckingEnd(
        state: state,
        currentVolume: currentVolume,
      );
      state = action.nextState;
      currentVolume = action.targetVolume;

      // Should restore to original 100
      expect(currentVolume, equals(100.0));
    });

    test('mixed duck begin + pause begin + pause end restores volume', () {
      const originalVolume = 100.0;
      var state = const DuckVolumeState(
        duckingState: DuckingState.normal,
        volumeBeforeDucking: null,
      );
      var currentVolume = originalVolume;

      // Duck begin (navigation starts)
      var action = handleDuckingBegin(
        state: state,
        currentVolume: currentVolume,
      );
      state = action.nextState;
      currentVolume = action.targetVolume;
      expect(currentVolume, equals(50.0));
      expect(state.volumeBeforeDucking, equals(100.0));

      // Pause begin (phone call) - should immediately end ducking
      action = handleDuckingEndImmediately(
        state: state,
        currentVolume: currentVolume,
      );
      state = action.nextState;
      currentVolume = action.targetVolume;

      // Volume should be immediately restored to original
      expect(currentVolume, equals(100.0));
      expect(state.duckingState, DuckingState.normal);
      expect(state.volumeBeforeDucking, isNull);

      // Pause end (call ends) - playback resumes at original volume
      // No duck state change needed, volume is already correct
      expect(currentVolume, equals(100.0));
    });
  });
}
