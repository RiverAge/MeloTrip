import 'dart:async';

import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/recommendation/user_taste_seeds.dart';
import 'package:melo_trip/provider/sonic_similarity/sonic_similarity.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';
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
  Future<ForYouRecommendationRefreshState> build() async {
    final config = await ref.watch(sessionConfigProvider.future);
    final excludedSongIds =
        parseRecommendRefreshState(config?.recommendRefreshState)
            .excludedSongIds;
    // nonce stays 0 on restart: an unseeded Random produces fresh seed selection
    // jitter, so the next batch differs from the last session's first batch
    // while excludedSongIds still prevents re-showing the most recent page.
    return ForYouRecommendationRefreshState(excludedSongIds: excludedSongIds);
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

    final next = ForYouRecommendationRefreshState(
      nonce: (state.asData?.value.nonce ?? 0) + 1,
      excludedSongIds: excludedIds,
    );
    state = AsyncData(next);
    unawaited(
      ref
          .read(userSessionProvider.notifier)
          .setRecommendRefreshState(excludedSongIds: excludedIds),
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
/// - Refresh state (excludedSongIds) is persisted via user_config so a restart
///   resumes from the last page instead of resetting to the first batch.
@riverpod
Future<List<SongEntity>> forYouRecommendations(Ref ref) async {
  final refresh = await ref.watch(forYouRecommendationRefreshProvider.future);
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
