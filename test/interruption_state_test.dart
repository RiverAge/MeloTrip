import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/app_player/interruption_state.dart';

void main() {
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

  test('duck begin enters ducking without pausing playback', () {
    final decision = resolveInterruptionDecision(
      type: .duck,
      isBegin: true,
      isPlaying: true,
      playbackState: .normal,
      duckingState: .normal,
    );

    expect(decision.beginDucking, isTrue);
    expect(decision.pausePlayback, isFalse);
    expect(decision.nextDuckingState, DuckingState.ducking);
  });

  test('duck end exits ducking', () {
    final decision = resolveInterruptionDecision(
      type: .duck,
      isBegin: false,
      isPlaying: true,
      playbackState: .normal,
      duckingState: .ducking,
    );

    expect(decision.endDucking, isTrue);
    expect(decision.nextDuckingState, DuckingState.normal);
  });

  test('unknown end clears playback interruption state', () {
    final decision = resolveInterruptionDecision(
      type: .unknown,
      isBegin: false,
      isPlaying: false,
      playbackState: .pausedByInterruption,
      duckingState: .normal,
    );

    expect(decision.pausePlayback, isFalse);
    expect(decision.resumePlayback, isFalse);
    expect(decision.nextPlaybackState, PlaybackInterruptionState.normal);
  });
}
