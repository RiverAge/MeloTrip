import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/recommendation/user_taste_seeds.dart';
import 'package:melo_trip/provider/sonic_similarity/sonic_similarity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'for_you_recommendations.g.dart';

class ForYouRecommendationRefreshState {
  const ForYouRecommendationRefreshState({
    this.nonce = 0,
    this.excludedSongIds = const <String>[],
  });

  final int nonce;
  final List<String> excludedSongIds;
}

@Riverpod(keepAlive: true)
class ForYouRecommendationRefresh extends _$ForYouRecommendationRefresh {
  @override
  ForYouRecommendationRefreshState build() {
    return const ForYouRecommendationRefreshState();
  }

  void requestRefresh(Iterable<SongEntity> currentSongs) {
    final excludedIds = <String>[];
    final seenIds = <String>{};

    for (final song in currentSongs) {
      final id = song.id;
      if (id == null || id.isEmpty || !seenIds.add(id)) {
        continue;
      }
      excludedIds.add(id);
    }

    state = ForYouRecommendationRefreshState(
      nonce: state.nonce + 1,
      excludedSongIds: excludedIds,
    );
  }
}

/// Provider for "For You" recommendations on the home page.
///
/// Uses aggregated user taste seeds and calls the existing
/// recommendationsProvider to get similar songs via getSonicSimilarTracks.
///
/// - Returns empty list if no seeds available.
/// - Does NOT fallback to getSimilarSongs2.
/// - Does NOT call AudioMuse-AI API directly.
/// - Does NOT cache results to local database.
@riverpod
Future<List<SongEntity>> forYouRecommendations(Ref ref) async {
  final refresh = ref.watch(forYouRecommendationRefreshProvider);
  final seeds = await ref.watch(userTasteSeedsProvider.future);

  if (seeds.isEmpty) {
    return <SongEntity>[];
  }

  final recommendations = await ref.watch(
    recommendationsProvider(
      limit: 20,
      weightedSeeds: seeds,
      excludedSongIds: refresh.excludedSongIds,
      refreshNonce: refresh.nonce,
    ).future,
  );

  return recommendations;
}
