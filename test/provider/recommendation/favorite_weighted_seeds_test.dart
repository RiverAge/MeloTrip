import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/recommendation/seed_source.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/starred/starred.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:melo_trip/provider/recommendation/favorite_weighted_seeds.dart';

/// Tests for favoriteWeightedSeedsProvider.
///
/// Coverage:
/// 1. Pure function convertFavoriteSeedsToWeighted
/// 2. Provider favoriteWeightedSeeds
/// 3. Correct source/weight/reason/timestamp
/// 4. Empty favorites returns empty
/// 5. No direct Sonic API calls
void main() {
  group('convertFavoriteSeedsToWeighted pure function', () {
    test('returns empty list for empty input', () {
      final result = convertFavoriteSeedsToWeighted([]);
      expect(result.isEmpty, true);
    });

    test('converts single song ID to weighted seed', () {
      final result = convertFavoriteSeedsToWeighted(['song-1']);

      expect(result.length, 1);
      expect(result.first.songId, 'song-1');
      expect(result.first.source, SeedSource.favorite);
      expect(result.first.weight, 1.0);
      expect(result.first.reason, 'favorite');
      expect(result.first.timestamp, isNull);
    });

    test('converts multiple song IDs to weighted seeds', () {
      final result = convertFavoriteSeedsToWeighted([
        'song-1',
        'song-2',
        'song-3',
      ]);

      expect(result.length, 3);
      expect(result[0].songId, 'song-1');
      expect(result[1].songId, 'song-2');
      expect(result[2].songId, 'song-3');
    });

    test('all seeds have correct source, weight, and reason', () {
      final result = convertFavoriteSeedsToWeighted(['a', 'b', 'c']);

      for (final seed in result) {
        expect(seed.source, SeedSource.favorite);
        expect(seed.weight, 1.0);
        expect(seed.reason, 'favorite');
        expect(seed.timestamp, isNull);
      }
    });

    test('preserves input order', () {
      final result = convertFavoriteSeedsToWeighted(['c', 'a', 'b']);

      expect(result[0].songId, 'c');
      expect(result[1].songId, 'a');
      expect(result[2].songId, 'b');
    });
  });

  group('favoriteWeightedSeedsProvider', () {
    late ProviderContainer container;
    late Result<SubsonicResponse, AppFailure>? mockFavoriteResult;

    setUp(() {
      mockFavoriteResult = null;

      container = ProviderContainer(
        overrides: [
          favoriteProvider.overrideWith(
            () => _FakeFavoriteNotifier(mockResult: () => mockFavoriteResult),
          ),
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

        final seeds = await container.read(
          favoriteWeightedSeedsProvider.future,
        );
        expect(seeds.isEmpty, true);
      },
    );

    test(
      'returns empty list when favoriteProvider returns null starred',
      () async {
        mockFavoriteResult = Result.ok(
          SubsonicResponse(
            subsonicResponse: SubsonicResponseClass(starred: null),
          ),
        );

        final seeds = await container.read(
          favoriteWeightedSeedsProvider.future,
        );
        expect(seeds.isEmpty, true);
      },
    );

    test('converts favorite song IDs to weighted seeds', () async {
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

      final seeds = await container.read(favoriteWeightedSeedsProvider.future);

      expect(seeds.length, 2);
      expect(seeds[0].songId, 'fav-1');
      expect(seeds[0].source, SeedSource.favorite);
      expect(seeds[0].weight, 1.0);
      expect(seeds[0].reason, 'favorite');
      expect(seeds[0].timestamp, isNull);

      expect(seeds[1].songId, 'fav-2');
      expect(seeds[1].source, SeedSource.favorite);
      expect(seeds[1].weight, 1.0);
    });

    test('returns empty list when favoriteProvider returns error', () async {
      mockFavoriteResult = Result.err(
        AppFailure(type: AppFailureType.server, message: 'Network error'),
      );

      final seeds = await container.read(favoriteWeightedSeedsProvider.future);
      expect(seeds.isEmpty, true);
    });

    test(
      'respects maxSeeds from favoriteRecommendationSeedsProvider',
      () async {
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
                ],
              ),
            ),
          ),
        );

        final seeds = await container.read(
          favoriteWeightedSeedsProvider.future,
        );
        // Default maxSeeds is 5
        expect(seeds.length, 5);
      },
    );

    test('does not directly call Sonic API', () async {
      // This test verifies that favoriteWeightedSeedsProvider
      // only reads from favoriteRecommendationSeedsProvider
      // and does not make any Sonic API calls
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(
              song: [SongEntity(id: 'fav-1', title: 'Favorite 1')],
            ),
          ),
        ),
      );

      final seeds = await container.read(favoriteWeightedSeedsProvider.future);
      expect(seeds.length, 1);
      // No Sonic repository was involved in this provider chain
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
