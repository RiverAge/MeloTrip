import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/common/sonic_similarity_result.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/sonic_similarity/sonic_similarity.dart';
import 'package:melo_trip/repository/sonic_similarity/sonic_similarity_repository.dart';

void main() {
  test('recommendations prefer songs not returned recently', () async {
    final repository = _FakeSonicSimilarityRepository(
      songs: [
        SongEntity(id: 'old-1', title: 'Old 1'),
        SongEntity(id: 'old-2', title: 'Old 2'),
        SongEntity(id: 'new-1', title: 'New 1'),
        SongEntity(id: 'new-2', title: 'New 2'),
      ],
    );
    final container = ProviderContainer(
      overrides: [
        sonicSimilarityRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    container.read(recentRecommendationHistoryProvider.notifier).record([
      SongEntity(id: 'old-1', title: 'Old 1'),
      SongEntity(id: 'old-2', title: 'Old 2'),
    ]);

    final recommendations = await container.read(
      recommendationsProvider(limit: 2, seedSongIds: ['seed']).future,
    );

    expect(recommendations.map((song) => song.id).toSet(), {'new-1', 'new-2'});
    expect(repository.requestedCounts.single, 50);
  });

  test('recommendations never fallback to explicitly excluded songs', () async {
    final repository = _FakeSonicSimilarityRepository(
      songs: [
        SongEntity(id: 'shown-1', title: 'Shown 1'),
        SongEntity(id: 'shown-2', title: 'Shown 2'),
      ],
    );
    final container = ProviderContainer(
      overrides: [
        sonicSimilarityRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    container.read(recentRecommendationHistoryProvider.notifier).record([
      SongEntity(id: 'shown-1', title: 'Shown 1'),
      SongEntity(id: 'shown-2', title: 'Shown 2'),
    ]);

    final recommendations = await container.read(
      recommendationsProvider(
        limit: 2,
        seedSongIds: ['seed'],
        excludedSongIds: ['shown-1', 'shown-2'],
        refreshNonce: 1,
      ).future,
    );

    expect(recommendations, isEmpty);
  });
}

class _FakeSonicSimilarityRepository implements SonicSimilarityRepository {
  _FakeSonicSimilarityRepository({required this.songs});

  final List<SongEntity> songs;
  final List<int?> requestedCounts = [];

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
    requestedCounts.add(count);
    return Result.ok(SonicSimilarityResult(songs: songs));
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
  tryFetchSonicSimilarTracksWithScores({
    required String id,
    int? count,
    CancelToken? cancelToken,
  }) async {
    requestedCounts.add(count);
    return Result.ok(songs.map((song) => (song, null as double?)).toList());
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
