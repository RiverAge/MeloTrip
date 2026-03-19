import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/search/search.dart';
import 'package:melo_trip/provider/song/songs.dart';
import 'package:melo_trip/repository/song/song_repository.dart';

class _MockSongRepository extends SongRepository {
  _MockSongRepository(this._searchResult) : super(() async => Dio());

  final SubsonicResponse? _searchResult;
  bool searchCalled = false;
  SongSearchQuery? lastQuery;

  @override
  Future<SubsonicResponse> fetchSongSearchResponse({
    required SongSearchQuery query,
    CancelToken? cancelToken,
  }) async {
    searchCalled = true;
    lastQuery = query;
    return _searchResult!;
  }
}

void main() {
  group('searchQueryProvider', () {
    test('initializes with empty string', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = container.read(searchQueryProvider);

      expect(result, equals(''));
    });

    test('updates when state is changed', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = 'test';

      expect(container.read(searchQueryProvider), equals('test'));
    });
  });

  group('searchProvider', () {
    test('returns null when query is empty', () async {
      final mockRepository = _MockSongRepository(null);
      final container = ProviderContainer(
        overrides: [
          songRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(searchByQueryProvider('').future);

      expect(result, isNull);
      expect(mockRepository.searchCalled, isFalse);
    });

    test('returns Result.ok from repository', () async {
      final mockResponse = const SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(status: 'ok'),
      );
      final mockRepository = _MockSongRepository(mockResponse);
      final container = ProviderContainer(
        overrides: [
          songRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(searchByQueryProvider('test').future);

      expect(result, isNotNull);
      expect(result?.isOk, isTrue);
      expect(result?.data?.subsonicResponse?.status, equals('ok'));
      expect(mockRepository.searchCalled, isTrue);
      expect(mockRepository.lastQuery, const SongSearchQuery(query: 'test'));
    });

    test('returns Result.err when repository throws', () async {
      final mockRepository = _MockSongRepository(null);
      final container = ProviderContainer(
        overrides: [
          songRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(searchByQueryProvider('test').future);

      expect(result?.isErr, isTrue);
      expect(result?.error, isA<AppFailure>());
      expect(mockRepository.searchCalled, isTrue);
    });
  });

  group('searchProvider', () {
    test('returns null when query is empty', () async {
      final mockRepository = _MockSongRepository(null);
      final container = ProviderContainer(
        overrides: [
          songRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      container.read(searchQueryProvider.notifier).state = '';

      final result = await container.read(searchProvider.future);

      expect(result, isNull);
    });
  });
}

