import 'package:melo_trip/model/recommendation/seed_source.dart';
import 'package:melo_trip/model/recommendation/weighted_seed.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/artist/artist_detail.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_artist_weighted_seeds.g.dart';

List<String> extractFavoriteArtistSeedSongIds(
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

List<WeightedSeed> convertFavoriteArtistSeedsToWeighted(
  Iterable<String> songIds,
) {
  return songIds
      .map(
        (songId) => WeightedSeed(
          songId: songId,
          source: SeedSource.favoriteArtist,
          weight: 0.78,
          reason: 'favorite_artist',
        ),
      )
      .toList();
}

@riverpod
Future<List<WeightedSeed>> favoriteArtistWeightedSeeds(
  Ref ref, {
  int maxArtists = 2,
  int maxAlbumsPerArtist = 2,
  int maxSeeds = 6,
}) async {
  final favoriteResult = await ref.watch(favoriteProvider.future);
  final artists = favoriteResult.when(
    ok: (SubsonicResponse response) =>
        response.subsonicResponse?.starred?.artist ?? const <ArtistEntity>[],
    err: (_) => const <ArtistEntity>[],
  );

  if (artists.isEmpty) {
    return const <WeightedSeed>[];
  }

  final albumDetails = <AlbumEntity>[];
  for (final artist in artists.take(maxArtists)) {
    final id = artist.id;
    if (id == null || id.isEmpty) continue;

    final result = await ref.watch(artistDetailProvider(id).future);
    final albums =
        result?.when(
          ok: (response) =>
              response.subsonicResponse?.artist?.album ?? const <AlbumEntity>[],
          err: (_) => const <AlbumEntity>[],
        ) ??
        const <AlbumEntity>[];

    for (final album in albums.take(maxAlbumsPerArtist)) {
      if (album.song != null && album.song!.isNotEmpty) {
        albumDetails.add(album);
        continue;
      }

      final albumId = album.id;
      if (albumId == null || albumId.isEmpty) continue;

      final albumResult = await ref.watch(albumDetailProvider(albumId).future);
      albumResult?.when(
        ok: (response) {
          final detail = response.subsonicResponse?.album;
          if (detail != null) {
            albumDetails.add(detail);
          }
        },
        err: (_) {},
      );
    }
  }

  final songIds = extractFavoriteArtistSeedSongIds(
    albumDetails,
    maxSeeds: maxSeeds,
  );
  return convertFavoriteArtistSeedsToWeighted(songIds);
}
