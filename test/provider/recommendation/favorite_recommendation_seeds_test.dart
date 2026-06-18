import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/starred/starred.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:melo_trip/provider/recommendation/favorite_recommendation_seeds.dart';

/// Tests for favorite recommendation seeds extraction.
///
/// Coverage:
/// 1. Pure function extractFavoriteSeedSongIds
/// 2. Provider favoriteRecommendationSeeds
void main() {
  group('extractFavoriteSeedSongIds pure function', () {
    test('returns empty list for empty input', () {
      final result = extractFavoriteSeedSongIds([]);
      expect(result.isEmpty, true);
    });

    test('extracts ids from songs', () {
      final songs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: 'song-2', title: 'Song 2'),
        SongEntity(id: 'song-3', title: 'Song 3'),
      ];

      final result = extractFavoriteSeedSongIds(songs);
      expect(result.length, 3);
      expect(result, ['song-1', 'song-2', 'song-3']);
    });

    test('filters out null ids', () {
      final songs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: null, title: 'No ID'),
        SongEntity(id: 'song-2', title: 'Song 2'),
      ];

      final result = extractFavoriteSeedSongIds(songs);
      expect(result.length, 2);
      expect(result, ['song-1', 'song-2']);
    });

    test('filters out empty string ids', () {
      final songs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: '', title: 'Empty ID'),
        SongEntity(id: 'song-2', title: 'Song 2'),
      ];

      final result = extractFavoriteSeedSongIds(songs);
      expect(result.length, 2);
      expect(result, ['song-1', 'song-2']);
    });

    test('removes duplicates keeping first occurrence', () {
      final songs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: 'song-2', title: 'Song 2'),
        SongEntity(id: 'song-1', title: 'Song 1 Duplicate'),
        SongEntity(id: 'song-3', title: 'Song 3'),
      ];

      final result = extractFavoriteSeedSongIds(songs);
      expect(result.length, 3);
      expect(result, ['song-1', 'song-2', 'song-3']);
    });

    test('respects maxSeeds parameter', () {
      final songs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: 'song-2', title: 'Song 2'),
        SongEntity(id: 'song-3', title: 'Song 3'),
        SongEntity(id: 'song-4', title: 'Song 4'),
        SongEntity(id: 'song-5', title: 'Song 5'),
        SongEntity(id: 'song-6', title: 'Song 6'),
      ];

      final result = extractFavoriteSeedSongIds(songs, maxSeeds: 3);
      expect(result.length, 3);
      expect(result, ['song-1', 'song-2', 'song-3']);
    });

    test('preserves input order', () {
      final songs = [
        SongEntity(id: 'song-c', title: 'C'),
        SongEntity(id: 'song-a', title: 'A'),
        SongEntity(id: 'song-b', title: 'B'),
      ];

      final result = extractFavoriteSeedSongIds(songs);
      expect(result, ['song-c', 'song-a', 'song-b']);
    });

    test('default maxSeeds is 5', () {
      final songs = List.generate(
        10,
        (i) => SongEntity(id: 'song-$i', title: 'Song $i'),
      );

      final result = extractFavoriteSeedSongIds(songs);
      expect(result.length, 5);
    });
  });

  group('favoriteRecommendationSeeds Provider', () {
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
          favoriteRecommendationSeedsProvider().future,
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
          favoriteRecommendationSeedsProvider().future,
        );
        expect(seeds.isEmpty, true);
      },
    );

    test('extracts ids from starred songs', () async {
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

      final seeds = await container.read(
        favoriteRecommendationSeedsProvider().future,
      );
      expect(seeds.length, 2);
      expect(seeds, ['fav-1', 'fav-2']);
    });

    test('returns empty list when favoriteProvider returns error', () async {
      mockFavoriteResult = Result.err(
        AppFailure(type: AppFailureType.server, message: 'Network error'),
      );

      final seeds = await container.read(
        favoriteRecommendationSeedsProvider().future,
      );
      expect(seeds.isEmpty, true);
    });

    test('respects maxSeeds parameter', () async {
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
        favoriteRecommendationSeedsProvider(maxSeeds: 3).future,
      );
      expect(seeds.length, 3);
      expect(seeds, ['fav-1', 'fav-2', 'fav-3']);
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
