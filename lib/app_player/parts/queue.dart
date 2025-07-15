part of '../player.dart';

extension PlayerQueue on AppPlayer {
  Future<void> setPlaylist({
    required List<SongEntity> songs,
    String? initialId,
  }) async {
    final filterdSongs =
        songs.where((e) => e.id != '' && e.id != null).toList();
    final initialIndex = filterdSongs.indexWhere((e) => e.id == initialId);
    final effectiveMediaResolver = _mediaResolver;
    if (effectiveMediaResolver != null) {
      final playable = await Future.wait(
        filterdSongs.map((e) => effectiveMediaResolver(e)).toList(),
      );
      final effectiveInitialIndex = initialIndex == -1 ? 0 : initialIndex;
      await _player.open(
        Playlist(playable, index: effectiveInitialIndex),
        play: false,
      );
    }
  }

  Future<int> insertToNext(SongEntity song) async {
    final dstIndex = playQueue.songs.isEmpty ? 0 : playQueue.index + 1;
    final effectiveMediaResolver = _mediaResolver;
    if (effectiveMediaResolver != null) {
      final media = await effectiveMediaResolver(song);
      await _player.add(media);
      await _player.move(playQueue.songs.length - 1, dstIndex);
      return dstIndex;
    }
    return -1;
  }

  Future<void> insertAndPlay(SongEntity song) async {
    final index = await insertToNext(song);
    await _player.jump(index);
    await _player.play();
  }

  Future<void> insertToEnd(SongEntity song) async {
    final songIndex = playQueue.songs.indexWhere((e) => e.id == song.id);
    if (songIndex == -1) {
      final effectiveMediaResolver = _mediaResolver;
      if (effectiveMediaResolver != null) {
        final media = await effectiveMediaResolver(song);
        await _player.add(media);
      }
    }
  }
}
