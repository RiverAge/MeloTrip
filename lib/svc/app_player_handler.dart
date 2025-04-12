import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/svc/http.dart';

class AppPlayerHandler {
  static Completer<AppPlayerHandler>? _completer;

  final AppPlayer _player;

  AppPlayer get player {
    return _player;
  }

  AppPlayerHandler._({required AppPlayer player}) : _player = player;

  static Future<AppPlayerHandler> get instance async {
    if (_completer == null) {
      final completer = Completer<AppPlayerHandler>();
      _completer = completer;

      final res = await AudioService.init(
        builder: () => AppPlayer(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.meme.melotrip.audio',
          androidNotificationChannelName: 'Audio Service Demo',
          androidNotificationOngoing: true,
        ),
      );
      final instance = AppPlayerHandler._(player: res);
      completer.complete((instance));
    }

    return _completer!.future;
  }
}

class AppPlayer extends BaseAudioHandler {
  final _player = AudioPlayer();

  Future<bool> _isCurrentStarred() async {
    final song = _currentSong;
    if (song == null) return false;
    final res = await Http.get<Map<String, dynamic>>(
      '/rest/getSong',
      queryParameters: {'id': song.id},
    );
    final data = res?.data;
    if (data == null) return false;
    return SubsonicResponse.fromJson(data).subsonicResponse?.song?.starred !=
        null;
  }

