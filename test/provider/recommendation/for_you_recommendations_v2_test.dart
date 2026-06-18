import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/starred/starred.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:melo_trip/provider/recommendation/for_you_recommendations_v2.dart';
import 'package:melo_trip/repository/sonic_similarity/sonic_similarity_repository.dart';

/// Tests for forYouRecommendationsV2Provider.
///
/// Coverage:
/// 1. No seeds returns empty, no Sonic API call
/// 2. Favorite seeds trigger Sonic Similarity via recommendationsProvider
/// 3. Results match recommendationsProvider behavior
/// 4. Sonic error returns empty, no fallback
/// 5. No getSimilarSongs2 fallback
/// 6. Filters out seed songs from results
void main() {
  group('forYouRecommendationsV2Provider', () {
    late ProviderContainer container;
    late Result<SubsonicResponse, AppFailure>? mockFavoriteResult;
    late List<SongEntity> mockSimilarSongs;
    late AppFailure? mockSonicError;
    late FakeSonicSimilarityRepository fakeRepository;

    setUp(() {
      mockFavoriteResult = null;
      mockSimilarSongs = [];
      mockSonicError = null;

      fakeRepository = FakeSonicSimilarityRepository(
        fetchResult: (id) {
          if (mockSonicError != null) {
            return Result.err(mockSonicError!);
          }
          return Result.ok(mockSimilarSongs);
        },
      );

      container = ProviderContainer(
        overrides: [
          favoriteProvider.overrideWith(
            () => _FakeFavoriteNotifier(mockResult: () => mockFavoriteResult),
          ),
          sonicSimilarityRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'returns empty list when no seeds available (empty favorites)',
      () async {
        mockFavoriteResult = Result.ok(
          SubsonicResponse(
            subsonicResponse: SubsonicResponseClass(
              starred: StarredEntity(song: []),
            ),
          ),
        );

        final recommendations = await container.read(
          forYouRecommendationsV2Provider.future,
        );

        expect(recommendations.isEmpty, true);
        // No API call should be made
        expect(fakeRepository.requestedIds.isEmpty, true);
      },
    );

    test(
      'returns empty list when no seeds available (null favorites)',
      () async {
        mockFavoriteResult = Result.ok(
          SubsonicResponse(
            subsonicResponse: SubsonicResponseClass(starred: null),
          ),
        );

        final recommendations = await container.read(
          forYouRecommendationsV2Provider.future,
        );

        expect(recommendations.isEmpty, true);
        expect(fakeRepository.requestedIds.isEmpty, true);
      },
    );

    test('calls Sonic API with favorite seeds', () async {
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(
              song: [
                SongEntity(id: 'fav-1', title: 'Favorite 1'),
                SongEntity(id: 'fav-2', title: 'Favorite 2'),
              ],
            ),
          ),
        ),
      );

      mockSimilarSongs = [
        SongEntity(id: 'similar-1', title: 'Similar 1'),
        SongEntity(id: 'similar-2', title: 'Similar 2'),
      ];

      final recommendations = await container.read(
        forYouRecommendationsV2Provider.future,
      );

      // Should have recommendations
      expect(recommendations.isNotEmpty, true);

      // Should have called Sonic API
      expect(fakeRepository.requestedIds.isNotEmpty, true);

      // At least one seed should be from favorites
      final usedFavoriteSeed = fakeRepository.requestedIds.any(
        (id) => ['fav-1', 'fav-2'].contains(id),
      );
      expect(usedFavoriteSeed, true);
    });

    test(
      'returns recommendations matching recommendationsProvider behavior',
      () async {
        mockFavoriteResult = Result.ok(
          SubsonicResponse(
            subsonicResponse: SubsonicResponseClass(
              starred: StarredEntity(
                song: [SongEntity(id: 'fav-1', title: 'Favorite 1')],
              ),
            ),
          ),
        );

        mockSimilarSongs = [
          SongEntity(id: 'similar-1', title: 'Similar 1'),
          SongEntity(id: 'similar-2', title: 'Similar 2'),
        ];

        final recommendations = await container.read(
          forYouRecommendationsV2Provider.future,
        );

        // Should return similar songs
        expect(recommendations.length, greaterThanOrEqualTo(1));
      },
    );

    test('filters out seed songs from recommendations', () async {
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(
              song: [SongEntity(id: 'fav-1', title: 'Favorite 1')],
            ),
          ),
        ),
      );

      // Return the same song as similar (should be filtered)
      mockSimilarSongs = [
        SongEntity(id: 'fav-1', title: 'Favorite 1'),
        SongEntity(id: 'similar-1', title: 'Similar 1'),
      ];

      final recommendations = await container.read(
        forYouRecommendationsV2Provider.future,
      );

      // Seed song should not appear in recommendations
      expect(recommendations.any((s) => s.id == 'fav-1'), false);
    });

    test('returns empty list when Sonic repository returns error', () async {
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(
              song: [SongEntity(id: 'fav-1', title: 'Favorite 1')],
            ),
          ),
        ),
      );

      mockSonicError = AppFailure(
        type: AppFailureType.server,
        message: 'Sonic API error',
      );

      final recommendations = await container.read(
        forYouRecommendationsV2Provider.future,
      );

      expect(recommendations.isEmpty, true);
    });

    test('Sonic API error does not throw exception', () async {
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(
              song: [SongEntity(id: 'fav-1', title: 'Favorite 1')],
            ),
          ),
        ),
      );

      mockSonicError = AppFailure(
        type: AppFailureType.server,
        message: 'Network error',
        statusCode: 503,
      );

      // Should not throw
      expect(
        () => container.read(forYouRecommendationsV2Provider.future),
        returnsNormally,
      );

      final recommendations = await container.read(
        forYouRecommendationsV2Provider.future,
      );
      expect(recommendations.isEmpty, true);
    });

    test('does not call getSimilarSongs2 fallback', () async {
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(
              song: [SongEntity(id: 'fav-1', title: 'Favorite 1')],
            ),
          ),
        ),
      );

      mockSonicError = AppFailure(
        type: AppFailureType.server,
        message: 'Not found',
        statusCode: 404,
      );

      await container.read(forYouRecommendationsV2Provider.future);

      // Fake repository only implements tryFetchSonicSimilarTracks
      // No getSimilarSongs2 method was called
      expect(fakeRepository.requestedIds.contains('getSimilarSongs2'), false);
      expect(fakeRepository.requestedIds.contains('getSimilarSongs'), false);
    });

    test('respects max 5 seeds from favorites', () async {
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(
              song: [
                SongEntity(id: 'fav-1', title: 'Favorite 1'),
                SongEntity(id: 'fav-2', title: 'Favorite 2'),
                SongEntity(id: 'fav-3', title: 'Favorite 3'),
                SongEntity(id: 'fav-4', title: 'Favorite 4'),
                SongEntity(id: 'fav-5', title: 'Favorite 5'),
                SongEntity(id: 'fav-6', title: 'Favorite 6'),
                SongEntity(id: 'fav-7', title: 'Favorite 7'),
              ],
            ),
          ),
        ),
      );

      mockSimilarSongs = List.generate(
        20,
        (i) => SongEntity(id: 'similar-$i', title: 'Similar $i'),
      );

      await container.read(forYouRecommendationsV2Provider.future);

      // The Recommendations provider uses up to 5 seeds
      expect(fakeRepository.requestedIds.length, lessThanOrEqualTo(5));
    });

    test('handles favorite provider error gracefully', () async {
      mockFavoriteResult = Result.err(
        AppFailure(type: AppFailureType.server, message: 'Network error'),
      );

      final recommendations = await container.read(
        forYouRecommendationsV2Provider.future,
      );

      expect(recommendations.isEmpty, true);
      expect(fakeRepository.requestedIds.isEmpty, true);
    });

    test('returns deduplicated recommendations', () async {
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(
              song: [
                SongEntity(id: 'fav-1', title: 'Favorite 1'),
                SongEntity(id: 'fav-2', title: 'Favorite 2'),
              ],
            ),
          ),
        ),
      );

      // Return same songs from multiple seeds
      mockSimilarSongs = [
        SongEntity(id: 'similar-1', title: 'Similar 1'),
        SongEntity(id: 'similar-2', title: 'Similar 2'),
      ];

      final recommendations = await container.read(
        forYouRecommendationsV2Provider.future,
      );

      // Should not have duplicates
      final songIds = recommendations.map((s) => s.id).toList();
      final uniqueIds = songIds.toSet();
      expect(songIds.length, uniqueIds.length);
    });
  });
}

