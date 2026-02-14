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
    _playQueueSubscription = player?.playQueueStream.listen(
      (_) => _updateMediaItem(player),
    );
  }

  void _setPositionListener() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    _positionSubscription = player?.positionStream.listen(
      (pos) => _updateScrolling(player, pos),
    );
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

  Future<void> _updateScrolling(AppPlayer player, Duration position) async {
    if (_nowPlaying && _submission && position.inSeconds < 1) {
      _nowPlaying = false;
      _submission = false;
    } else if (!_nowPlaying && position.inSeconds > 1) {
      _nowPlaying = true;
      final playQueue = player.playQueue;
      if (playQueue.songs.isEmpty) return;

      final api = await ref.read(apiProvider.future);
      api.get(
        '/rest/scrobble',
        queryParameters: {
          'id': playQueue.songs[playQueue.index].id,
          'submission': false,
        },
      );
    } else if (!_submission &&
        position.inSeconds > (player.duration?.inSeconds ?? 0) * 2 / 3) {
      _submission = true;
      if (player.playQueue.songs.isEmpty) return;

      final api = await ref.read(apiProvider.future);
      api.get(
        '/rest/scrobble',
        queryParameters: {
          'id': player.playQueue.songs[player.playQueue.index].id,
          'time': DateTime.now().millisecondsSinceEpoch,
          'submission': true,
        },
      );
      ref
          .read(smartSuggestionProvider.notifier)
          .playHistory(
            song: player.playQueue.songs[player.playQueue.index],
            isComplted: true,
          );
    }
  }
}
