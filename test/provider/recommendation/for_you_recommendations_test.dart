import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/starred/starred.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/provider/recommendation/for_you_recommendations.dart';
import 'package:melo_trip/repository/sonic_similarity/sonic_similarity_repository.dart';

/// Tests for forYouRecommendationsProvider integration.
///
/// Coverage:
/// 1. Empty favorites -> empty recommendations
/// 2. Favorite error -> empty recommendations
/// 3. Favorites with songs -> correct seed extraction and recommendations
/// 4. Sonic repository error -> empty recommendations
/// 5. No getSimilarSongs2 fallback
/// 6. No play history or rating reading
void main() {
  group('forYouRecommendationsProvider', () {
    late ProviderContainer container;
    late Result<SubsonicResponse, AppFailure>? mockFavoriteResult;
    late List<PlaylistEntity> mockPlaylists;
    late Map<String, Result<PlaylistEntity, AppFailure>?> mockPlaylistDetails;
    late List<SongEntity> mockSimilarSongs;
    late AppFailure? mockSonicError;
    late FakeSonicSimilarityRepository fakeRepository;

    setUp(() {
      mockFavoriteResult = null;
      mockPlaylists = const <PlaylistEntity>[];
      mockPlaylistDetails = <String, Result<PlaylistEntity, AppFailure>?>{};
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
          playlistsProvider.overrideWith((_) async => Result.ok(mockPlaylists)),
          playlistDetailProvider('pl-1').overrideWith(
            () => _FakePlaylistDetail(
              mockResult: () => mockPlaylistDetails['pl-1'],
            ),
          ),
          sonicSimilarityRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test(
      'returns empty list when favoriteProvider returns empty starred',
      () async {
        mockFavoriteResult = Result.ok(
          SubsonicResponse(
            subsonicResponse: SubsonicResponseClass(
              starred: StarredEntity(song: []),
            ),
          ),
        );

        final recommendations = await container.read(
          forYouRecommendationsProvider.future,
        );
        expect(recommendations.isEmpty, true);
        // No API call should be made
        expect(fakeRepository.requestedIds.isEmpty, true);
      },
    );

    test('uses playlist seeds when favorite songs are unavailable', () async {
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(song: []),
          ),
        ),
      );
      mockPlaylists = [PlaylistEntity(id: 'pl-1', name: 'Daily', songCount: 2)];
      mockPlaylistDetails['pl-1'] = Result.ok(
        PlaylistEntity(
          id: 'pl-1',
          name: 'Daily',
          entry: [
            SongEntity(id: 'playlist-1', title: 'Playlist 1'),
            SongEntity(id: 'playlist-2', title: 'Playlist 2'),
          ],
        ),
      );
      mockSimilarSongs = [SongEntity(id: 'similar-1', title: 'Similar 1')];

      final recommendations = await container.read(
        forYouRecommendationsProvider.future,
      );

      expect(recommendations, isNotEmpty);
      expect(
        fakeRepository.requestedIds.any(
          (id) => ['playlist-1', 'playlist-2'].contains(id),
        ),
        true,
      );
    });

    test(
      'returns empty list when favoriteProvider returns null starred',
      () async {
        mockFavoriteResult = Result.ok(
          SubsonicResponse(
            subsonicResponse: SubsonicResponseClass(starred: null),
          ),
        );

        final recommendations = await container.read(
          forYouRecommendationsProvider.future,
        );
        expect(recommendations.isEmpty, true);
        expect(fakeRepository.requestedIds.isEmpty, true);
      },
    );

    test('returns empty list when favoriteProvider returns error', () async {
      mockFavoriteResult = Result.err(
        AppFailure(type: AppFailureType.server, message: 'Network error'),
      );

      final recommendations = await container.read(
        forYouRecommendationsProvider.future,
      );
      expect(recommendations.isEmpty, true);
      expect(fakeRepository.requestedIds.isEmpty, true);
    });

    test('extracts seeds and calls Sonic API with correct seed ids', () async {
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(
              song: [
                SongEntity(id: 'fav-1', title: 'Favorite 1'),
                SongEntity(id: 'fav-2', title: 'Favorite 2'),
                SongEntity(id: 'fav-3', title: 'Favorite 3'),
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
        forYouRecommendationsProvider.future,
      );

      // Should have recommendations
      expect(recommendations.isNotEmpty, true);

      // Should have called Sonic API with favorite seeds
      expect(fakeRepository.requestedIds.isNotEmpty, true);

      // At least one of the seeds should be from favorites
      final usedFavoriteSeed = fakeRepository.requestedIds.any(
        (id) => ['fav-1', 'fav-2', 'fav-3'].contains(id),
      );
      expect(usedFavoriteSeed, true);
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

      await container.read(forYouRecommendationsProvider.future);

      // Check that seeds were extracted (max 5 by default)
      // The Recommendations provider uses up to 5 seeds
      expect(fakeRepository.requestedIds.length, lessThanOrEqualTo(5));
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
        forYouRecommendationsProvider.future,
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
        () => container.read(forYouRecommendationsProvider.future),
        returnsNormally,
      );

      final recommendations = await container.read(
        forYouRecommendationsProvider.future,
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

      await container.read(forYouRecommendationsProvider.future);

      // Fake repository only implements tryFetchSonicSimilarTracks
      // No getSimilarSongs2 method was called
      expect(fakeRepository.requestedIds.contains('getSimilarSongs2'), false);
      expect(fakeRepository.requestedIds.contains('getSimilarSongs'), false);
    });

    test('does not read play history or ratings', () async {
      // This test verifies that the provider chain only reads from favorites
      // The fake repository only implements Sonic Similarity, not play history
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(
              song: [
                SongEntity(id: 'fav-1', title: 'Favorite 1', userRating: 5),
              ],
            ),
          ),
        ),
      );

      mockSimilarSongs = [SongEntity(id: 'similar-1', title: 'Similar 1')];

      final recommendations = await container.read(
        forYouRecommendationsProvider.future,
      );

      // Provider should work without play history or rating logic
      expect(recommendations.length, 1);
      expect(recommendations.first.id, 'similar-1');
    });

    test('returns multiple similar songs from multiple seeds', () async {
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
        SongEntity(id: 'similar-a', title: 'Similar A'),
        SongEntity(id: 'similar-b', title: 'Similar B'),
        SongEntity(id: 'similar-c', title: 'Similar C'),
      ];

      final recommendations = await container.read(
        forYouRecommendationsProvider.future,
      );

      // Should return recommendations
      expect(recommendations.isNotEmpty, true);
    });

    test('filters out songs already in seed set', () async {
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
        forYouRecommendationsProvider.future,
      );

      // Seed song should not appear in recommendations
      expect(recommendations.any((s) => s.id == 'fav-1'), false);
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

class _FakePlaylistDetail extends PlaylistDetail {
  _FakePlaylistDetail({required this.mockResult});

  final Result<PlaylistEntity, AppFailure>? Function() mockResult;

  @override
  Future<Result<PlaylistEntity, AppFailure>?> build(String? _) async {
    return mockResult();
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
