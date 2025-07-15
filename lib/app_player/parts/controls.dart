part of '../player.dart';

extension PlayerControls on AppPlayer {
  Future<void> setShuffleModeEnabled(bool enabled) async =>
      _player.setShuffle(enabled);
  Future<void> setPlaylistMode(PlaylistMode loopMode) async =>
      _player.setPlaylistMode(loopMode);

  Future<void> setVolume(double volume) async => _player.setVolume(volume);

  Future<void> addMediaItem(MediaItem? item) async {
    mediaItem.add(item);
  }
}
