import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/common/sonic_similarity_result.dart';
import 'package:melo_trip/model/recommendation/seed_source.dart';
import 'package:melo_trip/model/recommendation/weighted_seed.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/sonic_similarity/sonic_similarity.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';
import 'package:melo_trip/repository/sonic_similarity/sonic_similarity_repository.dart';

void main() {
  group('selectWeightedRecommendationSeeds', () {
    test('keeps source diversity before filling remaining slots', () {
      final seeds = <WeightedSeed>[
        for (var i = 0; i < 6; i++)
          WeightedSeed(
            songId: 'favorite-$i',
            source: SeedSource.favorite,
            weight: 1,
          ),
        for (var i = 0; i < 3; i++)
          WeightedSeed(
            songId: 'playlist-$i',
            source: SeedSource.playlist,
            weight: .7,
          ),
      ];

      final selected = selectWeightedRecommendationSeeds(
        seeds: seeds,
        maxSeeds: 6,
        refreshNonce: 12,
      );

      expect(selected, hasLength(6));
      expect(
        selected.where((seed) => seed.source == SeedSource.favorite).length,
        lessThanOrEqualTo(4),
      );
      expect(
        selected.where((seed) => seed.source == SeedSource.playlist).length,
        greaterThanOrEqualTo(2),
      );
    });

    test('relaxes source caps when only one source is available', () {
      final selected = selectWeightedRecommendationSeeds(
        seeds: [
          for (var i = 0; i < 8; i++)
            WeightedSeed(
              songId: 'favorite-$i',
              source: SeedSource.favorite,
              weight: 1,
            ),
        ],
        maxSeeds: 6,
        refreshNonce: 12,
      );

      expect(selected, hasLength(6));
      expect(
        selected.every((seed) => seed.source == SeedSource.favorite),
        isTrue,
      );
    });
  });

  group('recommendationsProvider weighted aggregation', () {
    test('ranks candidates by seed weight and sonic score', () async {
      final repository = _FakeSonicSimilarityRepository(
        fetchResult: (id) => switch (id) {
          'strong-seed' => Result.ok([
            (SongEntity(id: 'from-strong', title: 'Strong'), .70),
          ]),
          'weak-seed' => Result.ok([
            (SongEntity(id: 'from-weak', title: 'Weak'), .99),
          ]),
          _ => const Result.ok(<(SongEntity, double?)>[]),
        },
      );
      final container = ProviderContainer(
        overrides: [
          userSessionProvider.overrideWith(_FakeUserSession.new),
          sonicSimilarityRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final recommendations = await container.read(
        recommendationsProvider(
          limit: 2,
          weightedSeeds: const [
            WeightedSeed(
              songId: 'weak-seed',
              source: SeedSource.playlist,
              weight: .2,
            ),
            WeightedSeed(
              songId: 'strong-seed',
              source: SeedSource.favorite,
              weight: 1,
            ),
          ],
          refreshNonce: 4,
        ).future,
      );

      expect(recommendations.map((song) => song.id), [
        'from-strong',
        'from-weak',
      ]);
    });

    test('limits same artist when enough alternatives exist', () async {
      final repository = _FakeSonicSimilarityRepository(
        fetchResult: (_) => Result.ok([
          (SongEntity(id: 'a-1', title: 'A1', artist: 'Artist A'), .99),
          (SongEntity(id: 'a-2', title: 'A2', artist: 'Artist A'), .98),
          (SongEntity(id: 'a-3', title: 'A3', artist: 'Artist A'), .97),
          (SongEntity(id: 'b-1', title: 'B1', artist: 'Artist B'), .90),
        ]),
      );
      final container = ProviderContainer(
        overrides: [
          userSessionProvider.overrideWith(_FakeUserSession.new),
          sonicSimilarityRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final recommendations = await container.read(
        recommendationsProvider(
          limit: 3,
          weightedSeeds: const [
            WeightedSeed(
              songId: 'seed',
              source: SeedSource.favorite,
              weight: 1,
            ),
          ],
          refreshNonce: 4,
        ).future,
      );

      expect(recommendations, hasLength(3));
      expect(
        recommendations.where((song) => song.artist == 'Artist A').length,
        2,
      );
      expect(recommendations.any((song) => song.artist == 'Artist B'), isTrue);
    });

    test('artistCap=1 limits same artist to 1 when alternatives exist',
        () async {
      final repository = _FakeSonicSimilarityRepository(
        fetchResult: (_) => Result.ok([
          (SongEntity(id: 'a-1', title: 'A1', artist: 'Artist A'), .99),
          (SongEntity(id: 'a-2', title: 'A2', artist: 'Artist A'), .98),
          (SongEntity(id: 'a-3', title: 'A3', artist: 'Artist A'), .97),
          (SongEntity(id: 'b-1', title: 'B1', artist: 'Artist B'), .90),
          (SongEntity(id: 'c-1', title: 'C1', artist: 'Artist C'), .89),
          (SongEntity(id: 'd-1', title: 'D1', artist: 'Artist D'), .88),
        ]),
      );
      final container = ProviderContainer(
        overrides: [
          userSessionProvider.overrideWith(_FakeUserSession.new),
          sonicSimilarityRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final recommendations = await container.read(
        recommendationsProvider(
          limit: 3,
          weightedSeeds: const [
            WeightedSeed(
              songId: 'seed',
              source: SeedSource.favorite,
              weight: 1,
            ),
          ],
          refreshNonce: 4,
          artistCap: 1,
          albumCap: 1,
        ).future,
      );

      // Strict cap=1 fills all 3 slots from distinct artists, so Artist A
      // appears at most once even though it has the top 3 scored songs.
      expect(recommendations, hasLength(3));
      expect(
        recommendations.where((song) => song.artist == 'Artist A').length,
        1,
      );
    });

    test('artistCap=1 relaxes to 2 only for unfilled slots when pool is thin',
        () async {
      final repository = _FakeSonicSimilarityRepository(
        fetchResult: (_) => Result.ok([
          (SongEntity(id: 'a-1', title: 'A1', artist: 'Artist A'), .99),
          (SongEntity(id: 'a-2', title: 'A2', artist: 'Artist A'), .98),
          (SongEntity(id: 'a-3', title: 'A3', artist: 'Artist A'), .97),
          (SongEntity(id: 'b-1', title: 'B1', artist: 'Artist B'), .90),
        ]),
      );
      final container = ProviderContainer(
        overrides: [
          userSessionProvider.overrideWith(_FakeUserSession.new),
          sonicSimilarityRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final recommendations = await container.read(
        recommendationsProvider(
          limit: 3,
          weightedSeeds: const [
            WeightedSeed(
              songId: 'seed',
              source: SeedSource.favorite,
              weight: 1,
            ),
          ],
          refreshNonce: 4,
          artistCap: 1,
          albumCap: 1,
        ).future,
      );

      // Only 2 distinct artists available for limit=3. Strict cap=1 picks
      // A1 + B1 (2 songs), then the relaxed pass fills the remaining slot
      // with cap=2, allowing a second Artist A song. The strict picks are
      // preserved (not re-selected from scratch).
      expect(recommendations, hasLength(3));
      expect(
        recommendations.where((song) => song.artist == 'Artist A').length,
        2,
      );
      expect(recommendations.any((song) => song.artist == 'Artist B'), isTrue);
    });
  });
}

/// Fake [UserSession] that avoids touching real persistence in tests.
class _FakeUserSession extends UserSession {
  @override
  Future<UserSessionSnapshot> build() async {
    return const UserSessionSnapshot(auth: null, config: null);
  }

  @override
  Future<void> setRecommendRefreshState({
    List<String>? recentIds,
    List<String>? excludedSongIds,
  }) async {}
}

class _FakeSonicSimilarityRepository implements SonicSimilarityRepository {
  _FakeSonicSimilarityRepository({required this.fetchResult});

  final Result<List<(SongEntity, double?)>, AppFailure> Function(String id)
      fetchResult;

  @override
  Future<SubsonicResponse> fetchSonicSimilarTracks({
    required String id,
    int? count,
    CancelToken? cancelToken,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<SonicSimilarityResult, AppFailure>> tryFetchSonicSimilarTracks({
    required String id,
    int? count,
    CancelToken? cancelToken,
  }) async {
    final result = fetchResult(id);
    return result.when(
      ok: (matches) => Result.ok(
        SonicSimilarityResult(songs: matches.map((match) => match.$1).toList()),
      ),
      err: Result.err,
    );
  }

  @override
  Future<Result<List<(SongEntity, double?)>, AppFailure>>
  tryFetchSonicSimilarTracksWithScores({
    required String id,
    int? count,
    CancelToken? cancelToken,
  }) async {
    return fetchResult(id);
  }

  @override
  Future<SubsonicResponse> findSonicPath({
    required String startSongId,
    required String endSongId,
    int? count,
    CancelToken? cancelToken,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<SonicSimilarityResult, AppFailure>> tryFindSonicPath({
    required String startSongId,
    required String endSongId,
    int? count,
    CancelToken? cancelToken,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<(SongEntity, double?)>, AppFailure>>
  tryFindSonicPathWithScores({
    required String startSongId,
    required String endSongId,
    int? count,
    CancelToken? cancelToken,
  }) async {
    throw UnimplementedError();
  }
}
