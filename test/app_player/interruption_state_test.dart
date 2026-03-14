import 'package:flutter_test/flutter_test.dart';
import 'package:audio_session/audio_session.dart';
import 'package:melo_trip/app_player/interruption_state.dart';

void main() {
  group('resolveInterruptionDecision - begin interruption', () {
    test('duck type starts ducking', () {
      final result = resolveInterruptionDecision(
        type: AudioInterruptionType.duck,
        isBegin: true,
        isPlaying: true,
        playbackState: PlaybackInterruptionState.normal,
        duckingState: DuckingState.normal,
      );

      expect(result.beginDucking, isTrue);
      expect(result.endDucking, isFalse);
      expect(result.pausePlayback, isFalse);
      expect(result.resumePlayback, isFalse);
      expect(result.nextDuckingState, equals(DuckingState.ducking));
    });

    test('pause type pauses playback when playing', () {
      final result = resolveInterruptionDecision(
        type: AudioInterruptionType.pause,
        isBegin: true,
        isPlaying: true,
        playbackState: PlaybackInterruptionState.normal,
        duckingState: DuckingState.normal,
      );

      expect(result.pausePlayback, isTrue);
      expect(result.resumePlayback, isFalse);
      expect(result.nextPlaybackState, equals(PlaybackInterruptionState.pausedByInterruption));
    });

    test('pause type does not pause when not playing', () {
      final result = resolveInterruptionDecision(
        type: AudioInterruptionType.pause,
        isBegin: true,
        isPlaying: false,
        playbackState: PlaybackInterruptionState.normal,
        duckingState: DuckingState.normal,
      );

      expect(result.pausePlayback, isFalse);
      expect(result.nextPlaybackState, equals(PlaybackInterruptionState.normal));
    });

    test('unknown type behaves like pause', () {
      final result = resolveInterruptionDecision(
        type: AudioInterruptionType.unknown,
        isBegin: true,
        isPlaying: true,
        playbackState: PlaybackInterruptionState.normal,
        duckingState: DuckingState.normal,
      );

      expect(result.pausePlayback, isTrue);
      expect(result.nextPlaybackState, equals(PlaybackInterruptionState.pausedByInterruption));
    });
  });

  group('resolveInterruptionDecision - end interruption', () {
    test('duck type ends ducking', () {
      final result = resolveInterruptionDecision(
        type: AudioInterruptionType.duck,
        isBegin: false,
        isPlaying: false,
        playbackState: PlaybackInterruptionState.normal,
        duckingState: DuckingState.ducking,
      );

      expect(result.endDucking, isTrue);
      expect(result.beginDucking, isFalse);
      expect(result.nextDuckingState, equals(DuckingState.normal));
    });

    test('pause type resumes when was paused by interruption', () {
      final result = resolveInterruptionDecision(
        type: AudioInterruptionType.pause,
        isBegin: false,
        isPlaying: false,
        playbackState: PlaybackInterruptionState.pausedByInterruption,
        duckingState: DuckingState.normal,
      );

      expect(result.resumePlayback, isTrue);
      expect(result.nextPlaybackState, equals(PlaybackInterruptionState.normal));
    });

    test('pause type does not resume when not paused by interruption', () {
      final result = resolveInterruptionDecision(
        type: AudioInterruptionType.pause,
        isBegin: false,
        isPlaying: false,
        playbackState: PlaybackInterruptionState.normal,
        duckingState: DuckingState.normal,
      );

      expect(result.resumePlayback, isFalse);
      expect(result.nextPlaybackState, equals(PlaybackInterruptionState.normal));
    });

    test('unknown type resets state', () {
      final result = resolveInterruptionDecision(
        type: AudioInterruptionType.unknown,
        isBegin: false,
        isPlaying: false,
        playbackState: PlaybackInterruptionState.pausedByInterruption,
        duckingState: DuckingState.normal,
      );

      expect(result.resumePlayback, isFalse);
      expect(result.nextPlaybackState, equals(PlaybackInterruptionState.normal));
    });
  });
}
