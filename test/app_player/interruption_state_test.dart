import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/interruption_state.dart';

void main() {
  group('resolveInterruptionDecision - begin interruption', () {
    test('duck type starts ducking', () {
      final result = resolveInterruptionDecision(
        type: .duck,
        isBegin: true,
        isPlaying: true,
        playbackState: .normal,
        duckingState: .normal,
      );

      expect(result.beginDucking, isTrue);
      expect(result.endDucking, isFalse);
      expect(result.endDuckingImmediately, isFalse);
      expect(result.pausePlayback, isFalse);
      expect(result.resumePlayback, isFalse);
      expect(result.nextDuckingState, equals(DuckingState.ducking));
    });

    test('duck type begins ducking even when already ducking (idempotent)', () {
      final result = resolveInterruptionDecision(
        type: .duck,
        isBegin: true,
        isPlaying: true,
        playbackState: .normal,
        duckingState: .ducking,
      );

      // Should still signal beginDucking so the handler can react,
      // but the handler should preserve original volume.
      expect(result.beginDucking, isTrue);
      expect(result.nextDuckingState, equals(DuckingState.ducking));
    });

    test('duck type begins ducking even when restoring', () {
      final result = resolveInterruptionDecision(
        type: .duck,
        isBegin: true,
        isPlaying: true,
        playbackState: .normal,
        duckingState: .restoring,
      );

      // Should signal beginDucking to interrupt the restore animation
      expect(result.beginDucking, isTrue);
      expect(result.nextDuckingState, equals(DuckingState.ducking));
    });

    test('pause type pauses playback when playing', () {
      final result = resolveInterruptionDecision(
        type: .pause,
        isBegin: true,
        isPlaying: true,
        playbackState: .normal,
        duckingState: .normal,
      );

      expect(result.pausePlayback, isTrue);
      expect(result.resumePlayback, isFalse);
      expect(result.endDuckingImmediately, isFalse);
      expect(
        result.nextPlaybackState,
        equals(PlaybackInterruptionState.pausedByInterruption),
      );
    });

    test('pause type does not pause when not playing', () {
      final result = resolveInterruptionDecision(
        type: .pause,
        isBegin: true,
        isPlaying: false,
        playbackState: .normal,
        duckingState: .normal,
      );

      expect(result.pausePlayback, isFalse);
      expect(
        result.nextPlaybackState,
        equals(PlaybackInterruptionState.normal),
      );
    });

    test('unknown type behaves like pause', () {
      final result = resolveInterruptionDecision(
        type: .unknown,
        isBegin: true,
        isPlaying: true,
        playbackState: .normal,
        duckingState: .normal,
      );

      expect(result.pausePlayback, isTrue);
      expect(
        result.nextPlaybackState,
        equals(PlaybackInterruptionState.pausedByInterruption),
      );
    });
  });

  group('resolveInterruptionDecision - mixed duck + pause scenarios', () {
    test('pause begin while ducking ends ducking immediately', () {
      final result = resolveInterruptionDecision(
        type: .pause,
        isBegin: true,
        isPlaying: true,
        playbackState: .normal,
        duckingState: .ducking,
      );

      expect(result.pausePlayback, isTrue);
      expect(result.endDuckingImmediately, isTrue);
      expect(result.beginDucking, isFalse);
      expect(result.endDucking, isFalse);
      expect(result.nextDuckingState, DuckingState.normal);
    });

    test('pause begin while restoring ends ducking immediately', () {
      final result = resolveInterruptionDecision(
        type: .pause,
        isBegin: true,
        isPlaying: true,
        playbackState: .normal,
        duckingState: .restoring,
      );

      expect(result.pausePlayback, isTrue);
      expect(result.endDuckingImmediately, isTrue);
      expect(result.nextDuckingState, DuckingState.normal);
    });

    test('unknown begin while ducking ends ducking immediately', () {
      final result = resolveInterruptionDecision(
        type: .unknown,
        isBegin: true,
        isPlaying: true,
        playbackState: .normal,
        duckingState: .ducking,
      );

      expect(result.pausePlayback, isTrue);
      expect(result.endDuckingImmediately, isTrue);
      expect(result.nextDuckingState, DuckingState.normal);
    });

    test('pause begin while normal does not end ducking', () {
      final result = resolveInterruptionDecision(
        type: .pause,
        isBegin: true,
        isPlaying: true,
        playbackState: .normal,
        duckingState: .normal,
      );

      expect(result.pausePlayback, isTrue);
      expect(result.endDuckingImmediately, isFalse);
    });
  });

  group('resolveInterruptionDecision - end interruption', () {
    test('duck type ends ducking from ducking state', () {
      final result = resolveInterruptionDecision(
        type: .duck,
        isBegin: false,
        isPlaying: false,
        playbackState: .normal,
        duckingState: .ducking,
      );

      expect(result.endDucking, isTrue);
      expect(result.beginDucking, isFalse);
      expect(result.endDuckingImmediately, isFalse);
      expect(result.nextDuckingState, equals(DuckingState.normal));
    });

    test('duck type ends ducking from restoring state', () {
      final result = resolveInterruptionDecision(
        type: .duck,
        isBegin: false,
        isPlaying: false,
        playbackState: .normal,
        duckingState: .restoring,
      );

      expect(result.endDucking, isTrue);
      expect(result.nextDuckingState, equals(DuckingState.normal));
    });

    test('pause type resumes when was paused by interruption', () {
      final result = resolveInterruptionDecision(
        type: .pause,
        isBegin: false,
        isPlaying: false,
        playbackState: .pausedByInterruption,
        duckingState: .normal,
      );

      expect(result.resumePlayback, isTrue);
      expect(
        result.nextPlaybackState,
        equals(PlaybackInterruptionState.normal),
      );
    });

    test('pause type does not resume when not paused by interruption', () {
      final result = resolveInterruptionDecision(
        type: .pause,
        isBegin: false,
        isPlaying: false,
        playbackState: .normal,
        duckingState: .normal,
      );

      expect(result.resumePlayback, isFalse);
      expect(
        result.nextPlaybackState,
        equals(PlaybackInterruptionState.normal),
      );
    });

    test('pause end preserves ducking state', () {
      // If ducking was somehow still active, pause end should preserve it
      final result = resolveInterruptionDecision(
        type: .pause,
        isBegin: false,
        isPlaying: false,
        playbackState: .pausedByInterruption,
        duckingState: .ducking,
      );

      expect(result.resumePlayback, isTrue);
      expect(result.nextDuckingState, DuckingState.ducking);
    });

    test('unknown type resets playback state but preserves ducking', () {
      final result = resolveInterruptionDecision(
        type: .unknown,
        isBegin: false,
        isPlaying: false,
        playbackState: .pausedByInterruption,
        duckingState: .ducking,
      );

      expect(result.resumePlayback, isFalse);
      expect(
        result.nextPlaybackState,
        equals(PlaybackInterruptionState.normal),
      );
      expect(result.nextDuckingState, DuckingState.ducking);
    });
  });

  group('DuckingState enum', () {
    test('has normal, ducking, and restoring values', () {
      expect(DuckingState.values, contains(DuckingState.normal));
      expect(DuckingState.values, contains(DuckingState.ducking));
      expect(DuckingState.values, contains(DuckingState.restoring));
      expect(DuckingState.values.length, equals(3));
    });
  });
}
