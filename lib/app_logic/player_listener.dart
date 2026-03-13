part of '../app.dart';

extension _PlayerListenerLogic on _MyAppState {
  void _initPlayerListeners() {
    _setPlayerMediaResolver();
    _setScrobbleListener();
    _setPlaylistModeListener();
    _setPlayerErrorListener();

    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      _setDesktopLyricsListener();
    }
  }

  void _cancelPlayerSubscriptions() {
    _playlistModeSubscription?.cancel();
    _errorSubscription?.cancel();
    unawaited(_playerScrobbleBindings?.cancel());
    unawaited(_desktopLyricsBindings?.cancel());
  }

  void _setPlayerMediaResolver() async {
    await ref.read(playerMediaResolverRuntimeProvider).attach(ref);
  }

  void _setPlaylistModeListener() async {
    _playlistModeSubscription = await ref
        .read(playerPlaylistModeRuntimeProvider)
        .attach(ref);
  }

  void _setScrobbleListener() async {
    _playerScrobbleBindings = await ref
        .read(playerScrobbleRuntimeProvider)
        .attach(ref);
  }

  void _setPlayerErrorListener() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    _errorSubscription = player?.errorStream.listen(
      (err) => ref.read(appErrorProvider.notifier).emit(err),
    );
  }

  void _setDesktopLyricsListener() async {
    _desktopLyricsBindings = await ref
        .read(desktopLyricsRuntimeProvider)
        .attach(ref);
  }
}