  Future<void> _playbackEventStreamListener(PlaybackEvent evt) async {
    final starred = await _isCurrentStarred();
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          MediaControl.custom(
            androidIcon:
                'drawable/media_contrl_favorite${starred ? '_fill' : ''}',
            label: 'favorite',
            name: 'favorite',
            extras: <String, dynamic>{'starred': starred},
          ),
          MediaControl.skipToPrevious,
          if (_player.playing) MediaControl.pause else MediaControl.play,
          // MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState:
            const {
              ProcessingState.idle: AudioProcessingState.idle,
              ProcessingState.loading: AudioProcessingState.loading,
              ProcessingState.buffering: AudioProcessingState.buffering,
              ProcessingState.ready: AudioProcessingState.ready,
              ProcessingState.completed: AudioProcessingState.completed,
            }[_player.processingState]!,
        playing: _player.playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
      ),
    );
  }

  // 播放列表或者当前的播放项目变化时
  // 同步后台播放队列
  // 同步App播放通知
  Future<void> _sequenceStateStreamListener(SequenceState? state) async {
    final index = state?.currentIndex;
    final songs = playlist;
    if (index == null || songs == null || index >= songs.length) {
      const item = MediaItem(
        id: '-1',
        album: 'MeloTrip',
        title: 'MeloTrip',
        artist: 'MeloTrip',
        duration: Duration.zero,
        playable: false,
      );
      mediaItem.add(item);
      Http.get('/rest/savePlayQueue?id=');
      return;
    }
    final song = songs[index];

    final url = await buildSubsonicUrl(
      '/rest/getCoverArt?id=${song.id}',
      proxy: true,
    );
    final duartion = song.duration;
    final item = MediaItem(
      id: song.id ?? '-1',
      album: song.album,
      title: song.title ?? '没有标题',
      artist: song.artist,
      duration: duartion != null ? Duration(seconds: duartion) : Duration.zero,
      artUri: Uri.parse(url),
    );

    mediaItem.add(item);

    final ids = songs.map((e) => 'id=${e.id}').join('&');
    Http.get('/rest/savePlayQueue?$ids&current=${item.id}');
    // _updateScroll();
  }

  _playerStateStream(PlayerState state) {
    if (state.playing && state.processingState == ProcessingState.completed) {
      _player.stop();
    }
  }

  // 返回 true 需要过滤掉
  bool _distincSequenceStateStream(SequenceState? v1, SequenceState? v2) {
    if (v1?.currentIndex != v2?.currentIndex) return false;

    final prevSequence = v1?.sequence, currSequence = v2?.sequence;
    if (prevSequence != null && currSequence != null) {
      if (prevSequence.length != currSequence.length) {
        return false;
      }
      return List.generate(
        prevSequence.length,
        (idx) => idx,
      ).every((e) => prevSequence[e] == currSequence[e]);
    }
    if (prevSequence == currSequence) {
      return true;
    }
    return false;
  }

  // Future<void> _updateScroll() async {
  //   if (!_player.playing) return;
  //   final songs = playlist;
  //   final index = currentIndex;
  //   if (index == null || songs == null || index >= songs.length) return;
  //   final song = songs[index];
  //   final id = song.id;
  //   if (id == null) return;
  //   Http.get('/rest/scrobble', queryParameters: {
  //     'id': id,
  //     'time': DateTime.now().millisecondsSinceEpoch,
  //     'submission': false
  //   });
  // }

  AppPlayer() {
    _player.playbackEventStream.listen(_playbackEventStreamListener);
    _player.sequenceStateStream
        .distinct(_distincSequenceStateStream)
        .listen(_sequenceStateStreamListener);
    _player.playerStateStream.listen(_playerStateStream);

    _player.setLoopMode(LoopMode.all);
    _player.setShuffleModeEnabled(false);
    // _player.playingStream.listen((playing) => _updateScroll());
  }

  List<SongEntity>? get playlist {
    final audioSource = _player.audioSource;
    if (audioSource == null) return null;
    if (audioSource is! ConcatenatingAudioSource) return null;
    List<AudioSource> sources = audioSource.children;
    if (sources.isEmpty) return null;
    final isUriAudioSource = sources.every(((e) => e is UriAudioSource));
    if (!isUriAudioSource) return null;
    final songs =
        sources.map((e) => (e as UriAudioSource).tag as SongEntity).toList();
    return songs;
  }

  Future<void> setPlaylist({
    required List<SongEntity> songs,
    String? initialId,
    Duration? initialPosition,
  }) async {
    final filterdSongs =
        songs.where((e) => e.id != '' && e.id != null).toList();
    if (filterdSongs.isEmpty) return;
    final initialIndex = filterdSongs.indexWhere((e) => e.id == initialId);

    // 是否同一播放列表
    if (filterdSongs.length == _player.sequence?.length &&
        List.generate(filterdSongs.length, (idx) => idx).every(
          (idx) =>
              filterdSongs[idx].id ==
              (_player.sequence?[idx].tag as SongEntity?)?.id,
        )) {
      await skipToQueueItem(0);
    } else {
      final streamUrl = await buildSubsonicUrl('/rest/stream', proxy: true);

      final src = ConcatenatingAudioSource(
        useLazyPreparation: true,
        shuffleOrder: DefaultShuffleOrder(),
        children:
            filterdSongs
                .map(
                  (e) => AudioSource.uri(
                    Uri.parse('$streamUrl&id=${e.id}'),
                    tag: e,
                  ),
                )
                .toList(),
      );
      await _player.stop();

      final effectiveInitialIndex =
          src.length > 0 && initialIndex == -1 ? 0 : initialIndex;

      await _player.setAudioSource(
        src,
        initialIndex: effectiveInitialIndex,
        initialPosition: initialPosition,
      );
    }
  }

  Future<void> addSongToPlaylist(
    SongEntity song, {
    bool? needPlay,
    bool? isNext,
  }) async {
    final currentPlaylist = playlist;
    if (currentPlaylist == null) {
      await setPlaylist(songs: [song], initialId: song.id);
    } else {
      final index = currentPlaylist.indexWhere((e) => e.id == song.id);
      if (index != -1) {
        if (needPlay == true) {
          await skipToQueueItem(index);
        }
      } else {
        if (needPlay == true || isNext == true) {
          final insertIndex = (currentIndex ?? 0) + 1;
          await addPlaylistItem(song, insertIndex);
          // 向播放列表加入一个新的歌曲，它对应当前播放歌曲的索引会发生变化
          if (needPlay == true) {
            await skipToQueueItem(insertIndex);
          }
        } else {
          await addPlaylistItem(song, currentPlaylist.length);
        }
      }
    }
    if (needPlay == true) {
      await play();
    }
  }

  bool get playing => _player.playing;
  Duration? get duration => _player.duration;
  Duration get position => _player.position;
  Duration get bufferedPosition => _player.bufferedPosition;
  PlayerState get playerState => _player.playerState;
  ProcessingState get processingState => _player.processingState;
  int? get currentIndex => _player.currentIndex;
  LoopMode get loopMode => _player.loopMode;
  List<SongEntity?>? get sequence =>
      _player.sequence?.map((e) => e.tag as SongEntity).toList();
  List<int>? get shuffleIndices => _player.shuffleIndices;
  bool get shuffleModeEnabled => _player.shuffleModeEnabled;
  SequenceState? get sequenceState => _player.sequenceState;

  SongEntity? get _currentSong =>
      _player.sequenceState?.currentSource?.tag as SongEntity?;

  // Future<void> shuffle() async => _player.shuffle();

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  Stream<Duration> get bufferedPositionStream => _player.bufferedPositionStream;
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<int?> get currentIndexStream => _player.currentIndexStream;
  Stream<List<SongEntity?>?> get sequenceStream => _player.sequenceStream.map(
    (e) => e?.map((s2) => (s2.tag as SongEntity?)).toList(),
  );
  Stream<bool> get playingStream => _player.playingStream;
  Stream<SequenceState?> get sequenceStateStream => _player.sequenceStateStream;
  Stream<bool> get shuffleModeEnabledStream => _player.shuffleModeEnabledStream;
  Stream<LoopMode> get loopModeStream => _player.loopModeStream;

  Future<void> setShuffleModeEnabled(bool enabled) async =>
      _player.setShuffleModeEnabled(enabled);

  Future<void> setLoopMode(LoopMode loopMode) async =>
      _player.setLoopMode(loopMode);

  Future<void> addPlaylistItem(SongEntity song, int index) async {
    final concatenatingAudioSource = _player.audioSource;
    if (concatenatingAudioSource is ConcatenatingAudioSource) {
      final streamUrl = await buildSubsonicUrl('/rest/stream', proxy: true);
      final audioSource = AudioSource.uri(
        Uri.parse('$streamUrl&id=${song.id}'),
        tag: song,
      );
      await concatenatingAudioSource.insert(index, audioSource);
    }
  }

  // The most common callbacks:
  @override
  Future<void> play() async => _player.play();

  @override
  Future<void> pause() async => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> skipToPrevious() async => _player.seekToPrevious();

  @override
  Future<void> skipToNext() async => _player.seekToNext();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    _player.setShuffleModeEnabled(shuffleMode == AudioServiceShuffleMode.all);
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    final concatenatingAudioSource = _player.audioSource;
    if (concatenatingAudioSource is ConcatenatingAudioSource) {
      concatenatingAudioSource.removeAt(index);
    }
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    if (repeatMode == AudioServiceRepeatMode.all) {
      _player.setLoopMode(LoopMode.all);
    } else if (repeatMode == AudioServiceRepeatMode.none) {
      _player.setLoopMode(LoopMode.off);
    } else if (repeatMode == AudioServiceRepeatMode.one) {
      _player.setLoopMode(LoopMode.one);
    }
  }

  @override
  Future<void> skipToQueueItem(int index) =>
      _player.seek(Duration.zero, index: index);

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'favorite') {
      final song = _currentSong;
      final songId = song?.id;
      final starred = extras?['starred'];
      if (songId == null) return;

      await Http.get(
        '/rest/${starred == "true" ? 'unstar' : 'star'}',
        queryParameters: {'id': songId},
      );
      _playbackEventStreamListener(_player.playbackEvent);
    }
    return super.customAction(name, extras);
  }
}
