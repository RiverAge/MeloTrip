part of '../player.dart';

extension PlayerMediaItem on AppPlayer {
  void _syncMediaItem(PlayQueue playQueue) {
    mediaItem.add(buildMediaItemFromPlayQueue(playQueue: playQueue));
  }

  void _updateCurrentMediaItemButton({Duration? position}) {
    return playbackState.add(
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
        processingState: _player.state.buffering
            ? AudioProcessingState.buffering
            : _player.state.completed
            ? AudioProcessingState.completed
            : AudioProcessingState.ready,
        playing: playing,
        updatePosition: position ?? _player.state.position,
        bufferedPosition: buffer,
        speed: rate,
      ),
    );
  }
}

MediaItem buildMediaItemFromPlayQueue({
  required PlayQueue playQueue,
}) {
  if (playQueue.index < 0 || playQueue.index >= playQueue.songs.length) {
    return const MediaItem(
      id: '-1',
      album: 'MeloTrip',
      title: 'MeloTrip',
      artist: 'MeloTrip',
      duration: Duration.zero,
      playable: false,
    );
  }

  final song = playQueue.songs[playQueue.index];
  final durationValue = song.duration;
  return MediaItem(
    id: song.id ?? '-1',
    album: song.album,
    title: song.title ?? '',
    artist: song.artist,
    duration: durationValue != null ? Duration(seconds: durationValue) : Duration.zero,
  );
}
