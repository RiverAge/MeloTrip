part of '../app.dart';

extension _PlayerListenerLogic on _MyAppState {
  void _initPlayerListeners() async {
    _setPlayerMediaResolver();
    _setPlayQueueListener();
    _setPlaylistModeListener();
    _setPositionListener();
    _setPlayerErrorListener();
  }

  void _cancelPlayerSubscriptions() {
    _playlistModeSubscription?.cancel();
    _playQueueSubscription?.cancel();
    _positionSubscription?.cancel();
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

  void _setPlayQueueListener() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    _playQueueSubscription = player?.playQueueStream.listen((queue) async {
      if (queue.songs.isEmpty) return;
      final currentSong = queue.songs[queue.index];
      final currentId = currentSong.id;

      if (_lastProcessedId != currentId) {
        final api = await ref.read(apiProvider.future);
        final now = DateTime.now();

        // 1. 尝试结算上一首 (30秒判定)
        if (_lastProcessedId != null && _lastStartTime != null) {
          final duration = now.difference(_lastStartTime!);
          if (duration.inSeconds >= 30) {
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

        // 2. 更新状态，并开启“防抖计时器”
        _lastProcessedId = currentId;
        _lastStartTime = now;

        // 取消之前的待发送计时器
        _nowPlayingTimer?.cancel();

        // 延迟 2 秒发送 Now Playing
        if (currentId != null) {
          _nowPlayingTimer = Timer(const Duration(seconds: 2), () {
            api.get(
              '/rest/scrobble',
              queryParameters: {'id': currentId, 'submission': false},
            );
          });
        }
      }

      _updateMediaItem(player);
    });
  }

  void _setPositionListener() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    _positionSubscription = player?.positionStream.listen((pos) {
      // 后台打卡已迁移至 PlayQueue 监听，此处仅保留对空方法的占位或移除
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
