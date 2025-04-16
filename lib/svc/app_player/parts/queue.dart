part of '../player_handler.dart';

extension PlayerQueue on AppPlayer {
  Future<void> setPlaylist({
    required List<SongEntity> songs,
    String? initialId,
  }) async {
    final filterdSongs =
        songs.where((e) => e.id != '' && e.id != null).toList();
    final initialIndex = filterdSongs.indexWhere((e) => e.id == initialId);
    final streamUrl = await buildSubsonicUrl('/rest/stream', proxy: true);
    final playable =
        filterdSongs
            .map((e) => Media('$streamUrl&id=${e.id}', extras: {'song': e}))
            .toList();
    final effectiveInitialIndex = initialIndex == -1 ? 0 : initialIndex;
    await _player.open(
      Playlist(playable, index: effectiveInitialIndex),
      play: false,
    );
  }

  Future<int> insertToNext(SongEntity song) async {
    final songIndex = playQueue.songs.indexWhere((e) => e.id == song.id);
    final dstIndex = playQueue.songs.isEmpty ? 0 : playQueue.index + 1;

    if (songIndex == -1) {
      final streamUrl = await buildSubsonicUrl(
        '/rest/stream?id=${song.id}',
        proxy: true,
      );
      await _player.add(Media(streamUrl, extras: {'song': song}));
    }
    final srcIndex =
        songIndex == -1 ? _player.state.playlist.medias.length - 1 : songIndex;

    await _player.move(srcIndex, dstIndex);

    return dstIndex;
  }

  Future<void> insertAndPlay(SongEntity song) async {
    final index = await insertToNext(song);
    await _player.jump(index);
    await _player.play();
  }

  Future<void> insertToEnd(SongEntity song) async {
    final songIndex = playQueue.songs.indexWhere((e) => e.id == song.id);
    if (songIndex == -1) {
      final streamUrl = await buildSubsonicUrl(
        '/rest/stream?id=${song.id}',
        proxy: true,
      );
      await _player.add(Media(streamUrl, extras: {'song': song}));
    }
  }
}
