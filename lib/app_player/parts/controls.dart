part of '../player.dart';

extension PlayerControls on AppPlayer {
  Future<void> setShuffleModeEnabled(bool enabled) =>
      _runSerialized(() => _player.setShuffle(enabled));

  Future<void> setPlaylistMode(PlaylistMode loopMode) =>
      _runSerialized(() => _player.setPlaylistMode(loopMode));

  Future<void> playOrPause() => _runSerialized(() async {
    final session = await AudioSession.instance;
    await session.setActive(
      true,
      androidAudioFocusGainType: .gain,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: .music,
        usage: .media,
      ),
      androidWillPauseWhenDucked: true,
    );
    await _player.playOrPause();
  });

  Future<void> playOrToggleFromSongTap(SongEntity song) async {
    await dispatchSongTapPlayback(
      playQueue: playQueue,
      song: song,
      onToggleCurrent: playOrPause,
      onPlayTarget: insertAndPlay,
    );
  }

  Future<void> setVolume(double volume) async => _player.setVolume(volume);

  Future<void> addMediaItem(MediaItem? item) async {
    mediaItem.add(item);
  }
}

bool isCurrentSongTap({
  required PlayQueue playQueue,
  required SongEntity song,
}) {
  final currentIndex = playQueue.index;
  if (currentIndex < 0 || currentIndex >= playQueue.songs.length) {
    return false;
  }
  return playQueue.songs[currentIndex].id == song.id;
}

Future<void> dispatchSongTapPlayback({
  required PlayQueue playQueue,
  required SongEntity song,
  required Future<void> Function() onToggleCurrent,
  required Future<void> Function(SongEntity song) onPlayTarget,
}) async {
  if (isCurrentSongTap(playQueue: playQueue, song: song)) {
    await onToggleCurrent();
  } else {
    await onPlayTarget(song);
  }
}
