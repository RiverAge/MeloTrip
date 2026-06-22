import 'package:melo_trip/model/recommendation/seed_source.dart';
import 'package:melo_trip/model/recommendation/weighted_seed.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlist_weighted_seeds.g.dart';

List<PlaylistEntity> selectPlaylistSeedCandidates(
  Iterable<PlaylistEntity> playlists, {
  int maxPlaylists = 3,
}) {
  final candidates = playlists
      .where((playlist) => playlist.id != null && playlist.id!.isNotEmpty)
      .toList();

  candidates.sort((a, b) {
    final changedCompare = _dateMillis(
      b.changed,
    ).compareTo(_dateMillis(a.changed));
    if (changedCompare != 0) return changedCompare;
    return (b.songCount ?? 0).compareTo(a.songCount ?? 0);
  });

  return candidates.take(maxPlaylists).toList();
}

List<String> extractPlaylistSeedSongIds(
  Iterable<PlaylistEntity> playlists, {
  int maxSeeds = 8,
}) {
  final entries = playlists
      .map((playlist) => playlist.entry ?? const <SongEntity>[])
      .where((songs) => songs.isNotEmpty)
      .toList();
  final result = <String>[];
  final seen = <String>{};

  for (var songIndex = 0; result.length < maxSeeds; songIndex++) {
    var addedInRound = false;

    for (final songs in entries) {
      if (result.length >= maxSeeds) break;
      if (songIndex >= songs.length) continue;

      final id = songs[songIndex].id;
      if (id == null || id.isEmpty || seen.contains(id)) continue;

      result.add(id);
      seen.add(id);
      addedInRound = true;
    }

    if (!addedInRound) break;
  }

  return result;
}

List<WeightedSeed> convertPlaylistSeedsToWeighted(Iterable<String> songIds) {
  return songIds
      .map(
        (songId) => WeightedSeed(
          songId: songId,
          source: SeedSource.playlist,
          weight: 0.7,
          reason: 'playlist',
        ),
      )
      .toList();
}

@riverpod
Future<List<WeightedSeed>> playlistWeightedSeeds(
  Ref ref, {
  int maxPlaylists = 3,
  int maxSeeds = 8,
}) async {
  final playlistsResult = await ref.watch(playlistsProvider.future);
  final playlists = playlistsResult.when(
    ok: (items) => items,
    err: (_) => const <PlaylistEntity>[],
  );
  if (playlists.isEmpty) {
    return const <WeightedSeed>[];
  }

  final candidates = selectPlaylistSeedCandidates(
    playlists,
    maxPlaylists: maxPlaylists,
  );
  final details = <PlaylistEntity>[];

  for (final playlist in candidates) {
    if (playlist.entry != null && playlist.entry!.isNotEmpty) {
      details.add(playlist);
      continue;
    }

    final id = playlist.id;
    if (id == null || id.isEmpty) continue;

    final result = await ref.watch(playlistDetailProvider(id).future);
    result?.when(ok: details.add, err: (_) {});
  }

  final songIds = extractPlaylistSeedSongIds(details, maxSeeds: maxSeeds);
  return convertPlaylistSeedsToWeighted(songIds);
}

int _dateMillis(DateTime? value) => value?.millisecondsSinceEpoch ?? 0;
