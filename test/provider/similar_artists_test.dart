import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/artist_info2/artist_info2.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/artist/similar_artists.dart';
import 'package:melo_trip/repository/artist/artist_detail_repository.dart';

/// Tests for similarArtistsProvider.
///
/// Coverage:
/// 1. null artistId returns empty list without calling repository
/// 2. empty artistId returns empty list without calling repository
/// 3. Result.ok with similarArtist returns list
/// 4. Result.ok with null artistInfo2 returns empty list
/// 5. Result.ok with empty similarArtist returns empty list
/// 6. Result.err returns empty list without throwing
void main() {
  group('similarArtistsProvider', () {
    late ProviderContainer container;
    late Result<SubsonicResponse, AppFailure>? mockResult;
    late bool repositoryCalled;
    late String? requestedArtistId;
    late int? requestedCount;

    setUp(() {
      mockResult = null;
      repositoryCalled = false;
      requestedArtistId = null;
      requestedCount = null;

      container = ProviderContainer(
        overrides: [
          artistDetailRepositoryProvider.overrideWith((ref) {
            return _FakeArtistDetailRepository(
              mockFetchArtistInfo2: ({required artistId, count}) {
                repositoryCalled = true;
                requestedArtistId = artistId;
                requestedCount = count;
                return mockResult ??
                    Result.ok(
                      SubsonicResponse(
                        subsonicResponse: SubsonicResponseClass(
                          artistInfo2: null,
                        ),
                      ),
                    );
              },
            );
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('returns empty list for null artistId', () async {
      final artists = await container.read(
        similarArtistsProvider(artistId: null, count: 12).future,
      );

      expect(artists.isEmpty, true);
      expect(repositoryCalled, false);
    });

    test('returns empty list for empty artistId', () async {
      final artists = await container.read(
        similarArtistsProvider(artistId: '', count: 12).future,
      );

      expect(artists.isEmpty, true);
      expect(repositoryCalled, false);
    });

    test('returns artists when Result.ok has similarArtist', () async {
      mockResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            artistInfo2: ArtistInfo2Entity(
              similarArtist: [
                ArtistEntity(id: 'similar-1', name: 'Similar Artist 1'),
                ArtistEntity(id: 'similar-2', name: 'Similar Artist 2'),
              ],
            ),
          ),
        ),
      );

      final artists = await container.read(
        similarArtistsProvider(artistId: 'artist-123', count: 12).future,
      );

      expect(artists.length, 2);
      expect(artists[0].id, 'similar-1');
      expect(artists[1].id, 'similar-2');
      expect(repositoryCalled, true);
      expect(requestedArtistId, 'artist-123');
    });

    test('returns empty list when Result.ok has null artistInfo2', () async {
      mockResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(artistInfo2: null),
        ),
      );

      final artists = await container.read(
        similarArtistsProvider(artistId: 'artist-123', count: 12).future,
      );

      expect(artists.isEmpty, true);
      expect(repositoryCalled, true);
    });

    test('returns empty list when Result.ok has empty similarArtist', () async {
      mockResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(
            artistInfo2: ArtistInfo2Entity(similarArtist: []),
          ),
        ),
      );

      final artists = await container.read(
        similarArtistsProvider(artistId: 'artist-123', count: 12).future,
      );

      expect(artists.isEmpty, true);
      expect(repositoryCalled, true);
    });

    test('returns empty list on Result.err without throwing', () async {
      mockResult = Result.err(
        AppFailure(type: AppFailureType.server, message: 'Server error'),
      );

      // Should not throw
      expect(
        () => container.read(
          similarArtistsProvider(artistId: 'artist-123', count: 12).future,
        ),
        returnsNormally,
      );

      final artists = await container.read(
        similarArtistsProvider(artistId: 'artist-123', count: 12).future,
      );

      expect(artists.isEmpty, true);
      expect(repositoryCalled, true);
    });

    test('passes count parameter to repository', () async {
      mockResult = Result.ok(
        SubsonicResponse(
          subsonicResponse: SubsonicResponseClass(artistInfo2: null),
        ),
      );

      await container.read(
        similarArtistsProvider(artistId: 'artist-123', count: 5).future,
      );

      expect(repositoryCalled, true);
      expect(requestedArtistId, 'artist-123');
      expect(requestedCount, 5);
    });
  });
}

/// Fake implementation of ArtistDetailRepository for testing.
class _FakeArtistDetailRepository extends ArtistDetailRepository {
  final Result<SubsonicResponse, AppFailure> Function({
    required String artistId,
    int? count,
  })
  mockFetchArtistInfo2;

  _FakeArtistDetailRepository({required this.mockFetchArtistInfo2})
    : super(() async => throw UnimplementedError());

  @override
  Future<Result<SubsonicResponse, AppFailure>> tryFetchArtistInfo2({
    required String artistId,
    int? count,
  }) async {
    return mockFetchArtistInfo2(artistId: artistId, count: count);
  }
}
