part of '../app.dart';

extension _PlayerListenerLogic on _MyAppState {
  void _initPlayerListeners() async {
    _setPlayerMediaResolver();
    _setScrobbleListener();
    _setPlaylistModeListener();
    _setPlayerErrorListener();
  }

  void _cancelPlayerSubscriptions() {
    _playlistModeSubscription?.cancel();
    _scrobbleSubscription?.cancel();
    _errorSubscription?.cancel();
    _nowPlayingTimer?.cancel();
  }

  void _setPlayerMediaResolver() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    player?.setMediaResolver((song) async {
      final auth = await ref.read(currentUserProvider.future);
      final config = await ref.read(userConfigProvider.future);

      final url =
          '$proxyCacheHost/rest/stream?id=${song.id}&u=${auth?.username}&t=${auth?.token}&s=${auth?.salt}&_=${DateTime.now().toIso8601String()}&f=json&v=1.8.0&c=MeloTrip&maxBitRate=${config?.maxRate}';

      return Media(url, extras: {'song': song});
    });
  }

  void _setPlaylistModeListener() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    _playlistModeSubscription = player?.playlistModeStream.listen((mode) {
      final config = ref.read(userConfigProvider.notifier);
      config.setConfiguration(playlistMode: ValueUpdater(mode));
    });
  }

  void _setScrobbleListener() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) return;

    _scrobbleSubscription =
        CombineLatestStream.combine2(
          player.playQueueStream,
          player.playingStream,
          (queue, playing) => (queue, playing),
        ).listen((data) async {
          final queue = data.$1;
          final playing = data.$2;

          if (queue.songs.isEmpty) return;
          final currentSong = queue.songs[queue.index];
          final currentId = currentSong.id;

          final api = await ref.read(apiProvider.future);
          final now = DateTime.now();

          // --- 核心秒表逻辑 ---
          if (_lastStateChangeTime != null && _wasPlaying) {
            _activeDuration += now.difference(_lastStateChangeTime!);
          }

          // 场景 A：切换了歌曲 (ID 变化)
          if (_lastProcessedId != currentId) {
            // 1. 尝试结算上一曲 (90% + 30秒 判定)
            if (_lastProcessedId != null && _lastSongDuration != null) {
              if (_activeDuration.inSeconds >= 30 &&
                  _activeDuration.inSeconds >= _lastSongDuration! * 0.9) {
                api.get(
                  '/rest/scrobble',
                  queryParameters: {
                    'id': _lastProcessedId,
                    'time': now.millisecondsSinceEpoch,
                    'submission': true,
                  },
                );
              }
            }

            // 2. 重置秒表状态
            _lastProcessedId = currentId;
            _lastSongDuration = currentSong.duration?.toDouble();
            _activeDuration = Duration.zero;
            _nowPlayingTimer?.cancel();
            _updateMediaItem(player);
          }

          // 更新状态，供下一段计时使用
          _lastStateChangeTime = now;
          _wasPlaying = playing;

          // --- Now Playing 防抖逻辑 (维持 10s) ---
          if (playing) {
            if (_nowPlayingTimer == null || !_nowPlayingTimer!.isActive) {
              _nowPlayingTimer = Timer(const Duration(seconds: 10), () {
                if (player.playing && _lastProcessedId != null) {
                  api.get(
                    '/rest/scrobble',
                    queryParameters: {
                      'id': _lastProcessedId,
                      'submission': false,
                    },
                  );
                }
              });
            }
          } else {
            _nowPlayingTimer?.cancel();
          }
        });
  }

  void _setPlayerErrorListener() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    _errorSubscription = player?.errorStream.listen(
      (err) => _onErrorScanfoldMessage(errorMsg: err),
    );
  }

  Future<void> _updateMediaItem(AppPlayer player) async {
    final playQueue = player.playQueue;
    final noTitle = AppLocalizations.of(context)?.noTitle;
    final api = await ref.read(apiProvider.future);

    if (playQueue.index >= playQueue.songs.length) {
      const item = MediaItem(
        id: '-1',
        album: 'MeloTrip',
        title: 'MeloTrip',
        artist: 'MeloTrip',
        duration: Duration.zero,
        playable: false,
      );
      player.addMediaItem(item);
      api.get('/rest/savePlayQueue');
      return;
    }

    final auth = await ref.read(currentUserProvider.future);
    final song = playQueue.songs[playQueue.index];
    final url =
        '$proxyCacheHost/rest/getCoverArt?id=${song.id}&u=${auth?.username}&t=${auth?.token}&s=${auth?.salt}&_=${DateTime.now().toIso8601String()}&f=json&v=1.8.0&c=MeloTrip';

    final durationValue = song.duration;
    final item = MediaItem(
      id: song.id ?? '-1',
      album: song.album,
      title: song.title ?? noTitle ?? '',
      artist: song.artist,
      duration: durationValue != null
          ? Duration(seconds: durationValue)
          : Duration.zero,
      artUri: Uri.parse(url),
    );

    player.addMediaItem(item);
    final ids = playQueue.songs.map((e) => 'id=${e.id}').join('&');
    api.get('/rest/savePlayQueue?$ids&current=${item.id}');
  }
}
