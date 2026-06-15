import 'package:audio_session/audio_session.dart';

enum PlaybackInterruptionState { normal, pausedByInterruption }

enum DuckingState { normal, ducking, restoring }

class InterruptionDecision {
  const InterruptionDecision({
    required this.nextPlaybackState,
    required this.nextDuckingState,
    required this.pausePlayback,
    required this.resumePlayback,
    required this.beginDucking,
    required this.endDucking,
    required this.endDuckingImmediately,
  });

  final PlaybackInterruptionState nextPlaybackState;
  final DuckingState nextDuckingState;
  final bool pausePlayback;
  final bool resumePlayback;
  final bool beginDucking;
  final bool endDucking;
  /// When true, the handler should immediately restore volume and clear duck state.
  /// This is used when a pause/unknown interruption begins while ducking/restoring,
  /// to ensure volume is restored before playback is paused.
  final bool endDuckingImmediately;
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
      case .duck:
        // Always begin ducking, but the handler should preserve original volume
        // if already ducking or restoring (idempotent ducking).
        return InterruptionDecision(
          nextPlaybackState: playbackState,
          nextDuckingState: .ducking,
          pausePlayback: false,
          resumePlayback: false,
          beginDucking: true,
          endDucking: false,
          endDuckingImmediately: false,
        );
      case .pause:
      case .unknown:
        final shouldPause = isPlaying;
        // If currently ducking or restoring, we need to immediately end ducking
        // to restore volume before pausing. Otherwise when playback resumes,
        // the volume would still be at the ducked level.
        final shouldEndDucking = duckingState != .normal;
        return InterruptionDecision(
          nextPlaybackState: shouldPause
              ? .pausedByInterruption
              : playbackState,
          nextDuckingState: .normal,
          pausePlayback: shouldPause,
          resumePlayback: false,
          beginDucking: false,
          endDucking: false,
          endDuckingImmediately: shouldEndDucking,
        );
    }
  }

  switch (type) {
    case .duck:
      // End ducking regardless of whether we're in ducking or restoring state
      return InterruptionDecision(
        nextPlaybackState: playbackState,
        nextDuckingState: .normal,
        pausePlayback: false,
        resumePlayback: false,
        beginDucking: false,
        endDucking: true,
        endDuckingImmediately: false,
      );
    case .pause:
      final shouldResume = playbackState == .pausedByInterruption;
      return InterruptionDecision(
        nextPlaybackState: .normal,
        // Keep current ducking state on pause end - don't change it
        nextDuckingState: duckingState,
        pausePlayback: false,
        resumePlayback: shouldResume,
        beginDucking: false,
        endDucking: false,
        endDuckingImmediately: false,
      );
    case .unknown:
      return InterruptionDecision(
        nextPlaybackState: .normal,
        nextDuckingState: duckingState,
        pausePlayback: false,
        resumePlayback: false,
        beginDucking: false,
        endDucking: false,
        endDuckingImmediately: false,
      );
  }
}
