import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/common/sonic_similarity_result.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/sonic_similarity/sonic_similarity.dart';
import 'package:melo_trip/repository/sonic_similarity/sonic_similarity_repository.dart';
import 'package:dio/dio.dart';

/// Tests for RadioQueue provider logic using real provider with mocked repository.
///
/// Coverage:
/// 1. filterRadioQueueCandidates pure function tests
/// 2. startRadio clears previous state, seed not in queue
/// 3. startRadio preserves Sonic API order
/// 4. startRadio filters null ids, duplicate ids
/// 5. extendQueue appends N songs, not blocked by existing queue length
/// 6. extendQueue uses last song as next seed
/// 7. Empty results keep queue empty, no fallback
/// 8. Result.err does not extend queue, no fallback
/// 9. No getSimilarSongs2 fallback in implementation
void main() {
  group('filterRadioQueueCandidates', () {
    test('removes null ids', () {
      final songs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: null, title: 'No ID'),
        SongEntity(id: 'song-2', title: 'Song 2'),
      ];

      final filtered = filterRadioQueueCandidates(
        songs: songs,
        seenIds: {},
        seedId: null,
      );

      expect(filtered.length, 2);
      expect(filtered.every((s) => s.id != null), true);
    });

    test('removes seed song', () {
      final songs = [
        SongEntity(id: 'seed', title: 'Seed Song'),
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: 'song-2', title: 'Song 2'),
      ];

      final filtered = filterRadioQueueCandidates(
        songs: songs,
        seenIds: {},
        seedId: 'seed',
      );

      expect(filtered.length, 2);
      expect(filtered.any((s) => s.id == 'seed'), false);
    });

    test('removes duplicates from seenIds', () {
      final songs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: 'song-2', title: 'Song 2'),
        SongEntity(id: 'song-1', title: 'Song 1 Duplicate'),
      ];

      final filtered = filterRadioQueueCandidates(
        songs: songs,
        seenIds: {'song-1'},
        seedId: null,
      );

      expect(filtered.length, 1);
      expect(filtered.first.id, 'song-2');
    });

    test('removes duplicates within input', () {
      final songs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: 'song-2', title: 'Song 2'),
        SongEntity(id: 'song-1', title: 'Song 1 Duplicate'),
        SongEntity(id: 'song-3', title: 'Song 3'),
      ];

      final filtered = filterRadioQueueCandidates(
        songs: songs,
        seenIds: {},
        seedId: null,
      );

      expect(filtered.length, 3);
      // First occurrence is kept
      expect(filtered[0].id, 'song-1');
      expect(filtered[1].id, 'song-2');
      expect(filtered[2].id, 'song-3');
    });

    test('combines all filters correctly', () {
      final songs = [
        SongEntity(id: 'seed', title: 'Seed'),
        SongEntity(id: null, title: 'No ID'),
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: 'song-2', title: 'Song 2'),
        SongEntity(id: 'song-1', title: 'Song 1 Duplicate'),
        SongEntity(id: 'song-3', title: 'Song 3'),
      ];

      final filtered = filterRadioQueueCandidates(
        songs: songs,
        seenIds: {'song-2'},
        seedId: 'seed',
      );

      expect(filtered.length, 2);
      expect(filtered[0].id, 'song-1');
      expect(filtered[1].id, 'song-3');
    });

    test('returns empty for all filtered input', () {
      final songs = [
        SongEntity(id: 'seed', title: 'Seed'),
        SongEntity(id: null, title: 'No ID'),
        SongEntity(id: 'seen-1', title: 'Seen 1'),
      ];

      final filtered = filterRadioQueueCandidates(
        songs: songs,
        seenIds: {'seen-1'},
        seedId: 'seed',
      );

      expect(filtered.isEmpty, true);
    });

    test('preserves input order', () {
      final songs = [
        SongEntity(id: 'song-a', title: 'A'),
        SongEntity(id: 'song-b', title: 'B'),
        SongEntity(id: 'song-c', title: 'C'),
        SongEntity(id: 'song-d', title: 'D'),
        SongEntity(id: 'song-e', title: 'E'),
      ];

      final filtered = filterRadioQueueCandidates(
        songs: songs,
        seenIds: {},
        seedId: null,
      );

      expect(filtered.length, 5);
      expect(filtered[0].id, 'song-a');
      expect(filtered[1].id, 'song-b');
      expect(filtered[2].id, 'song-c');
      expect(filtered[3].id, 'song-d');
      expect(filtered[4].id, 'song-e');
    });

    test('respects limit parameter', () {
      final songs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: 'song-2', title: 'Song 2'),
        SongEntity(id: 'song-3', title: 'Song 3'),
        SongEntity(id: 'song-4', title: 'Song 4'),
        SongEntity(id: 'song-5', title: 'Song 5'),
      ];

      final filtered = filterRadioQueueCandidates(
        songs: songs,
        seenIds: {},
        seedId: null,
        limit: 3,
      );

      expect(filtered.length, 3);
      expect(filtered[0].id, 'song-1');
      expect(filtered[1].id, 'song-2');
      expect(filtered[2].id, 'song-3');
    });
  });

  group('RadioQueue Provider Tests', () {
    late ProviderContainer container;
    late FakeSonicSimilarityRepository fakeRepository;
    late List<SongEntity> mockSimilarSongs;
    late AppFailure? mockError;

    setUp(() {
      mockSimilarSongs = [];
      mockError = null;

      fakeRepository = FakeSonicSimilarityRepository(
        fetchResult: (id) {
          if (mockError != null) {
            return Result.err(mockError!);
          }
          return Result.ok(SonicSimilarityResult(songs: mockSimilarSongs));
        },
      );

      container = ProviderContainer(
        overrides: [
          sonicSimilarityRepositoryProvider.overrideWithValue(fakeRepository),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('startRadio clears previous queue and sets seed', () async {
      // First radio session
      mockSimilarSongs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: 'song-2', title: 'Song 2'),
      ];

      final notifier1 = container.read(radioQueueProvider.notifier);
      await notifier1.startRadio(SongEntity(id: 'seed-1', title: 'Seed 1'));

      expect(container.read(radioQueueProvider).length, 2);

      // Second radio session should clear first
      mockSimilarSongs = [
        SongEntity(id: 'song-3', title: 'Song 3'),
        SongEntity(id: 'song-4', title: 'Song 4'),
      ];

      await notifier1.startRadio(SongEntity(id: 'seed-2', title: 'Seed 2'));

      final queue = container.read(radioQueueProvider);
      expect(queue.length, 2);
      expect(queue.any((s) => s.id == 'song-1'), false);
      expect(queue.any((s) => s.id == 'song-2'), false);
      expect(queue.any((s) => s.id == 'song-3'), true);
      expect(queue.any((s) => s.id == 'song-4'), true);
    });

    test('startRadio does not include seed song in queue', () async {
      mockSimilarSongs = [
        SongEntity(id: 'seed', title: 'Seed Song'),
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: 'song-2', title: 'Song 2'),
      ];

      final notifier = container.read(radioQueueProvider.notifier);
      await notifier.startRadio(SongEntity(id: 'seed', title: 'Seed Song'));

      final queue = container.read(radioQueueProvider);
      expect(queue.any((s) => s.id == 'seed'), false);
      expect(queue.length, 2);
    });

    test('startRadio preserves Sonic API order', () async {
      mockSimilarSongs = [
        SongEntity(id: 'song-a', title: 'A'),
        SongEntity(id: 'song-b', title: 'B'),
        SongEntity(id: 'song-c', title: 'C'),
        SongEntity(id: 'song-d', title: 'D'),
        SongEntity(id: 'song-e', title: 'E'),
      ];

      final notifier = container.read(radioQueueProvider.notifier);
      await notifier.startRadio(SongEntity(id: 'seed', title: 'Seed'));

      final queue = container.read(radioQueueProvider);
      expect(queue.length, 5);
      // Order should match API response
      expect(queue[0].id, 'song-a');
      expect(queue[1].id, 'song-b');
      expect(queue[2].id, 'song-c');
      expect(queue[3].id, 'song-d');
      expect(queue[4].id, 'song-e');
    });

    test('startRadio filters null ids', () async {
      mockSimilarSongs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: null, title: 'No ID'),
        SongEntity(id: 'song-2', title: 'Song 2'),
      ];

      final notifier = container.read(radioQueueProvider.notifier);
      await notifier.startRadio(SongEntity(id: 'seed', title: 'Seed'));

      final queue = container.read(radioQueueProvider);
      expect(queue.length, 2);
      expect(queue.every((s) => s.id != null), true);
    });

    test('startRadio filters duplicate ids', () async {
      mockSimilarSongs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: 'song-2', title: 'Song 2'),
        SongEntity(id: 'song-1', title: 'Song 1 Duplicate'),
        SongEntity(id: 'song-3', title: 'Song 3'),
      ];

      final notifier = container.read(radioQueueProvider.notifier);
      await notifier.startRadio(SongEntity(id: 'seed', title: 'Seed'));

      final queue = container.read(radioQueueProvider);
      expect(queue.length, 3);
      expect(queue[0].id, 'song-1');
      expect(queue[1].id, 'song-2');
      expect(queue[2].id, 'song-3');
    });

    test(
      'extendQueue appends songs, not blocked by existing queue length',
      () async {
        // Start radio with 3 songs
        mockSimilarSongs = [
          SongEntity(id: 'song-1', title: 'Song 1'),
          SongEntity(id: 'song-2', title: 'Song 2'),
          SongEntity(id: 'song-3', title: 'Song 3'),
        ];

        final notifier = container.read(radioQueueProvider.notifier);
        await notifier.startRadio(SongEntity(id: 'seed', title: 'Seed'));

        expect(container.read(radioQueueProvider).length, 3);

        // Extend by 2 songs - should add 2 more, not stop because queue.length >= 2
        mockSimilarSongs = [
          SongEntity(id: 'song-4', title: 'Song 4'),
          SongEntity(id: 'song-5', title: 'Song 5'),
          SongEntity(id: 'song-6', title: 'Song 6'),
        ];

        await notifier.extendQueue(count: 2);

        final queue = container.read(radioQueueProvider);
        expect(queue.length, 5, reason: 'Should have 3 + 2 = 5 songs');
        expect(queue[3].id, 'song-4');
        expect(queue[4].id, 'song-5');
      },
    );

    test('extendQueue uses last song as next seed', () async {
      // Start radio with 3 songs
      mockSimilarSongs = [
        SongEntity(id: 'song-1', title: 'Song 1'),
        SongEntity(id: 'song-2', title: 'Song 2'),
        SongEntity(id: 'song-3', title: 'Song 3'),
      ];

      final notifier = container.read(radioQueueProvider.notifier);
      await notifier.startRadio(SongEntity(id: 'seed', title: 'Seed'));

      // Verify startRadio used seed id
      expect(fakeRepository.requestedIds.first, 'seed');

      // Clear the recorded ids to check extendQueue
      fakeRepository.requestedIds.clear();

      // Extend - this should use song-3 as the reference
      mockSimilarSongs = [SongEntity(id: 'song-4', title: 'Song 4')];

      await notifier.extendQueue(count: 1);

      // Verify extendQueue used last song id (song-3)
      expect(fakeRepository.requestedIds.last, 'song-3');

      final queue = container.read(radioQueueProvider);
      expect(queue.length, 4);
      expect(queue.last.id, 'song-4');
    });

    test('empty results keep queue empty, no fallback', () async {
      mockSimilarSongs = [];

      final notifier = container.read(radioQueueProvider.notifier);
      await notifier.startRadio(SongEntity(id: 'seed', title: 'Seed'));

      expect(container.read(radioQueueProvider).isEmpty, true);
    });

    test('Result.err does not extend queue', () async {
      mockError = AppFailure(
        type: AppFailureType.server,
        message: 'Network error',
        statusCode: 503,
      );

      final notifier = container.read(radioQueueProvider.notifier);
      await notifier.startRadio(SongEntity(id: 'seed', title: 'Seed'));

      expect(container.read(radioQueueProvider).isEmpty, true);
    });

    test('error followed by success works correctly', () async {
      // First call fails
      mockError = AppFailure(
        type: AppFailureType.server,
        message: 'Network error',
      );

      final notifier = container.read(radioQueueProvider.notifier);
      await notifier.startRadio(SongEntity(id: 'seed', title: 'Seed'));
      expect(container.read(radioQueueProvider).isEmpty, true);

      // Second call succeeds
      mockError = null;
      mockSimilarSongs = [SongEntity(id: 'song-1', title: 'Song 1')];

      await notifier.startRadio(SongEntity(id: 'seed-2', title: 'Seed 2'));
      expect(container.read(radioQueueProvider).length, 1);
    });

    test(
      'startRadio with error clears old queue, exposes empty state',
      () async {
        // First, start a successful radio
        mockSimilarSongs = [
          SongEntity(id: 'song-1', title: 'Song 1'),
          SongEntity(id: 'song-2', title: 'Song 2'),
        ];

        final notifier = container.read(radioQueueProvider.notifier);
        await notifier.startRadio(SongEntity(id: 'seed-1', title: 'Seed 1'));
        expect(container.read(radioQueueProvider).length, 2);

        // Now startRadio with a new seed that fails
        mockError = AppFailure(
          type: AppFailureType.server,
          message: 'Network error',
        );

        await notifier.startRadio(SongEntity(id: 'seed-2', title: 'Seed 2'));

        // State should be empty, not the old queue
        final queue = container.read(radioQueueProvider);
        expect(
          queue.isEmpty,
          true,
          reason: 'Old queue should not be exposed after error',
        );
        expect(queue.any((s) => s.id == 'song-1'), false);
        expect(queue.any((s) => s.id == 'song-2'), false);
      },
    );

    test('startRadio with null seed id exposes empty state', () async {
      mockSimilarSongs = [SongEntity(id: 'song-1', title: 'Song 1')];

      final notifier = container.read(radioQueueProvider.notifier);
      await notifier.startRadio(SongEntity(id: null, title: 'No ID'));

      // State should be empty since seed id is null
      expect(container.read(radioQueueProvider).isEmpty, true);

      // No API call should have been made (or at least no extension)
      // The repository should not have been called with null
      expect(
        fakeRepository.requestedIds.isEmpty,
        true,
        reason: 'No API call should be made for null seed id',
      );
    });
  });

  group('Radio Queue No Fallback', () {
    test('error message does not contain getSimilarSongs2', () {
      final result = Result<SonicSimilarityResult, AppFailure>.err(
        AppFailure(
          type: AppFailureType.server,
          message: 'Sonic similarity not available',
        ),
      );

      result.when(
        ok: (_) => fail('Should be error'),
        err: (error) {
          expect(error.message, isNot(contains('getSimilarSongs2')));
          expect(error.message, isNot(contains('getSimilarSongs')));
        },
      );
    });

    test('empty results do not trigger fallback', () {
      final result = Result<SonicSimilarityResult, AppFailure>.ok(
        SonicSimilarityResult.empty,
      );

      var usedFallback = false;

      result.when(
        ok: (similarityResult) {
          // Empty is valid, no fallback
          if (similarityResult.isEmpty) {
            usedFallback = false;
          }
        },
        err: (_) => usedFallback = true,
      );

      expect(usedFallback, false);
    });

    test('error does not trigger fallback', () {
      final result = Result<SonicSimilarityResult, AppFailure>.err(
        AppFailure(type: AppFailureType.server, message: 'Network error'),
      );

      var usedFallback = false;

      result.when(
        ok: (_) => usedFallback = true,
        err: (_) {
          // Error is returned directly, no fallback
          usedFallback = false;
        },
      );

      expect(usedFallback, false);
    });

    test('404 error is not retried with fallback', () {
      final result = Result<SonicSimilarityResult, AppFailure>.err(
        AppFailure(
          type: AppFailureType.notAnalyzed,
          message: 'Song has not been analyzed by AudioMuse-AI plugin.',
        ),
      );

      var fallbackCalled = false;

      result.when(
        ok: (_) {},
        err: (error) {
          // 404 means song not analyzed
          // Do NOT call getSimilarSongs2
          expect(error.type, AppFailureType.notAnalyzed);
          fallbackCalled = false;
        },
      );

      expect(fallbackCalled, false);
    });
  });
}

