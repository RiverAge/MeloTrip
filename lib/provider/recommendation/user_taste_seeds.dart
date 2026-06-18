import 'package:melo_trip/model/recommendation/weighted_seed.dart';
import 'package:melo_trip/provider/recommendation/favorite_weighted_seeds.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_taste_seeds.g.dart';

/// Deduplicates weighted seeds by songId.
///
/// For seeds with the same songId, only the one with the highest weight
/// is retained. If weights are equal, the first occurrence is kept.
///
/// This is a pure function suitable for unit testing.
List<WeightedSeed> deduplicateWeightedSeeds(List<WeightedSeed> seeds) {
  final bySongId = <String, WeightedSeed>{};

  for (final seed in seeds) {
    final existing = bySongId[seed.songId];
    if (existing == null || seed.weight > existing.weight) {
      bySongId[seed.songId] = seed;
    }
    // If weights are equal, keep the first occurrence (existing)
  }

  return bySongId.values.toList();
}

/// Sorts weighted seeds by weight in descending order.
///
/// Seeds with the same weight maintain their original relative order
/// (stable sort behavior).
List<WeightedSeed> sortSeedsByWeight(List<WeightedSeed> seeds) {
  // Create a list of indices to maintain stable sort
  final indexed = seeds.asMap().entries.toList();

  // Sort by weight descending, maintaining original order for equal weights
  indexed.sort((a, b) {
    final weightCompare = b.value.weight.compareTo(a.value.weight);
    if (weightCompare != 0) return weightCompare;
    // For equal weights, maintain original order (stable sort)
    return a.key.compareTo(b.key);
  });

  return indexed.map((e) => e.value).toList();
}

/// Provider for aggregated user taste seeds.
///
/// P1-A: Currently only aggregates favorite weighted seeds.
///
/// Future P1-B/P1-C may add:
/// - Current playing song (for context recommendations only)
/// - Play history seeds
/// - Rating seeds
///
/// The provider:
/// 1. Aggregates seeds from multiple sources (currently only favorites)
/// 2. Deduplicates by songId, keeping highest weight
/// 3. Sorts by weight descending
///
/// Returns empty list if no seeds are available.
@riverpod
Future<List<WeightedSeed>> userTasteSeeds(Ref ref) async {
  final seeds = <WeightedSeed>[];

  // P1-A: Only favorite seeds for For You homepage
  final favoriteSeeds = await ref.watch(favoriteWeightedSeedsProvider.future);
  seeds.addAll(favoriteSeeds);

  // P1-A: No current playing, no play_history, no rating

  // Deduplicate by songId, keeping highest weight
  final deduplicated = deduplicateWeightedSeeds(seeds);

  // Sort by weight descending
  return sortSeedsByWeight(deduplicated);
}
