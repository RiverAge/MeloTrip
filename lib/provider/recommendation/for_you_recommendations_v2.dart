import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/recommendation/user_taste_seeds.dart';
import 'package:melo_trip/provider/sonic_similarity/sonic_similarity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'for_you_recommendations_v2.g.dart';

/// Provider for "For You" recommendations (P1 version).
///
/// This is a parallel implementation kept for migration testing and validation.
/// It does NOT replace the existing forYouRecommendationsProvider.
///
/// The provider:
/// 1. Reads userTasteSeedsProvider
/// 2. Extracts song IDs from weighted seeds
/// 3. Calls recommendationsProvider with the seed IDs
///
/// Returns empty list if no seeds are available.
/// Does NOT fallback to getSimilarSongs2.
/// Does NOT call AudioMuse-AI API directly.
/// Does NOT cache results to local database.
///
/// This provider is NOT connected to the homepage UI.
/// It exists for parallel testing and future migration consideration.
@riverpod
Future<List<SongEntity>> forYouRecommendationsV2(Ref ref) async {
  final seeds = await ref.watch(userTasteSeedsProvider.future);

  if (seeds.isEmpty) {
    return <SongEntity>[];
  }

  // Reuse existing Recommendations provider
  final recommendations = await ref.watch(
    recommendationsProvider(limit: 20, weightedSeeds: seeds).future,
  );

  return recommendations;
}
