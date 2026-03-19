import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/song/song_detail.dart';
import 'package:melo_trip/repository/song/song_detail_repository.dart';

class _MockSongDetailRepository extends SongDetailRepository {
  _MockSongDetailRepository() : super(() async => Dio());

  Result<SubsonicResponse, AppFailure>? _fetchResult;
  bool fetchCalled = false;
  String? lastSongId;

  void setFetchResult(Result<SubsonicResponse, AppFailure> result) {
    _fetchResult = result;
  }

  @override
  Future<Result<SubsonicResponse, AppFailure>> tryFetchSongDetail(
    String songId,
  ) async {
    fetchCalled = true;
    lastSongId = songId;
    return _fetchResult!;
  }
}

void main() {
  group('songDetailProvider', () {
    test('returns Result.err when repository returns error result', () async {
      final mockRepository = _MockSongDetailRepository();
      mockRepository.setFetchResult(
        const Result.err(
          AppFailure(type: AppFailureType.unknown, message: 'mock-error'),
        ),
      );

      final container = ProviderContainer(
        overrides: [
          songDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        songDetailProvider('song-123').future,
      );
      expect(result?.isErr, isTrue);
      expect(mockRepository.fetchCalled, isTrue);
      expect(mockRepository.lastSongId, 'song-123');
    });

    test('returns Result.ok with song detail from repository', () async {
      final mockResponse = SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(
          status: 'ok',
          song: SongEntity(
            id: 'song-123',
            title: 'Test Song',
            artist: 'Test Artist',
          ),
        ),
      );
      final mockRepository = _MockSongDetailRepository();
      mockRepository.setFetchResult(Result.ok(mockResponse));

      final container = ProviderContainer(
        overrides: [
          songDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(
        songDetailProvider('song-123').future,
      );

      expect(result, isNotNull);
      expect(result?.isOk, isTrue);
      expect(result?.data?.subsonicResponse?.status, equals('ok'));
      expect(result?.data?.subsonicResponse?.song?.id, equals('song-123'));
      expect(result?.data?.subsonicResponse?.song?.title, equals('Test Song'));
    });
  });
}
