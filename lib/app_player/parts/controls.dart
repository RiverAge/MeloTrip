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
    final playQueue = this.playQueue;
    final currentSong = playQueue.index >= playQueue.songs.length
        ? null
        : playQueue.songs[playQueue.index];
    if (currentSong?.id == song.id) {
      await playOrPause();
    } else {
      await insertAndPlay(song);
    }
  }

  Future<void> setVolume(double volume) async => _player.setVolume(volume);

  Future<void> addMediaItem(MediaItem? item) async {
    mediaItem.add(item);
  }
}
