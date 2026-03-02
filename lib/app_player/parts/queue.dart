part of '../player.dart';

extension PlayerQueue on AppPlayer {
  Future<void> setPlaylist({
    required List<SongEntity> songs,
    String? initialId,
  }) {
    return _runSerialized(() async {
      final filterdSongs = songs
          .where((e) => e.id != '' && e.id != null)
          .toList();
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
    });
  }

  Future<int> _insertToNextInternal(SongEntity song) async {
    final index = playQueue.songs.indexWhere((e) => e.id == song.id);
    if (index != -1) {
      return index;
    }
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

  Future<int> insertToNext(SongEntity song) {
    return _runSerialized(() => _insertToNextInternal(song));
  }

  Future<void> insertAndPlay(SongEntity song) {
    return _runSerialized(() async {
      final index = await _insertToNextInternal(song);
      if (index < 0) return;
      await _player.jump(index);
      await _player.play();
    });
  }

  Future<void> insertToEnd(SongEntity song) {
    return _runSerialized(() async {
      final songIndex = playQueue.songs.indexWhere((e) => e.id == song.id);
      if (songIndex == -1) {
        final effectiveMediaResolver = _mediaResolver;
        if (effectiveMediaResolver != null) {
          final media = await effectiveMediaResolver(song);
          await _player.add(media);
        }
      }
    });
  }
}
