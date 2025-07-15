part of '../player.dart';

extension PlayerState on AppPlayer {
  bool get playing => _player.state.playing;
  Future<void> playOrPause() => _player.playOrPause();
  Duration? get duration => _player.state.duration;
  Duration get position => _player.state.position;
  Duration get buffer => _player.state.buffer;
  double get rate => _player.state.rate;
  PlaylistMode get playlistMode => _player.state.playlistMode;
  double get volume => _player.state.volume;

  PlayQueue get playQueue => PlayQueue(
    songs:
        _player.state.playlist.medias
            .map((s) => s.extras?['song'] as SongEntity? ?? SongEntity())
            .toList(),
    index: _player.state.playlist.index,
  );
}
