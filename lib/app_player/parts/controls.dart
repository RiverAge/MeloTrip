part of '../player.dart';

extension PlayerControls on AppPlayer {
  Future<void> setShuffleModeEnabled(bool enabled) async =>
      _player.setShuffle(enabled);
  Future<void> setPlaylistMode(PlaylistMode loopMode) async =>
      _player.setPlaylistMode(loopMode);

  Future<void> playOrPause() async {
    final session = await AudioSession.instance;
    await session.setActive(
      true,
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidAudioAttributes: AndroidAudioAttributes(
        contentType: AndroidAudioContentType.music,
        usage: AndroidAudioUsage.media,
      ),
      androidWillPauseWhenDucked: true,
    );
    return _player.playOrPause();
  }

  Future<void> setVolume(double volume) async => _player.setVolume(volume);

  Future<void> addMediaItem(MediaItem? item) async {
    mediaItem.add(item);
  }
}
