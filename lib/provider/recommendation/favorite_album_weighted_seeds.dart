import 'package:melo_trip/model/recommendation/seed_source.dart';
import 'package:melo_trip/model/recommendation/weighted_seed.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_album_weighted_seeds.g.dart';

List<String> extractFavoriteAlbumSeedSongIds(
  Iterable<AlbumEntity> albums, {
  int maxSeeds = 6,
}) {
  final result = <String>[];
  final seen = <String>{};

  for (final album in albums) {
    final songs = album.song ?? const <SongEntity>[];
    for (final song in songs) {
      if (result.length >= maxSeeds) return result;

      final id = song.id;
      if (id == null || id.isEmpty || seen.contains(id)) continue;

      result.add(id);
      seen.add(id);
    }
  }

  return result;
}

List<WeightedSeed> convertFavoriteAlbumSeedsToWeighted(
  Iterable<String> songIds,
) {
  return songIds
      .map(
        (songId) => WeightedSeed(
          songId: songId,
          source: SeedSource.favoriteAlbum,
          weight: 0.85,
          reason: 'favorite_album',
        ),
      )
      .toList();
}

@riverpod
Future<List<WeightedSeed>> favoriteAlbumWeightedSeeds(
  Ref ref, {
  int maxAlbums = 3,
  int maxSeeds = 6,
}) async {
  final favoriteResult = await ref.watch(favoriteProvider.future);
  final albums = favoriteResult.when(
    ok: (SubsonicResponse response) =>
        response.subsonicResponse?.starred?.album ?? const <AlbumEntity>[],
    err: (_) => const <AlbumEntity>[],
  );

  if (albums.isEmpty) {
    return const <WeightedSeed>[];
  }

  final albumDetails = <AlbumEntity>[];
  for (final album in albums.take(maxAlbums)) {
    if (album.song != null && album.song!.isNotEmpty) {
      albumDetails.add(album);
      continue;
    }

    final id = album.id;
    if (id == null || id.isEmpty) continue;

    final result = await ref.watch(albumDetailProvider(id).future);
    result?.when(
      ok: (response) {
        final detail = response.subsonicResponse?.album;
        if (detail != null) {
          albumDetails.add(detail);
        }
      },
      err: (_) {},
    );
  }

  final songIds = extractFavoriteAlbumSeedSongIds(
    albumDetails,
    maxSeeds: maxSeeds,
  );
  return convertFavoriteAlbumSeedsToWeighted(songIds);
}
