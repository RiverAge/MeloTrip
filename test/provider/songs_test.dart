import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/song/songs.dart';
import 'package:melo_trip/repository/song/song_repository.dart';

void main() {
  group('SongSearchQuery', () {
    test('toQueryParameters includes all non-null values', () {
      const query = SongSearchQuery(
        query: 'test',
        songCount: 10,
        songOffset: 5,
        albumCount: 3,
        artistCount: 2,
      );

      final params = query.toQueryParameters();

      expect(params['query'], 'test');
      expect(params['songCount'], 10);
      expect(params['songOffset'], 5);
      expect(params['albumCount'], 3);
      expect(params['artistCount'], 2);
    });

    test('toQueryParameters omits null values', () {
      const query = SongSearchQuery(query: 'test');

      final params = query.toQueryParameters();

      expect(params['query'], 'test');
      expect(params.containsKey('songCount'), isFalse);
      expect(params.containsKey('songOffset'), isFalse);
    });

    test('copyWith creates modified copy', () {
      const original = SongSearchQuery(query: 'original', songCount: 10);

      final modified = original.copyWith(query: 'modified', songCount: 20);

      expect(modified.query, 'modified');
      expect(modified.songCount, 20);
    });

    test('copyWith preserves unchanged values', () {
      const original = SongSearchQuery(
        query: 'original',
        songCount: 10,
        songOffset: 5,
      );

      final modified = original.copyWith(query: 'modified');

      expect(modified.query, 'modified');
      expect(modified.songCount, 10);
      expect(modified.songOffset, 5);
    });

    test('equality works correctly', () {
      const query1 = SongSearchQuery(query: 'test', songCount: 10);
      const query2 = SongSearchQuery(query: 'test', songCount: 10);
      const query3 = SongSearchQuery(query: 'test', songCount: 20);

      expect(query1, equals(query2));
      expect(query1, isNot(equals(query3)));
    });

    test('hashCode is consistent with equality', () {
      const query1 = SongSearchQuery(query: 'test', songCount: 10);
      const query2 = SongSearchQuery(query: 'test', songCount: 10);

      expect(query1.hashCode, equals(query2.hashCode));
    });
  });

  group('PaginatedSongList', () {
    late ProviderContainer container;
    late List<SongEntity> mockSongs;

    setUp(() {
      mockSongs = [
        SongEntity(id: 'song-1', title: 'Song One'),
        SongEntity(id: 'song-2', title: 'Song Two'),
        SongEntity(id: 'song-3', title: 'Song Three'),
      ];

      container = ProviderContainer(
        overrides: [
          songRepositoryProvider.overrideWith((ref) {
            return _MockSongRepository(mockSongs);
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('build returns empty snapshot initially', () {
      const query = SongSearchQuery(query: 'test');
      final snapshot = container.read(paginatedSongListProvider(query));

      expect(snapshot.items, isEmpty);
    });

    test('loadInitial populates items from repository', () async {
      const query = SongSearchQuery(query: 'test', songCount: 10);
      container.read(paginatedSongListProvider(query).notifier).loadInitial();

      await Future.delayed(const Duration(milliseconds: 100));

      final snapshot = container.read(paginatedSongListProvider(query));
      expect(snapshot.items, hasLength(3));
      expect(snapshot.items[0].id, 'song-1');
    });

    test('loadMore appends items to existing list', () async {
      final extendedSongs = [
        ...mockSongs,
        SongEntity(id: 'song-4', title: 'Song Four'),
        SongEntity(id: 'song-5', title: 'Song Five'),
        SongEntity(id: 'song-6', title: 'Song Six'),
      ];

      final container2 = ProviderContainer(
        overrides: [
          songRepositoryProvider.overrideWith((ref) {
            return _MockSongRepository(extendedSongs);
          }),
        ],
      );

      const query = SongSearchQuery(query: 'test', songCount: 3);
      container2.read(paginatedSongListProvider(query).notifier).loadInitial();

      await Future.delayed(const Duration(milliseconds: 100));

      container2.read(paginatedSongListProvider(query).notifier).loadMore();

      await Future.delayed(const Duration(milliseconds: 100));

      final snapshot = container2.read(paginatedSongListProvider(query));
      expect(snapshot.items.length, greaterThanOrEqualTo(3));

      container2.dispose();
    });

    test('refresh reloads data from start', () async {
      const query = SongSearchQuery(query: 'test', songCount: 10);
      container.read(paginatedSongListProvider(query).notifier).loadInitial();

      await Future.delayed(const Duration(milliseconds: 100));

      await container.read(paginatedSongListProvider(query).notifier).refresh();

      final snapshot = container.read(paginatedSongListProvider(query));
      expect(snapshot.items, hasLength(3));
    });
  });
}

class _MockSongRepository extends SongRepository {
  final List<SongEntity> _songs;

  _MockSongRepository(this._songs) : super(() async => Dio());

  @override
  Future<List<SongEntity>> fetchSongSearchItems({
    required SongSearchQuery query,
    CancelToken? cancelToken,
  }) async {
    final offset = query.songOffset ?? 0;
    final count = query.songCount ?? _songs.length;

    if (offset >= _songs.length) return [];

    final end = (offset + count).clamp(0, _songs.length);
    return _songs.sublist(offset, end);
  }

  @override
  Future<Result<List<SongEntity>, AppFailure>> tryFetchSongSearchItems({
    required SongSearchQuery query,
    CancelToken? cancelToken,
  }) async {
    final items = await fetchSongSearchItems(query: query, cancelToken: cancelToken);
    return Result.ok(items);
  }
}
