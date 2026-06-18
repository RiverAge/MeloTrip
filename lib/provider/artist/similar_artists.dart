import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/repository/artist/artist_detail_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'similar_artists.g.dart';

/// Provider for fetching similar artists based on an artist ID.
///
/// This provider calls Navidrome's getArtistInfo2 endpoint to get
/// similar artists recommendations.
///
/// Behavior:
/// - Returns empty list if artistId is null or empty.
/// - Returns empty list if the API returns no similar artists.
/// - Returns empty list on error (does not throw).
/// - Does NOT fallback to external links or getSimilarSongs2.
/// - Does NOT cache results to local database.
@riverpod
Future<List<ArtistEntity>> similarArtists(
  Ref ref, {
  required String? artistId,
  int count = 12,
}) async {
  // Return empty list for null or empty artistId
  if (artistId == null || artistId.isEmpty) {
    return <ArtistEntity>[];
  }

  final repository = ref.watch(artistDetailRepositoryProvider);
  final result = await repository.tryFetchArtistInfo2(
    artistId: artistId,
    count: count,
  );

  return result.when(
    ok: (response) {
      final similarArtists =
          response.subsonicResponse?.artistInfo2?.similarArtist;
      if (similarArtists == null || similarArtists.isEmpty) {
        return <ArtistEntity>[];
      }
      return similarArtists;
    },
    err: (_) => <ArtistEntity>[],
  );
}
