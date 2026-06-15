// Pure Dart duck volume state machine for testing.
// This module extracts the ducking logic from the player implementation
// to enable comprehensive unit testing without mocking the player.

import 'package:melo_trip/app_player/interruption_state.dart';

/// Represents the state of the duck volume state machine.
class DuckVolumeState {
  const DuckVolumeState({
    required this.duckingState,
    this.volumeBeforeDucking,
  });

  final DuckingState duckingState;
  final double? volumeBeforeDucking;

  DuckVolumeState copyWith({
    DuckingState? duckingState,
    double? volumeBeforeDucking,
    bool clearVolumeBeforeDucking = false,
  }) {
    return DuckVolumeState(
      duckingState: duckingState ?? this.duckingState,
      volumeBeforeDucking:
          clearVolumeBeforeDucking ? null : (volumeBeforeDucking ?? this.volumeBeforeDucking),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DuckVolumeState &&
        other.duckingState == duckingState &&
        other.volumeBeforeDucking == volumeBeforeDucking;
  }

  @override
  int get hashCode => Object.hash(duckingState, volumeBeforeDucking);

  @override
  String toString() =>
      'DuckVolumeState(duckingState: $duckingState, volumeBeforeDucking: $volumeBeforeDucking)';
}

/// Result of a duck state machine action.
class DuckAction {
  const DuckAction({
    required this.targetVolume,
    required this.nextState,
    this.shouldAnimate = false,
  });

  /// The target volume to set/animate to.
  final double targetVolume;

  /// The next state after this action.
  final DuckVolumeState nextState;

  /// Whether the volume change should be animated (true) or set immediately (false).
  final bool shouldAnimate;

  @override
  String toString() =>
      'DuckAction(targetVolume: $targetVolume, nextState: $nextState, shouldAnimate: $shouldAnimate)';
}

/// Handles duck begin action.
/// Returns the target volume and next state.
DuckAction handleDuckingBegin({
  required DuckVolumeState state,
  required double currentVolume,
}) {
  // Only record original volume when first entering duck from normal state.
  // This ensures we always restore to the user's original volume,
  // not some intermediate ducked volume.
  double? newVolumeBeforeDucking = state.volumeBeforeDucking;
  if (state.duckingState == DuckingState.normal) {
    newVolumeBeforeDucking = currentVolume;
  }

  // Calculate target based on the original volume (not current volume)
  final originalVolume = newVolumeBeforeDucking ?? currentVolume;
  final targetVolume = originalVolume * 0.5;

  return DuckAction(
    targetVolume: targetVolume,
    nextState: DuckVolumeState(
      duckingState: DuckingState.ducking,
      volumeBeforeDucking: newVolumeBeforeDucking,
    ),
    shouldAnimate: true,
  );
}

/// Handles duck end action (starts restore animation).
/// Returns the target volume and next state.
DuckAction handleDuckingEnd({
  required DuckVolumeState state,
  required double currentVolume,
}) {
  final originalVolume = state.volumeBeforeDucking;

  if (originalVolume == null) {
    // No original volume recorded, just reset to normal
    return DuckAction(
      targetVolume: currentVolume,
      nextState: const DuckVolumeState(
        duckingState: DuckingState.normal,
        volumeBeforeDucking: null,
      ),
      shouldAnimate: false,
    );
  }

  // Start restore animation to original volume
  return DuckAction(
    targetVolume: originalVolume,
    nextState: DuckVolumeState(
      duckingState: DuckingState.restoring,
      volumeBeforeDucking: originalVolume,
    ),
    shouldAnimate: true,
  );
}

/// Handles the completion of restore animation.
/// Called after the restore animation finishes.
DuckVolumeState handleRestoreComplete({
  required DuckVolumeState state,
}) {
  // Only clear if we're still in restoring state
  if (state.duckingState == DuckingState.restoring) {
    return const DuckVolumeState(
      duckingState: DuckingState.normal,
      volumeBeforeDucking: null,
    );
  }
  // Otherwise, state was changed (e.g., another duck began during restore)
  return state;
}

/// Handles immediate duck end (for pause/unknown interruption while ducking).
/// Restores volume immediately without animation.
DuckAction handleDuckingEndImmediately({
  required DuckVolumeState state,
  required double currentVolume,
}) {
  final originalVolume = state.volumeBeforeDucking ?? currentVolume;

  return DuckAction(
    targetVolume: originalVolume,
    nextState: const DuckVolumeState(
      duckingState: DuckingState.normal,
      volumeBeforeDucking: null,
    ),
    shouldAnimate: false,
  );
}
