import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/interruption_state.dart';

void main() {
  group('Interruption scenarios - documentation', () {
    group('Duck idempotency', () {
      test('consecutive duck begin events should not halve volume repeatedly', () {
        // Scenario: Volume starts at 100
        // First duck begin -> target = 50 (100 * 0.5)
        // Second duck begin while ducking -> target should still be 50, not 25
        //
        // This is enforced by:
        // 1. resolveInterruptionDecision always signals beginDucking
        // 2. The handler (duck_volume_state_machine) preserves volumeBeforeDucking
        //    when state is not normal
        // 3. Target is calculated from volumeBeforeDucking, not current volume

        // First duck begin
        final firstDecision = resolveInterruptionDecision(
          type: .duck,
          isBegin: true,
          isPlaying: true,
          playbackState: .normal,
          duckingState: .normal,
        );

        expect(firstDecision.beginDucking, isTrue);
        expect(firstDecision.nextDuckingState, DuckingState.ducking);

        // Second duck begin (while already ducking)
        final secondDecision = resolveInterruptionDecision(
          type: .duck,
          isBegin: true,
          isPlaying: true,
          playbackState: .normal,
          duckingState: .ducking,
        );

        // Decision still signals beginDucking
        expect(secondDecision.beginDucking, isTrue);
        expect(secondDecision.nextDuckingState, DuckingState.ducking);
      });

      test(
        'duck begin during restore animation should preserve original volume',
        () {
          // Scenario: Volume starts at 100
          // First duck begin -> volumeBeforeDucking = 100, target = 50
          // Duck end -> start restoring to 100, duckingState = restoring
          // Second duck begin during restore -> should keep volumeBeforeDucking = 100

          // Duck end transitions to normal in decision, but handler uses restoring internally
          final duckEndDecision = resolveInterruptionDecision(
            type: .duck,
            isBegin: false,
            isPlaying: true,
            playbackState: .normal,
            duckingState: .ducking,
          );

          expect(duckEndDecision.endDucking, isTrue);
          expect(duckEndDecision.nextDuckingState, DuckingState.normal);

          // In the actual handler, during restore animation:
          // _duckingState = DuckingState.restoring
          // If another duck begin arrives:
          final reDuckDecision = resolveInterruptionDecision(
            type: .duck,
            isBegin: true,
            isPlaying: true,
            playbackState: .normal,
            duckingState: .restoring,
          );

          expect(reDuckDecision.beginDucking, isTrue);
          expect(reDuckDecision.nextDuckingState, DuckingState.ducking);
        },
      );

      test('final duck end restores to original volume', () {
        // After any number of duck begin/end cycles,
        // the final duck end should restore to the original volume
        // stored in volumeBeforeDucking

        final duckEndFromRestoring = resolveInterruptionDecision(
          type: .duck,
          isBegin: false,
          isPlaying: true,
          playbackState: .normal,
          duckingState: .restoring,
        );

        expect(duckEndFromRestoring.endDucking, isTrue);
        expect(duckEndFromRestoring.nextDuckingState, DuckingState.normal);
      });
    });

    group('Pause interruption', () {
      test('pause begin while playing transitions to pausedByInterruption', () {
        final decision = resolveInterruptionDecision(
          type: .pause,
          isBegin: true,
          isPlaying: true,
          playbackState: .normal,
          duckingState: .normal,
        );

        expect(decision.pausePlayback, isTrue);
        expect(decision.resumePlayback, isFalse);
        expect(
          decision.nextPlaybackState,
          PlaybackInterruptionState.pausedByInterruption,
        );
      });

      test('pause end resumes only when paused by interruption', () {
        final decision = resolveInterruptionDecision(
          type: .pause,
          isBegin: false,
          isPlaying: false,
          playbackState: .pausedByInterruption,
          duckingState: .normal,
        );

        expect(decision.pausePlayback, isFalse);
        expect(decision.resumePlayback, isTrue);
        expect(decision.nextPlaybackState, PlaybackInterruptionState.normal);
      });

      test('pause end does not resume when not paused by interruption', () {
        final decision = resolveInterruptionDecision(
          type: .pause,
          isBegin: false,
          isPlaying: false,
          playbackState: .normal,
          duckingState: .normal,
        );

        expect(decision.resumePlayback, isFalse);
        expect(decision.nextPlaybackState, PlaybackInterruptionState.normal);
      });
    });

    group('Mixed duck and pause', () {
      test('duck and pause are independent concerns', () {
        // Pause type should not trigger ducking
        final pauseBegin = resolveInterruptionDecision(
          type: .pause,
          isBegin: true,
          isPlaying: true,
          playbackState: .normal,
          duckingState: .normal,
        );

        expect(pauseBegin.beginDucking, isFalse);
        expect(pauseBegin.pausePlayback, isTrue);

        // Duck type should not trigger pause
        final duckBegin = resolveInterruptionDecision(
          type: .duck,
          isBegin: true,
          isPlaying: true,
          playbackState: .normal,
          duckingState: .normal,
        );

        expect(duckBegin.beginDucking, isTrue);
        expect(duckBegin.pausePlayback, isFalse);
      });

      test('pause begin while ducking immediately ends ducking', () {
        // This is the key fix for the mixed scenario:
        // When pause begins while ducking, we must immediately restore volume
        // so that when playback resumes, volume is at original level

        final decision = resolveInterruptionDecision(
          type: .pause,
          isBegin: true,
          isPlaying: true,
          playbackState: .normal,
          duckingState: .ducking,
        );

        expect(decision.pausePlayback, isTrue);
        expect(decision.endDuckingImmediately, isTrue);
        expect(decision.nextDuckingState, DuckingState.normal);
      });

      test('pause begin while restoring immediately ends ducking', () {
        final decision = resolveInterruptionDecision(
          type: .pause,
          isBegin: true,
          isPlaying: true,
          playbackState: .normal,
          duckingState: .restoring,
        );

        expect(decision.pausePlayback, isTrue);
        expect(decision.endDuckingImmediately, isTrue);
        expect(decision.nextDuckingState, DuckingState.normal);
      });
    });
  });
}
