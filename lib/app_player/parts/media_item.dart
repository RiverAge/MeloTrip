part of '../player.dart';

extension PlayerMediaItem on AppPlayer {
  Future<void> _updateCurrentMediaItemButton() async {
    // final starred = await _isCurrentStarred();
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },

        androidCompactActionIndices: const [0, 1, 3],
        processingState:
            _player.state.buffering
                ? AudioProcessingState.buffering
                : _player.state.completed
                ? AudioProcessingState.completed
                : AudioProcessingState.ready,
        playing: playing,
        updatePosition: position,
        bufferedPosition: buffer,
        speed: rate,
      ),
    );
  }
}
