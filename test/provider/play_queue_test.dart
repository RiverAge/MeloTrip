import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/play_queue/play_queue.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/play_queue/play_queue.dart';
import 'package:melo_trip/repository/play_queue/play_queue_repository.dart';

class _MockPlayQueueRepository extends PlayQueueRepository {
  _MockPlayQueueRepository(this._fetchResult) : super(() async => Dio());

  final SubsonicResponse? _fetchResult;
  bool fetchCalled = false;

  @override
  Future<SubsonicResponse?> fetchPlayQueue() async {
    fetchCalled = true;
    return _fetchResult;
  }
}

void main() {
  group('playQueueProvider', () {
    test('returns null when repository returns null', () async {
      final mockRepository = _MockPlayQueueRepository(null);
      final container = ProviderContainer(
        overrides: [
          playQueueRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(playQueueProvider.future);

      expect(result, isNull);
      expect(mockRepository.fetchCalled, isTrue);
    });

    test('returns play queue from repository', () async {
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
      expect(result?.subsonicResponse?.status, equals('ok'));
      expect(result?.subsonicResponse?.playQueue?.current, equals('song-1'));
      expect(mockRepository.fetchCalled, isTrue);
    });
  });
}
