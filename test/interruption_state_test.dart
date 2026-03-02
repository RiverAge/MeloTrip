import 'package:audio_session/audio_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/interruption_state.dart';

void main() {
  test('pause begin while playing transitions to pausedByInterruption', () {
    final decision = resolveInterruptionDecision(
      type: AudioInterruptionType.pause,
      isBegin: true,
      isPlaying: true,
      playbackState: PlaybackInterruptionState.normal,
      duckingState: DuckingState.normal,
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
      type: AudioInterruptionType.pause,
      isBegin: false,
      isPlaying: false,
      playbackState: PlaybackInterruptionState.pausedByInterruption,
      duckingState: DuckingState.normal,
    );

    expect(decision.pausePlayback, isFalse);
    expect(decision.resumePlayback, isTrue);
    expect(decision.nextPlaybackState, PlaybackInterruptionState.normal);
  });

  test('duck begin enters ducking without pausing playback', () {
    final decision = resolveInterruptionDecision(
      type: AudioInterruptionType.duck,
      isBegin: true,
      isPlaying: true,
      playbackState: PlaybackInterruptionState.normal,
      duckingState: DuckingState.normal,
    );

    expect(decision.beginDucking, isTrue);
    expect(decision.pausePlayback, isFalse);
    expect(decision.nextDuckingState, DuckingState.ducking);
  });

  test('duck end exits ducking', () {
    final decision = resolveInterruptionDecision(
      type: AudioInterruptionType.duck,
      isBegin: false,
      isPlaying: true,
      playbackState: PlaybackInterruptionState.normal,
      duckingState: DuckingState.ducking,
    );

    expect(decision.endDucking, isTrue);
    expect(decision.nextDuckingState, DuckingState.normal);
  });

  test('unknown end clears playback interruption state', () {
    final decision = resolveInterruptionDecision(
      type: AudioInterruptionType.unknown,
      isBegin: false,
      isPlaying: false,
      playbackState: PlaybackInterruptionState.pausedByInterruption,
      duckingState: DuckingState.normal,
    );

    expect(decision.pausePlayback, isFalse);
    expect(decision.resumePlayback, isFalse);
    expect(decision.nextPlaybackState, PlaybackInterruptionState.normal);
  });
}
