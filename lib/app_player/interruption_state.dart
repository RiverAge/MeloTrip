import 'package:audio_session/audio_session.dart';

enum PlaybackInterruptionState { normal, pausedByInterruption }

enum DuckingState { normal, ducking }

class InterruptionDecision {
  const InterruptionDecision({
    required this.nextPlaybackState,
    required this.nextDuckingState,
    required this.pausePlayback,
    required this.resumePlayback,
    required this.beginDucking,
    required this.endDucking,
  });

  final PlaybackInterruptionState nextPlaybackState;
  final DuckingState nextDuckingState;
  final bool pausePlayback;
  final bool resumePlayback;
  final bool beginDucking;
  final bool endDucking;
}

InterruptionDecision resolveInterruptionDecision({
  required AudioInterruptionType type,
  required bool isBegin,
  required bool isPlaying,
  required PlaybackInterruptionState playbackState,
  required DuckingState duckingState,
}) {
  if (isBegin) {
    switch (type) {
      case AudioInterruptionType.duck:
        return InterruptionDecision(
          nextPlaybackState: playbackState,
          nextDuckingState: DuckingState.ducking,
          pausePlayback: false,
          resumePlayback: false,
          beginDucking: true,
          endDucking: false,
        );
      case AudioInterruptionType.pause:
      case AudioInterruptionType.unknown:
        final shouldPause = isPlaying;
        return InterruptionDecision(
          nextPlaybackState: shouldPause
              ? PlaybackInterruptionState.pausedByInterruption
              : playbackState,
          nextDuckingState: duckingState,
          pausePlayback: shouldPause,
          resumePlayback: false,
          beginDucking: false,
          endDucking: false,
        );
    }
  }

  switch (type) {
    case AudioInterruptionType.duck:
      return InterruptionDecision(
        nextPlaybackState: playbackState,
        nextDuckingState: DuckingState.normal,
        pausePlayback: false,
        resumePlayback: false,
        beginDucking: false,
        endDucking: true,
      );
    case AudioInterruptionType.pause:
      final shouldResume =
          playbackState == PlaybackInterruptionState.pausedByInterruption;
      return InterruptionDecision(
        nextPlaybackState: PlaybackInterruptionState.normal,
        nextDuckingState: duckingState,
        pausePlayback: false,
        resumePlayback: shouldResume,
        beginDucking: false,
        endDucking: false,
      );
    case AudioInterruptionType.unknown:
      return InterruptionDecision(
        nextPlaybackState: PlaybackInterruptionState.normal,
        nextDuckingState: duckingState,
        pausePlayback: false,
        resumePlayback: false,
        beginDucking: false,
        endDucking: false,
      );
  }
}
