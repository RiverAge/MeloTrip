import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/repository/album/album_detail_repository.dart';

class _MockAlbumDetailRepository extends AlbumDetailRepository {
  _MockAlbumDetailRepository({
    required this.detailResult,
    required this.toggleResult,
    required this.ratingResult,
  }) : super(() async => Dio());

  final Result<SubsonicResponse, AppFailure> detailResult;
  final Result<SubsonicResponse, AppFailure> toggleResult;
  final Result<SubsonicResponse, AppFailure> ratingResult;

  bool detailCalled = false;
  bool toggleCalled = false;
  bool ratingCalled = false;
  String? lastAlbumId;
  bool? lastIsStarred;
  int? lastRating;

  @override
  Future<Result<SubsonicResponse, AppFailure>> fetchAlbumDetailResult(
    String albumId,
  ) async {
    detailCalled = true;
    lastAlbumId = albumId;
    return detailResult;
  }

  @override
  Future<Result<SubsonicResponse, AppFailure>> toggleFavoriteResult({
    required String albumId,
    required bool isStarred,
  }) async {
    toggleCalled = true;
    lastAlbumId = albumId;
    lastIsStarred = isStarred;
    return toggleResult;
  }

  @override
  Future<Result<SubsonicResponse, AppFailure>> setRatingResult({
    required String albumId,
    required int rating,
  }) async {
    ratingCalled = true;
    lastAlbumId = albumId;
    lastRating = rating;
    return ratingResult;
  }
}

void main() {
  const okResponse = SubsonicResponse(
    subsonicResponse: SubsonicResponseClass(status: 'ok'),
  );

  group('albumDetailProvider', () {
    test('returns null when albumId is null', () async {
      final mockRepository = _MockAlbumDetailRepository(
        detailResult: const Result.ok(okResponse),
        toggleResult: const Result.ok(okResponse),
        ratingResult: const Result.ok(okResponse),
      );
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

    test('returns Result.ok album detail from repository', () async {
      final mockRepository = _MockAlbumDetailRepository(
        detailResult: const Result.ok(okResponse),
        toggleResult: const Result.ok(okResponse),
        ratingResult: const Result.ok(okResponse),
      );
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(albumDetailProvider('123').future);

      expect(result?.isOk, isTrue);
      expect(result?.data?.subsonicResponse?.status, 'ok');
      expect(mockRepository.detailCalled, isTrue);
      expect(mockRepository.lastAlbumId, '123');
    });

    test('returns Result.err when repository returns error result', () async {
      final mockRepository = _MockAlbumDetailRepository(
        detailResult: const Result.err(
          AppFailure(type: AppFailureType.unknown, message: 'mock-error'),
        ),
        toggleResult: const Result.ok(okResponse),
        ratingResult: const Result.ok(okResponse),
      );
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(albumDetailProvider('123').future);

      expect(result?.isErr, isTrue);
      expect(result?.error, isA<AppFailure>());
    });
  });

  group('albumDetailProvider toggleFavoriteResult', () {
    test('returns null when family albumId is null', () async {
      final mockRepository = _MockAlbumDetailRepository(
        detailResult: const Result.ok(okResponse),
        toggleResult: const Result.ok(okResponse),
        ratingResult: const Result.ok(okResponse),
      );
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(albumDetailProvider(null).notifier);
      final result = await notifier.toggleFavoriteResult();

      expect(result, isNull);
      expect(mockRepository.toggleCalled, isFalse);
    });

    test('calls repository toggleFavoriteResult', () async {
      final mockRepository = _MockAlbumDetailRepository(
        detailResult: const Result.ok(okResponse),
        toggleResult: const Result.ok(okResponse),
        ratingResult: const Result.ok(okResponse),
      );
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(albumDetailProvider('123').notifier);
      final result = await notifier.toggleFavoriteResult();

      expect(result?.isOk, isTrue);
      expect(mockRepository.toggleCalled, isTrue);
      expect(mockRepository.lastAlbumId, '123');
    });
  });

  group('albumDetailProvider setRatingResult', () {
    test('returns null when family albumId is null', () async {
      final mockRepository = _MockAlbumDetailRepository(
        detailResult: const Result.ok(okResponse),
        toggleResult: const Result.ok(okResponse),
        ratingResult: const Result.ok(okResponse),
      );
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(albumDetailProvider(null).notifier);
      final result = await notifier.setRatingResult(5);

      expect(result, isNull);
      expect(mockRepository.ratingCalled, isFalse);
    });

    test('returns null when rating is null', () async {
      final mockRepository = _MockAlbumDetailRepository(
        detailResult: const Result.ok(okResponse),
        toggleResult: const Result.ok(okResponse),
        ratingResult: const Result.ok(okResponse),
      );
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(albumDetailProvider('123').notifier);
      final result = await notifier.setRatingResult(null);

      expect(result, isNull);
      expect(mockRepository.ratingCalled, isFalse);
    });

    test('calls repository setRatingResult', () async {
      final mockRepository = _MockAlbumDetailRepository(
        detailResult: const Result.ok(okResponse),
        toggleResult: const Result.ok(okResponse),
        ratingResult: const Result.ok(okResponse),
      );
      final container = ProviderContainer(
        overrides: [
          albumDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(albumDetailProvider('123').notifier);
      final result = await notifier.setRatingResult(5);

      expect(result?.isOk, isTrue);
      expect(mockRepository.ratingCalled, isTrue);
      expect(mockRepository.lastAlbumId, '123');
      expect(mockRepository.lastRating, 5);
    });
  });
}
