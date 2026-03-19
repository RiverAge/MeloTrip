import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/repository/album/album_repository.dart';

void main() {
  group('AlbumListQuery', () {
    test('toQueryParameters includes all non-null values', () {
      const query = AlbumListQuery(
        type: 'newest',
        size: 20,
        offset: 10,
        genre: 'Rock',
      );

      final params = query.toQueryParameters();

      expect(params['type'], 'newest');
      expect(params['size'], 20);
      expect(params['offset'], 10);
      expect(params['genre'], 'Rock');
    });

    test('toQueryParameters omits null values', () {
      const query = AlbumListQuery(type: 'random');

      final params = query.toQueryParameters();

      expect(params['type'], 'random');
      expect(params.containsKey('size'), isFalse);
      expect(params.containsKey('offset'), isFalse);
      expect(params.containsKey('genre'), isFalse);
    });

    test('copyWith creates modified copy', () {
      const original = AlbumListQuery(type: 'newest', size: 10);

      final modified = original.copyWith(type: 'random', size: 20);

      expect(modified.type, 'random');
      expect(modified.size, 20);
    });

    test('copyWith preserves unchanged values', () {
      const original = AlbumListQuery(
        type: 'newest',
        size: 10,
        offset: 5,
      );

      final modified = original.copyWith(type: 'random');

      expect(modified.type, 'random');
      expect(modified.size, 10);
      expect(modified.offset, 5);
    });

    test('equality works correctly', () {
      const query1 = AlbumListQuery(type: 'newest', size: 10);
      const query2 = AlbumListQuery(type: 'newest', size: 10);
      const query3 = AlbumListQuery(type: 'newest', size: 20);

      expect(query1, equals(query2));
      expect(query1, isNot(equals(query3)));
    });

    test('hashCode is consistent with equality', () {
      const query1 = AlbumListQuery(type: 'newest', size: 10);
      const query2 = AlbumListQuery(type: 'newest', size: 10);

      expect(query1.hashCode, equals(query2.hashCode));
    });
  });

  group('AlbumListType', () {
    test('contains expected values', () {
      expect(AlbumListType.values, contains(AlbumListType.random));
      expect(AlbumListType.values, contains(AlbumListType.newest));
      expect(AlbumListType.values, contains(AlbumListType.recent));
      expect(AlbumListType.values, contains(AlbumListType.frequent));
    });

    test('name property returns correct string', () {
      expect(AlbumListType.random.name, 'random');
      expect(AlbumListType.newest.name, 'newest');
      expect(AlbumListType.recent.name, 'recent');
      expect(AlbumListType.frequent.name, 'frequent');
    });
  });

  group('PaginatedAlbumList', () {
    late ProviderContainer container;
    late List<AlbumEntity> mockAlbums;

    setUp(() {
      mockAlbums = [
        AlbumEntity(id: 'album-1', name: 'Album One'),
        AlbumEntity(id: 'album-2', name: 'Album Two'),
        AlbumEntity(id: 'album-3', name: 'Album Three'),
      ];

      container = ProviderContainer(
        overrides: [
          albumRepositoryProvider.overrideWith((ref) {
            return _MockAlbumRepository(mockAlbums);
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('build returns empty snapshot initially', () {
      const query = AlbumListQuery(type: 'newest');
      final snapshot = container.read(paginatedAlbumListProvider(query));

      expect(snapshot.items, isEmpty);
    });

    test('loadInitial populates items from repository', () async {
      const query = AlbumListQuery(type: 'newest', size: 10);
      container.read(paginatedAlbumListProvider(query).notifier).loadInitial();

      await Future.delayed(const Duration(milliseconds: 100));

      final snapshot = container.read(paginatedAlbumListProvider(query));
      expect(snapshot.items, hasLength(3));
      expect(snapshot.items[0].id, 'album-1');
    });

    test('loadMore appends items to existing list', () async {
      final extendedAlbums = [
        ...mockAlbums,
        AlbumEntity(id: 'album-4', name: 'Album Four'),
        AlbumEntity(id: 'album-5', name: 'Album Five'),
        AlbumEntity(id: 'album-6', name: 'Album Six'),
      ];

      final container2 = ProviderContainer(
        overrides: [
          albumRepositoryProvider.overrideWith((ref) {
            return _MockAlbumRepository(extendedAlbums);
          }),
        ],
      );

      const query = AlbumListQuery(type: 'newest', size: 3);
      container2.read(paginatedAlbumListProvider(query).notifier).loadInitial();

      await Future.delayed(const Duration(milliseconds: 100));

      container2.read(paginatedAlbumListProvider(query).notifier).loadMore();

      await Future.delayed(const Duration(milliseconds: 100));

      final snapshot = container2.read(paginatedAlbumListProvider(query));
      expect(snapshot.items.length, greaterThanOrEqualTo(3));

      container2.dispose();
    });

    test('refresh reloads data from start', () async {
      const query = AlbumListQuery(type: 'newest', size: 10);
      container.read(paginatedAlbumListProvider(query).notifier).loadInitial();

      await Future.delayed(const Duration(milliseconds: 100));

      await container.read(paginatedAlbumListProvider(query).notifier).refresh();

      final snapshot = container.read(paginatedAlbumListProvider(query));
      expect(snapshot.items, hasLength(3));
    });

    test('loadInitial stores typed error when repository returns Result.err', () async {
      final container2 = ProviderContainer(
        overrides: [
          albumRepositoryProvider.overrideWith((ref) {
            return _MockFailingAlbumRepository();
          }),
        ],
      );
      addTearDown(container2.dispose);

      const query = AlbumListQuery(type: 'newest', size: 10);
      await container2.read(paginatedAlbumListProvider(query).notifier).loadInitial();

      final snapshot = container2.read(paginatedAlbumListProvider(query));
      expect(snapshot.items, isEmpty);
      expect(snapshot.hasMore, isFalse);
      expect(snapshot.error, isNotNull);
      expect(snapshot.error?.message, 'mock-failure');
      expect(snapshot.error?.cause, isA<AppFailure>());
    });
  });

  group('albumListProvider', () {
    test('returns list from repository', () async {
      final mockAlbums = [
        AlbumEntity(id: 'album-1', name: 'Album One'),
        AlbumEntity(id: 'album-2', name: 'Album Two'),
      ];

      final container = ProviderContainer(
        overrides: [
          albumRepositoryProvider.overrideWith((ref) {
            return _MockAlbumRepository(mockAlbums);
          }),
        ],
      );

      const query = AlbumListQuery(type: 'random');
      final result = await container.read(albumListProvider(query).future);

      expect(result.isOk, isTrue);
      expect(result.data, hasLength(2));
      expect(result.data?[0].id, 'album-1');

      container.dispose();
    });
  });
}

class _MockAlbumRepository extends AlbumRepository {
  final List<AlbumEntity> _albums;

  _MockAlbumRepository(this._albums) : super(() async => Dio());

  @override
  Future<List<AlbumEntity>> fetchAlbumListItems({
    required AlbumListQuery query,
  }) async {
    final offset = query.offset ?? 0;
    final size = query.size ?? _albums.length;

    if (offset >= _albums.length) return [];

    final end = (offset + size).clamp(0, _albums.length);
    return _albums.sublist(offset, end);
  }

  @override
  Future<Result<List<AlbumEntity>, AppFailure>> tryFetchAlbumListItems({
    required AlbumListQuery query,
  }) async {
    final albums = await fetchAlbumListItems(query: query);
    return Result.ok(albums);
  }
}

class _MockFailingAlbumRepository extends AlbumRepository {
  _MockFailingAlbumRepository() : super(() async => Dio());

  @override
  Future<Result<List<AlbumEntity>, AppFailure>> tryFetchAlbumListItems({
    required AlbumListQuery query,
  }) async {
    return const Result.err(
      AppFailure(type: AppFailureType.network, message: 'mock-failure'),
    );
  }
}
