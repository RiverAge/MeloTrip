import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/recommendation/favorite_recommendation_seeds.dart';
import 'package:melo_trip/provider/sonic_similarity/sonic_similarity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'for_you_recommendations.g.dart';

/// Provider for "For You" recommendations on the home page.
///
/// Uses favorite songs as seeds and calls the existing recommendationsProvider
/// to get similar songs via getSonicSimilarTracks.
///
/// - Returns empty list if no seeds available.
/// - Does NOT fallback to getSimilarSongs2.
/// - Does NOT call AudioMuse-AI API directly.
/// - Does NOT cache results to local database.
@riverpod
Future<List<SongEntity>> forYouRecommendations(Ref ref) async {
  final seeds = await ref.watch(favoriteRecommendationSeedsProvider().future);

  if (seeds.isEmpty) {
    return <SongEntity>[];
  }

  // Reuse existing Recommendations provider
  final recommendations = await ref.watch(
    recommendationsProvider(limit: 20, seedSongIds: seeds).future,
  );

  return recommendations;
}
