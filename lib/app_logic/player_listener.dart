part of '../app.dart';

extension _PlayerListenerLogic on _MyAppState {
  void _initPlayerListeners() async {
    _setPlayerMediaResolver();
    _setScrobbleListener();
    _setPlaylistModeListener();
    _setPlayerErrorListener();
    _setDesktopLyricsListeners();
  }

  void _cancelPlayerSubscriptions() {
    _playlistModeSubscription?.cancel();
    _scrobbleSubscription?.cancel();
    _errorSubscription?.cancel();
    _desktopLyricsTrackSubscription?.cancel();
    _desktopLyricsProgressSubscription?.cancel();
    _nowPlayingTimer?.cancel();
    unawaited(ref.read(desktopLyricsServiceProvider).dispose());
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
            _savePlayQueue(player, api);
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

  void _setDesktopLyricsListeners() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) return;

    final lyricsService = ref.read(desktopLyricsServiceProvider);
    await _syncDesktopLyricsConfig();
    String? lastSongId;

    _desktopLyricsTrackSubscription = player.playQueueStream.listen((queue) async {
      if (queue.songs.isEmpty || queue.index < 0 || queue.index >= queue.songs.length) {
        await lyricsService.hide();
        return;
      }

      final song = queue.songs[queue.index];
      if (song.id == lastSongId) return;
      lastSongId = song.id;

      final lyricsResponse = await ref.read(lyricsProvider(song.id).future);
      final lines =
          lyricsResponse?.subsonicResponse?.lyricsList?.structuredLyrics?.firstOrNull?.line ??
          const <Line>[];
      final lyricLines = lines
          .map(
            (line) => DesktopLyricsLine(
              startMs: line.start ?? 0,
              values: line.value ?? const <String>[],
            ),
          )
          .toList();

      await lyricsService.updateTrack(
        songId: song.id,
        title: song.title,
        artist: song.displayArtist,
        lines: lyricLines,
      );
      await lyricsService.show();
    });

    _desktopLyricsProgressSubscription = CombineLatestStream.combine2(
      player.positionStream,
      player.durationStream,
      (position, duration) => (position, duration),
    ).listen((data) async {
      await lyricsService.updateProgress(
        position: data.$1,
        duration: data.$2,
      );
    });
  }

  Future<void> _syncDesktopLyricsConfig() async {
    final service = ref.read(desktopLyricsServiceProvider);
    await service.updateConfig(
      const DesktopLyricsConfig(
      enabled: true,
      clickThrough: false,
      fontSize: 34,
      opacity: .93,
      textColorArgb: 0xFFF2F2F8,
      shadowColorArgb: 0xFF121214,
      strokeColorArgb: 0x00000000,
      strokeWidth: 0,
      ),
    );
  }

  void _savePlayQueue(AppPlayer player, dynamic api) {
    final playQueue = player.playQueue;
    if (playQueue.index >= playQueue.songs.length) {
      api.get('/rest/savePlayQueue');
      return;
    }
    final currentSong = playQueue.songs[playQueue.index];
    final ids = playQueue.songs.map((e) => 'id=${e.id}').join('&');
    api.get('/rest/savePlayQueue?$ids&current=${currentSong.id}');
  }
}
