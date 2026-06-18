import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/recommendation/seed_source.dart';
import 'package:melo_trip/model/recommendation/weighted_seed.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/starred/starred.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:melo_trip/provider/recommendation/user_taste_seeds.dart';

/// Tests for userTasteSeedsProvider.
///
/// Coverage:
/// 1. Pure functions deduplicateWeightedSeeds and sortSeedsByWeight
/// 2. Provider userTasteSeeds aggregates favorite seeds
/// 3. Deduplication by songId keeping higher weight
/// 4. Sorting by weight descending
/// 5. Empty input returns empty
/// 6. P1-A does not include current/play_history/rating
void main() {
  group('deduplicateWeightedSeeds pure function', () {
    test('returns empty list for empty input', () {
      final result = deduplicateWeightedSeeds([]);
      expect(result.isEmpty, true);
    });

    test('returns single seed unchanged', () {
      final seeds = [
        WeightedSeed(
          songId: 'song-1',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
      ];

      final result = deduplicateWeightedSeeds(seeds);

      expect(result.length, 1);
      expect(result.first.songId, 'song-1');
    });

    test('keeps all seeds with different songIds', () {
      final seeds = [
        WeightedSeed(
          songId: 'song-1',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
        WeightedSeed(
          songId: 'song-2',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
        WeightedSeed(
          songId: 'song-3',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
      ];

      final result = deduplicateWeightedSeeds(seeds);

      expect(result.length, 3);
    });

    test('deduplicates by songId keeping highest weight', () {
      final seeds = [
        WeightedSeed(
          songId: 'song-1',
          source: SeedSource.favorite,
          weight: 0.5,
        ),
        WeightedSeed(songId: 'song-1', source: SeedSource.recent, weight: 0.8),
        WeightedSeed(songId: 'song-1', source: SeedSource.rating, weight: 0.9),
      ];

      final result = deduplicateWeightedSeeds(seeds);

      expect(result.length, 1);
      expect(result.first.songId, 'song-1');
      expect(result.first.weight, 0.9);
      expect(result.first.source, SeedSource.rating);
    });

    test('keeps first occurrence when weights are equal', () {
      final seeds = [
        WeightedSeed(
          songId: 'song-1',
          source: SeedSource.favorite,
          weight: 1.0,
          reason: 'first',
        ),
        WeightedSeed(
          songId: 'song-1',
          source: SeedSource.recent,
          weight: 1.0,
          reason: 'second',
        ),
      ];

      final result = deduplicateWeightedSeeds(seeds);

      expect(result.length, 1);
      expect(result.first.reason, 'first');
    });

    test('handles mixed duplicate and unique seeds', () {
      final seeds = [
        WeightedSeed(
          songId: 'song-1',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
        WeightedSeed(
          songId: 'song-2',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
        WeightedSeed(songId: 'song-1', source: SeedSource.recent, weight: 0.8),
        WeightedSeed(
          songId: 'song-3',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
      ];

      final result = deduplicateWeightedSeeds(seeds);

      expect(result.length, 3);
      final songIds = result.map((s) => s.songId).toSet();
      expect(songIds, containsAll(['song-1', 'song-2', 'song-3']));
    });
  });

  group('sortSeedsByWeight pure function', () {
    test('returns empty list for empty input', () {
      final result = sortSeedsByWeight([]);
      expect(result.isEmpty, true);
    });

    test('returns single seed unchanged', () {
      final seeds = [
        WeightedSeed(
          songId: 'song-1',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
      ];

      final result = sortSeedsByWeight(seeds);

      expect(result.length, 1);
      expect(result.first.songId, 'song-1');
    });

    test('sorts by weight descending', () {
      final seeds = [
        WeightedSeed(songId: 'song-1', source: SeedSource.current, weight: 0.7),
        WeightedSeed(
          songId: 'song-2',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
        WeightedSeed(songId: 'song-3', source: SeedSource.recent, weight: 0.8),
      ];

      final result = sortSeedsByWeight(seeds);

      expect(result.length, 3);
      expect(result[0].weight, 1.0);
      expect(result[1].weight, 0.8);
      expect(result[2].weight, 0.7);
    });

    test('maintains original order for equal weights (stable sort)', () {
      final seeds = [
        WeightedSeed(
          songId: 'song-a',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
        WeightedSeed(
          songId: 'song-b',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
        WeightedSeed(
          songId: 'song-c',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
      ];

      final result = sortSeedsByWeight(seeds);

      expect(result[0].songId, 'song-a');
      expect(result[1].songId, 'song-b');
      expect(result[2].songId, 'song-c');
    });

    test('handles mixed weights with some equal', () {
      final seeds = [
        WeightedSeed(songId: 'song-1', source: SeedSource.current, weight: 0.7),
        WeightedSeed(
          songId: 'song-2',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
        WeightedSeed(
          songId: 'song-3',
          source: SeedSource.favorite,
          weight: 1.0,
        ),
        WeightedSeed(songId: 'song-4', source: SeedSource.recent, weight: 0.8),
      ];

      final result = sortSeedsByWeight(seeds);

      expect(result[0].weight, 1.0);
      expect(result[1].weight, 1.0);
      expect(result[2].weight, 0.8);
      expect(result[3].weight, 0.7);
      // Stable sort: song-2 should come before song-3
      expect(result[0].songId, 'song-2');
      expect(result[1].songId, 'song-3');
    });
  });

  group('userTasteSeedsProvider', () {
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

    test('returns empty list when no favorites available', () async {
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(song: []),
          ),
        ),
      );

      final seeds = await container.read(userTasteSeedsProvider.future);
      expect(seeds.isEmpty, true);
    });

    test('aggregates favorite weighted seeds', () async {
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

      final seeds = await container.read(userTasteSeedsProvider.future);

      expect(seeds.length, 2);
      expect(seeds.every((s) => s.source == SeedSource.favorite), true);
      expect(seeds.every((s) => s.weight == 1.0), true);
    });

    test('returns seeds sorted by weight (all 1.0 for favorites)', () async {
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

      final seeds = await container.read(userTasteSeedsProvider.future);

      // All favorite seeds have weight 1.0
      expect(seeds.every((s) => s.weight == 1.0), true);
    });

    test('P1-A does not include current playing seed', () async {
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(
              song: [SongEntity(id: 'fav-1', title: 'Favorite 1')],
            ),
          ),
        ),
      );

      final seeds = await container.read(userTasteSeedsProvider.future);

      // P1-A: Only favorite seeds, no current playing
      expect(seeds.every((s) => s.source == SeedSource.favorite), true);
      expect(seeds.any((s) => s.source == SeedSource.current), false);
    });

    test('P1-A does not include play history seed', () async {
      mockFavoriteResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            starred: StarredEntity(
              song: [SongEntity(id: 'fav-1', title: 'Favorite 1')],
            ),
          ),
        ),
      );

      final seeds = await container.read(userTasteSeedsProvider.future);

      expect(seeds.any((s) => s.source == SeedSource.playHistory), false);
    });

    test('P1-A does not include rating seed', () async {
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

      final seeds = await container.read(userTasteSeedsProvider.future);

      // Rating exists on song but P1-A doesn't use rating seeds
      expect(seeds.any((s) => s.source == SeedSource.rating), false);
      expect(seeds.every((s) => s.source == SeedSource.favorite), true);
    });

    test('returns empty list on favorite provider error', () async {
      mockFavoriteResult = Result.err(
        AppFailure(type: AppFailureType.server, message: 'Network error'),
      );

      final seeds = await container.read(userTasteSeedsProvider.future);
      expect(seeds.isEmpty, true);
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
