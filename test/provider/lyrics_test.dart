import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/lyrics/lyrics.dart';
import 'package:melo_trip/repository/lyrics/lyrics_repository.dart';

class _MockLyricsRepository extends LyricsRepository {
  _MockLyricsRepository(this._fetchResult) : super(() async => Dio());

  final SubsonicResponse? _fetchResult;
  bool tryFetchMergedCalled = false;

  @override
  Future<Result<SubsonicResponse, AppFailure>> tryFetchMergedLyrics(
    String songId,
  ) async {
    tryFetchMergedCalled = true;
    final response = _fetchResult;
    if (response == null) {
      return const Result.err(
        AppFailure(type: AppFailureType.unknown, message: 'mock-error'),
      );
    }
    return Result.ok(response);
  }
}

void main() {
  group('lyricsProvider', () {
    test('returns null when songId is null', () async {
      final mockRepository = _MockLyricsRepository(null);
      final container = ProviderContainer(
        overrides: [
          lyricsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(lyricsProvider(null).future);

      expect(result, isNull);
      expect(mockRepository.tryFetchMergedCalled, isFalse);
    });

    test('returns Result.err when repository throws', () async {
      final mockRepository = _MockLyricsRepository(null);
      final container = ProviderContainer(
        overrides: [
          lyricsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(lyricsProvider('song123').future);

      expect(result?.isErr, isTrue);
      expect(result?.error, isA<AppFailure>());
      expect(mockRepository.tryFetchMergedCalled, isTrue);
    });

    test('returns Result.ok lyrics response from repository', () async {
      final mockResponse = const SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(
          status: 'ok',
        ),
      );
      final mockRepository = _MockLyricsRepository(mockResponse);
      final container = ProviderContainer(
        overrides: [
          lyricsRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(lyricsProvider('song123').future);

      expect(result, isNotNull);
      expect(result?.isOk, isTrue);
      expect(result?.data?.subsonicResponse?.status, equals('ok'));
      expect(mockRepository.tryFetchMergedCalled, isTrue);
    });
  });
}