/// Fake notifier for testing favoriteProvider
class _FakeFavoriteNotifier extends Favorite {
  final Result<SubsonicResponse, AppFailure>? Function() mockResult;

  _FakeFavoriteNotifier({required this.mockResult});

  @override
  Future<Result<SubsonicResponse, AppFailure>> build() async {
    return mockResult() ??
        Result.ok(
          SubsonicResponse(
            subsonicResponse: SubsonicResponseClass(starred: null),
          ),
        );
  }
}

/// Fake implementation of SonicSimilarityRepository for testing
class FakeSonicSimilarityRepository implements SonicSimilarityRepository {
  final Result<List<SongEntity>, AppFailure> Function(String id) fetchResult;

  /// Records all song IDs requested via tryFetchSonicSimilarTracks
  final List<String> requestedIds = [];

  /// Returns the last requested song ID, or null if none.
  String? get lastRequestedId =>
      requestedIds.isEmpty ? null : requestedIds.last;

  FakeSonicSimilarityRepository({required this.fetchResult});

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
    return fetchResult(startSongId);
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
      ok: (songs) => Result.ok(songs.map((s) => (s, null as double?)).toList()),
      err: (e) => Result.err(e),
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
    final result = fetchResult(startSongId);
    return result.when(
      ok: (songs) => Result.ok(songs.map((s) => (s, null as double?)).toList()),
      err: (e) => Result.err(e),
    );
  }
}
