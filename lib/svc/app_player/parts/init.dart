part of '../player_handler.dart';

extension PlayerInit on AppPlayer {
  _init() async {
    final user = await User.instance;
    _player.setPlaylistMode(user.playlistMode);
    _player.stream.completed.listen((_) => _updateCurrentMediaItemButton());
    _player.stream.rate.listen((_) => _updateCurrentMediaItemButton());
    _player.stream.buffer.listen((_) => _updateCurrentMediaItemButton());
    // 光年之外的 pos 是负数
    _player.stream.position.listen((pos) {
      _updateScrolling(pos);
      _postionSubject.add(pos.isNegative ? Duration.zero : pos);
    });
    _player.stream.duration.listen(_durationSubject.add);
    _player.stream.buffer.listen(_bufferedPositionSubject.add);
    _player.stream.playing.listen((data) {
      _updateCurrentMediaItemButton();
      _playingSubject.add(data);
    });
    _player.stream.playlistMode.listen((data) {
      user.playlistMode = data;
      _playlistModeSubject.add(data);
    });
    _player.stream.volume.listen(_volumeSubject.add);
    _player.stream.playlist.listen((e) {
      _updateMediaItem();
      _playQueueSubject.add(
        PlayQueue(
          songs:
              e.medias
                  .map((s) => s.extras?['song'] as SongEntity? ?? SongEntity())
                  .toList(),
          index: e.index,
        ),
      );
    });
  }
}
