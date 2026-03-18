import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/song/song_detail.dart';
import 'package:melo_trip/repository/song/song_detail_repository.dart';

class _MockSongDetailRepository extends SongDetailRepository {
  _MockSongDetailRepository() : super(() async => Dio());

  SubsonicResponse? _fetchResult;
  bool fetchCalled = false;
  String? lastSongId;

  void setFetchResult(SubsonicResponse? result) {
    _fetchResult = result;
  }

  @override
  Future<SubsonicResponse> fetchSongDetail(String songId) async {
    fetchCalled = true;
    lastSongId = songId;
    return _fetchResult!;
  }
}

void main() {
  group('songDetailProvider', () {
    test('throws when repository throws', () async {
      final mockRepository = _MockSongDetailRepository();
      mockRepository.setFetchResult(null);

      final container = ProviderContainer(
        overrides: [
          songDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      await expectLater(
        container.read(songDetailProvider('song-123').future),
        throwsA(isA<TypeError>()),
      );
      expect(mockRepository.fetchCalled, isTrue);
      expect(mockRepository.lastSongId, 'song-123');
    });

    test('returns song detail from repository', () async {
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
      mockRepository.setFetchResult(mockResponse);

      final container = ProviderContainer(
        overrides: [
          songDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(songDetailProvider('song-123').future);

      expect(result, isNotNull);
      expect(result?.subsonicResponse?.status, equals('ok'));
      expect(result?.subsonicResponse?.song?.id, equals('song-123'));
      expect(result?.subsonicResponse?.song?.title, equals('Test Song'));
    });

    test('songDetailResult returns Result.err when repository throws', () async {
      final mockRepository = _MockSongDetailRepository();
      mockRepository.setFetchResult(null);

      final container = ProviderContainer(
        overrides: [
          songDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(songDetailResultProvider('song-123').future);

      expect(result, isNotNull);
      expect(result?.isErr, isTrue);
      expect(result?.error, isA<AppFailure>());
    });

    test('songDetailResult returns Result.ok on success', () async {
      final mockResponse = SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(
          status: 'ok',
          song: SongEntity(id: 'song-123', title: 'OK Song'),
        ),
      );
      final mockRepository = _MockSongDetailRepository();
      mockRepository.setFetchResult(mockResponse);

      final container = ProviderContainer(
        overrides: [
          songDetailRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(songDetailResultProvider('song-123').future);

      expect(result?.isOk, isTrue);
      expect(result?.data?.subsonicResponse?.song?.title, 'OK Song');
    });
  });
}