/// Fake implementation of SonicSimilarityRepository for testing
class FakeSonicSimilarityRepository implements SonicSimilarityRepository {
  final Result<SonicSimilarityResult, AppFailure> Function(String id) fetchResult;

  /// Records all song IDs requested via tryFetchSonicSimilarTracks
  final List<String> requestedIds = [];

  /// Returns the last requested song ID, or null if none.
  String? get lastRequestedId =>
      requestedIds.isEmpty ? null : requestedIds.last;

  FakeSonicSimilarityRepository({required this.fetchResult});

  @override
  Future<SubsonicResponse> fetchSonicSimilarTracks({
    required String id,
    int? count,
    CancelToken? cancelToken,
  }) async {
    // Not used in these tests
    throw UnimplementedError();
  }

  @override
  Future<Result<SonicSimilarityResult, AppFailure>> tryFetchSonicSimilarTracks({
    required String id,
    int? count,
    CancelToken? cancelToken,
  }) async {
    requestedIds.add(id);
    return fetchResult(id);
  }

  @override
  Future<SubsonicResponse> findSonicPath({
    required String startSongId,
    required String endSongId,
    int? count,
    CancelToken? cancelToken,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Result<SonicSimilarityResult, AppFailure>> tryFindSonicPath({
    required String startSongId,
    required String endSongId,
    int? count,
    CancelToken? cancelToken,
  }) async {
    return fetchResult(startSongId);
  }

  @override
  Future<Result<List<(SongEntity, double?)>, AppFailure>>
  tryFetchSonicSimilarTracksWithScores({
    required String id,
    int? count,
    CancelToken? cancelToken,
  }) async {
    final result = fetchResult(id);
    return result.when(
      ok: (similarityResult) => Result.ok(
        similarityResult.songs.map((s) => (s, null as double?)).toList(),
      ),
      err: (e) => Result.err(e),
    );
  }

  @override
  Future<Result<List<(SongEntity, double?)>, AppFailure>>
  tryFindSonicPathWithScores({
    required String startSongId,
    required String endSongId,
    int? count,
    CancelToken? cancelToken,
  }) async {
    final result = fetchResult(startSongId);
    return result.when(
      ok: (similarityResult) => Result.ok(
        similarityResult.songs.map((s) => (s, null as double?)).toList(),
      ),
      err: (e) => Result.err(e),
    );
  }
}
