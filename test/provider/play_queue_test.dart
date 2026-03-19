import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/response/play_queue/play_queue.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/play_queue/play_queue.dart';
import 'package:melo_trip/repository/play_queue/play_queue_repository.dart';

class _MockPlayQueueRepository extends PlayQueueRepository {
  _MockPlayQueueRepository(this._fetchResult) : super(() async => Dio());

  final SubsonicResponse? _fetchResult;
  bool fetchCalled = false;

  @override
  Future<SubsonicResponse> fetchPlayQueue() async {
    fetchCalled = true;
    return _fetchResult!;
  }
}

void main() {
  group('playQueueProvider', () {
    test('returns Result.err when repository throws', () async {
      final mockRepository = _MockPlayQueueRepository(null);
      final container = ProviderContainer(
        overrides: [
          playQueueRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(playQueueProvider.future);

      expect(result.isErr, isTrue);
      expect(result.error, isA<AppFailure>());
      expect(mockRepository.fetchCalled, isTrue);
    });

    test('returns Result.ok play queue from repository', () async {
      final mockResponse = SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(
          status: 'ok',
          playQueue: PlayQueueEntity(
            current: 'song-1',
            position: 100,
          ),
        ),
      );
      final mockRepository = _MockPlayQueueRepository(mockResponse);
      final container = ProviderContainer(
        overrides: [
          playQueueRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(playQueueProvider.future);

      expect(result, isNotNull);
      expect(result.isOk, isTrue);
      expect(result.data?.subsonicResponse?.status, equals('ok'));
      expect(result.data?.subsonicResponse?.playQueue?.current, equals('song-1'));
      expect(mockRepository.fetchCalled, isTrue);
    });
  });
}
