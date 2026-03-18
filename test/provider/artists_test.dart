import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/provider/artist/artists.dart';
import 'package:melo_trip/repository/artist/artists_repository.dart';

void main() {
  group('ArtistIndexEntry', () {
    test('creates entry with all fields', () {
      const entry = ArtistIndexEntry(
        id: 'artist-1',
        name: 'Test Artist',
        coverArt: 'cover-123',
        albumCount: 5,
      );

      expect(entry.id, 'artist-1');
      expect(entry.name, 'Test Artist');
      expect(entry.coverArt, 'cover-123');
      expect(entry.albumCount, 5);
    });

    test('creates entry with minimal fields', () {
      const entry = ArtistIndexEntry(id: 'artist-1', name: 'Test Artist');

      expect(entry.id, 'artist-1');
      expect(entry.name, 'Test Artist');
      expect(entry.coverArt, isNull);
      expect(entry.albumCount, isNull);
    });
  });

  group('PaginatedArtists', () {
    late ProviderContainer container;
    late List<ArtistIndexEntry> mockArtists;

    setUp(() {
      mockArtists = List.generate(
        30,
        (i) => ArtistIndexEntry(
          id: 'artist-$i',
          name: 'Artist $i',
          albumCount: i + 1,
        ),
      );

      container = ProviderContainer(
        overrides: [
          artistsRepositoryProvider.overrideWith((ref) {
            return _MockArtistsRepository(mockArtists);
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('build returns empty snapshot initially', () {
      final snapshot = container.read(paginatedArtistsProvider);

      expect(snapshot.items, isEmpty);
    });

    test('loadInitial populates items from repository', () async {
      container.read(paginatedArtistsProvider.notifier).loadInitial();

      await Future.delayed(const Duration(milliseconds: 100));

      final snapshot = container.read(paginatedArtistsProvider);
      expect(snapshot.items.length, equals(30));
      expect(snapshot.items[0].id, 'artist-0');
    });

    test('loadMore increases visible offset', () async {
      container.read(paginatedArtistsProvider.notifier).loadInitial();

      await Future.delayed(const Duration(milliseconds: 100));

      final initialSnapshot = container.read(paginatedArtistsProvider);

      container.read(paginatedArtistsProvider.notifier).loadMore();

      final afterSnapshot = container.read(paginatedArtistsProvider);

      expect(afterSnapshot.offset, greaterThan(initialSnapshot.offset));
    });

    test('loadMore respects hasMore when reaching end', () async {
      final fewArtists = List.generate(
        10,
        (i) => ArtistIndexEntry(id: 'artist-$i', name: 'Artist $i'),
      );

      final smallContainer = ProviderContainer(
        overrides: [
          artistsRepositoryProvider.overrideWith((ref) {
            return _MockArtistsRepository(fewArtists);
          }),
        ],
      );

      smallContainer.read(paginatedArtistsProvider.notifier).loadInitial();

      await Future.delayed(const Duration(milliseconds: 100));

      smallContainer.read(paginatedArtistsProvider.notifier).loadMore();

      await Future.delayed(const Duration(milliseconds: 50));

      smallContainer.read(paginatedArtistsProvider.notifier).loadMore();

      await Future.delayed(const Duration(milliseconds: 50));

      final snapshot = smallContainer.read(paginatedArtistsProvider);

      expect(snapshot.offset, lessThanOrEqualTo(fewArtists.length));
      expect(snapshot.hasMore, isFalse);

      smallContainer.dispose();
    });
  });

  group('kArtistPageSize', () {
    test('has expected value', () {
      expect(kArtistPageSize, equals(24));
    });
  });
}

class _MockArtistsRepository extends ArtistsRepository {
  final List<ArtistIndexEntry> _artists;

  _MockArtistsRepository(this._artists) : super(() async => Dio());

  @override
  Future<List<ArtistIndexEntry>> fetchAllArtists() async {
    return _artists;
  }
}
