import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/recommendation/seed_source.dart';
import 'package:melo_trip/model/recommendation/weighted_seed.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/recommendation/favorite_weighted_seeds.dart';
import 'package:melo_trip/provider/recommendation/playlist_weighted_seeds.dart';
import 'package:melo_trip/provider/recommendation/recommendation_sections.dart';
import 'package:melo_trip/repository/sonic_similarity/sonic_similarity_repository.dart';

void main() {
  group('recommendation section providers', () {
    test('favorite section recommends from favorite weighted seeds', () async {
      final repository = _FakeSonicSimilarityRepository(
        fetchResult: (id) =>
            Result.ok([SongEntity(id: 'similar-$id', title: 'Similar $id')]),
      );
      final container = ProviderContainer(
        overrides: [
          favoriteWeightedSeedsProvider.overrideWith(
            (_) async => const [
              WeightedSeed(
                songId: 'favorite-1',
                source: SeedSource.favorite,
                weight: 1,
              ),
              WeightedSeed(
                songId: 'favorite-2',
                source: SeedSource.favorite,
                weight: 1,
              ),
            ],
          ),
          sonicSimilarityRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final recommendations = await container.read(
        favoriteBasedRecommendationsProvider(limit: 2).future,
      );

      expect(recommendations.map((song) => song.id).toSet(), {
        'similar-favorite-1',
        'similar-favorite-2',
      });
      expect(repository.requestedIds.toSet(), {'favorite-1', 'favorite-2'});
    });

    test('playlist section skips similarity request without seeds', () async {
      final repository = _FakeSonicSimilarityRepository(
        fetchResult: (_) =>
            Result.ok([SongEntity(id: 'similar-1', title: 'Similar 1')]),
      );
      final container = ProviderContainer(
        overrides: [
          playlistWeightedSeedsProvider().overrideWith(
            (_) async => const <WeightedSeed>[],
          ),
          sonicSimilarityRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      final recommendations = await container.read(
        playlistBasedRecommendationsProvider(limit: 2).future,
      );

      expect(recommendations, isEmpty);
      expect(repository.requestedIds, isEmpty);
    });
  });
}

class _FakeSonicSimilarityRepository implements SonicSimilarityRepository {
  _FakeSonicSimilarityRepository({required this.fetchResult});

  final Result<List<SongEntity>, AppFailure> Function(String id) fetchResult;
  final List<String> requestedIds = [];

  @override
  Future<SubsonicResponse> fetchSonicSimilarTracks({
    required String id,
    int? count,
    CancelToken? cancelToken,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<SongEntity>, AppFailure>> tryFetchSonicSimilarTracks({
    required String id,
    int? count,
    CancelToken? cancelToken,
  }) async {
    requestedIds.add(id);
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
  Future<Result<List<SongEntity>, AppFailure>> tryFindSonicPath({
    required String startSongId,
    required String endSongId,
    int? count,
    CancelToken? cancelToken,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<(SongEntity, double?)>, AppFailure>>
  tryFetchSonicSimilarTracksWithScores({
    required String id,
    int? count,
    CancelToken? cancelToken,
  }) async {
    final result = fetchResult(id);
    return result.when(
      ok: (songs) =>
          Result.ok(songs.map((song) => (song, null as double?)).toList()),
      err: (failure) => Result.err(failure),
    );
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
