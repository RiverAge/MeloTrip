import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/repository/album/album_detail_repository.dart';

class _MockAlbumDetailRepository extends AlbumDetailRepository {
  _MockAlbumDetailRepository(this._detailResult) : super(() async => Dio());

  final SubsonicResponse? _detailResult;
  bool detailCalled = false;
  bool toggleCalled = false;
  bool ratingCalled = false;

  @override
  Future<SubsonicResponse?> fetchAlbumDetail(String albumId) async {
    detailCalled = true;
    return _detailResult;
  }

  @override
  Future<SubsonicResponse?> toggleFavorite({
    required String albumId,
    required bool isStarred,
  }) async {
    toggleCalled = true;
    return _detailResult;
  }

  @override
  Future<SubsonicResponse?> setRating({
    required String albumId,
    required int rating,
  }) async {
    ratingCalled = true;
    return _detailResult;
  }
}

void main() {
  group('albumDetailProvider', () {
    test('returns null when albumId is null', () async {
      final mockRepository = _MockAlbumDetailRepository(null);
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(albumDetailProvider(null).future);

      expect(result, isNull);
      expect(mockRepository.detailCalled, isFalse);
    });

    test('returns album detail from repository', () async {
      final mockResponse = const SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(status: 'ok'),
      );
      final mockRepository = _MockAlbumDetailRepository(mockResponse);
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(albumDetailProvider('123').future);

      expect(result, isNotNull);
      expect(result?.subsonicResponse?.status, equals('ok'));
      expect(mockRepository.detailCalled, isTrue);
    });
  });

  group('AlbumFavorite', () {
    test('toggleFavorite returns null when album is null', () async {
      final mockRepository = _MockAlbumDetailRepository(null);
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(albumFavoriteProvider.notifier);
      final result = await notifier.toggleFavorite(null);

      expect(result, isNull);
      expect(mockRepository.toggleCalled, isFalse);
    });

    test('toggleFavorite returns null when album id is null', () async {
      final mockRepository = _MockAlbumDetailRepository(null);
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(albumFavoriteProvider.notifier);
      final album = const AlbumEntity(id: null);
      final result = await notifier.toggleFavorite(album);

      expect(result, isNull);
      expect(mockRepository.toggleCalled, isFalse);
    });
  });

  group('AlbumRating', () {
    test('updateRating returns null when albumId is null', () async {
      final mockRepository = _MockAlbumDetailRepository(null);
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(albumRatingProvider.notifier);
      final result = await notifier.updateRating(null, 5);

      expect(result, isNull);
      expect(mockRepository.ratingCalled, isFalse);
    });

    test('updateRating returns null when rating is null', () async {
      final mockRepository = _MockAlbumDetailRepository(null);
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(albumRatingProvider.notifier);
      final result = await notifier.updateRating('123', null);

      expect(result, isNull);
      expect(mockRepository.ratingCalled, isFalse);
    });

    test('updateRating calls repository and invalidates on success', () async {
      final mockResponse = const SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(status: 'ok'),
      );
      final mockRepository = _MockAlbumDetailRepository(mockResponse);
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(albumRatingProvider.notifier);
      final result = await notifier.updateRating('123', 5);

      expect(result, isNotNull);
      expect(result?.subsonicResponse?.status, equals('ok'));
      expect(mockRepository.ratingCalled, isTrue);
    });
  });
}
