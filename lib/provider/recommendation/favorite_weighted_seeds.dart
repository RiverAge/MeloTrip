import 'package:melo_trip/model/recommendation/seed_source.dart';
import 'package:melo_trip/model/recommendation/weighted_seed.dart';
import 'package:melo_trip/provider/recommendation/favorite_recommendation_seeds.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_weighted_seeds.g.dart';

/// Converts favorite song IDs to weighted seeds.
///
/// This is a pure function that wraps each song ID in a WeightedSeed
/// with the following properties:
/// - source: SeedSource.favorite
/// - weight: 1.0
/// - reason: 'favorite'
/// - timestamp: null
List<WeightedSeed> convertFavoriteSeedsToWeighted(Iterable<String> songIds) {
  return songIds
      .map(
        (songId) => WeightedSeed(
          songId: songId,
          source: SeedSource.favorite,
          weight: 1.0,
          reason: 'favorite',
        ),
      )
      .toList();
}

/// Provider for favorite songs as weighted recommendation seeds.
///
/// Reads from favoriteRecommendationSeedsProvider and converts each
/// favorite song ID to a WeightedSeed with:
/// - source: SeedSource.favorite
/// - weight: 1.0 (highest priority)
/// - reason: 'favorite'
/// - timestamp: null
///
/// Returns empty list if favoriteRecommendationSeedsProvider returns empty.
/// Does not throw exceptions - inherits the graceful degradation from
/// favoriteRecommendationSeedsProvider.
///
/// Does NOT directly read favoriteProvider - reuses the existing
/// favoriteRecommendationSeedsProvider to avoid duplicating P0 logic.
@riverpod
Future<List<WeightedSeed>> favoriteWeightedSeeds(Ref ref) async {
  final favoriteSeeds = await ref.watch(
    favoriteRecommendationSeedsProvider().future,
  );
  return convertFavoriteSeedsToWeighted(favoriteSeeds);
}
