part of '../player_handler.dart';

class AppPlayer extends BaseAudioHandler {
  final _player = Player();
  final BehaviorSubject<Duration> _postionSubject = BehaviorSubject<Duration>();
  final _durationSubject = BehaviorSubject<Duration>();
  final _bufferedPositionSubject = BehaviorSubject<Duration>();
  final _playingSubject = BehaviorSubject<bool>.seeded(false);
  final _playlistModeSubject = BehaviorSubject<PlaylistMode>();
  final _playQueueSubject = BehaviorSubject<PlayQueue>.seeded(
    PlayQueue(songs: [], index: 0),
  );

  var _nowPlaying = true;
  var _submission = true;

  AppPlayer._interal() {
    _init();
  }
  static final AppPlayer _instance = AppPlayer._interal();

  factory AppPlayer() {
    return _instance;
  }

  @override
  Future<void> play() async => _player.play();
  @override
  Future<void> pause() async => _player.pause();
  @override
  Future<void> stop() => _player.stop();
  @override
  Future<void> skipToPrevious() async => _player.previous();
  @override
  Future<void> skipToNext() async => _player.next();
  @override
  Future<void> seek(Duration position) => _player.seek(position);
  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    _player.setShuffle(shuffleMode != AudioServiceShuffleMode.none);
  }

  @override
  Future<void> removeQueueItemAt(int index) async => _player.remove(index);

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    if (repeatMode == AudioServiceRepeatMode.all) {
      await _player.setPlaylistMode(PlaylistMode.loop);
    } else if (repeatMode == AudioServiceRepeatMode.none) {
      await _player.setPlaylistMode(PlaylistMode.none);
    } else if (repeatMode == AudioServiceRepeatMode.one) {
      await _player.setPlaylistMode(PlaylistMode.single);
    }
  }

  @override
  Future<void> skipToQueueItem(int index) => _player.jump(index);
  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'favorite') {
      final song =
          playQueue.songs.isEmpty ? null : playQueue.songs[playQueue.index];
      final songId = song?.id;
      final starred = extras?['starred'];
      if (songId == null) return;

      await Http.get(
        '/rest/${starred == "true" ? 'unstar' : 'star'}',
        queryParameters: {'id': songId},
      );
      // _playbackEventStreamListener(_player.playbackEvent);
      _updateCurrentMediaItemButton();
    }
    return super.customAction(name, extras);
  }

  dispose() {
    _postionSubject.close();
    _durationSubject.close();
    _bufferedPositionSubject.close();
    _playingSubject.close();
    _playlistModeSubject.close();
    _playQueueSubject.close();

    _player.dispose();
  }
}
