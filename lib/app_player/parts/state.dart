part of '../player.dart';

extension PlayerState on AppPlayer {
  bool get playing => _player.state.playing;

  Duration? get duration => _player.state.duration;
  Duration get position => _player.state.position;
  Duration get buffer => _player.state.buffer;
  double get rate => _player.state.rate;
  PlaylistMode get playlistMode => _player.state.playlistMode;
  double get volume => _player.state.volume;
  AudioParams get audioParams => _player.state.audioParams;
  Track get track => _player.state.track;
  Tracks get tracks => _player.state.tracks;

  bool get shuffle => _player.state.shuffle;

  // Future<List<TrackEntity>?> get track async {
  //   final platform = _player.platform;
  //   if (platform is NativePlayer) {
  //     final ret = await platform.getProperty('track-list');
  //     final List list = jsonDecode(ret);
  //     return list.map((e) => TrackEntity.fromJson(e)).toList();
  //   } else {
  //     return null;
  //   }
  // }

  PlayQueue get playQueue => PlayQueue(
    songs: _player.state.playlist.medias
        .map((s) => s.extras?['song'] as SongEntity? ?? SongEntity())
        .toList(),
    index: _player.state.playlist.index,
  );
}
