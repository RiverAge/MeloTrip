import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_recommendation_seeds.g.dart';

/// Pure function for extracting seed song IDs from favorite songs.
///
/// Filters out:
/// - null ids
/// - empty string ids
/// - duplicate ids (keeps first occurrence)
///
/// Preserves order from the input list.
/// Returns at most [maxSeeds] ids.
List<String> extractFavoriteSeedSongIds(
  Iterable<SongEntity> songs, {
  int maxSeeds = 5,
}) {
  final result = <String>[];
  final seen = <String>{};

  for (final song in songs) {
    if (result.length >= maxSeeds) break;

    final id = song.id;
    if (id == null || id.isEmpty) continue;
    if (seen.contains(id)) continue;

    result.add(id);
    seen.add(id);
  }

  return result;
}

/// Provider for extracting recommendation seeds from favorite songs.
///
/// Reads from favoriteProvider and extracts song IDs to use as seeds
/// for the recommendations system.
///
/// - Returns empty list if favoriteProvider returns error or no songs.
/// - Does NOT read play history or ratings.
/// - Does NOT write to database.
@riverpod
Future<List<String>> favoriteRecommendationSeeds(
  Ref ref, {
  int maxSeeds = 5,
}) async {
  final favoriteResult = await ref.watch(favoriteProvider.future);

  return favoriteResult.when(
    ok: (SubsonicResponse response) {
      final songs = response.subsonicResponse?.starred?.song;
      if (songs == null || songs.isEmpty) {
        return <String>[];
      }
      return extractFavoriteSeedSongIds(songs, maxSeeds: maxSeeds);
    },
    err: (_) => <String>[],
  );
}
