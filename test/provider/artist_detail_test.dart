import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/artist/artist_detail.dart';
import 'package:melo_trip/repository/artist/artist_detail_repository.dart';

class _MockArtistDetailRepository extends ArtistDetailRepository {
  _MockArtistDetailRepository() : super(() async => Dio());

  SubsonicResponse? _fetchResult;
  bool fetchCalled = false;
  String? lastArtistId;

  void setFetchResult(SubsonicResponse? result) {
    _fetchResult = result;
  }

  @override
  Future<SubsonicResponse> fetchArtistDetail(String artistId) async {
    fetchCalled = true;
    lastArtistId = artistId;
    return _fetchResult!;
  }
}

void main() {
  group('artistDetailResultProvider', () {
    test('returns null when artistId is null', () async {
      final mockRepository = _MockArtistDetailRepository();
      final container = ProviderContainer(
        overrides: [
          artistDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(artistDetailResultProvider(null).future);

      expect(result, isNull);
      expect(mockRepository.fetchCalled, isFalse);
    });

    test('returns Result.err when repository throws', () async {
      final mockRepository = _MockArtistDetailRepository();
      mockRepository.setFetchResult(null);

      final container = ProviderContainer(
        overrides: [
          artistDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(artistDetailResultProvider('artist-123').future);

      expect(result?.isErr, isTrue);
      expect(result?.error, isA<AppFailure>());
      expect(mockRepository.fetchCalled, isTrue);
      expect(mockRepository.lastArtistId, 'artist-123');
    });

    test('returns Result.ok on success', () async {
      final mockResponse = SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(
          status: 'ok',
          artist: ArtistEntity(
            id: 'artist-123',
            name: 'Test Artist',
            albumCount: 10,
          ),
        ),
      );
      final mockRepository = _MockArtistDetailRepository();
      mockRepository.setFetchResult(mockResponse);

      final container = ProviderContainer(
        overrides: [
          artistDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(artistDetailResultProvider('artist-123').future);

      expect(result, isNotNull);
      expect(result?.isOk, isTrue);
      expect(result?.data?.subsonicResponse?.status, equals('ok'));
      expect(result?.data?.subsonicResponse?.artist?.id, equals('artist-123'));
      expect(result?.data?.subsonicResponse?.artist?.name, equals('Test Artist'));
    });
  });
}
