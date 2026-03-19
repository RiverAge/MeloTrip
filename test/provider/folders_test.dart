import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/provider/folder/folders.dart';
import 'package:melo_trip/repository/folder/folders_repository.dart';

class _MockFoldersRepository extends FoldersRepository {
  _MockFoldersRepository() : super(() async => Dio());

  List<FolderIndexEntry> _indexesResult = [];
  List<FolderIndexEntry> _directoryResult = [];
  bool fetchIndexesCalled = false;
  bool fetchDirectoryCalled = false;
  String? lastDirectoryId;

  void setIndexesResult(List<FolderIndexEntry> result) {
    _indexesResult = result;
  }

  void setDirectoryResult(List<FolderIndexEntry> result) {
    _directoryResult = result;
  }

  @override
  Future<List<FolderIndexEntry>> fetchFolderIndexes() async {
    fetchIndexesCalled = true;
    return _indexesResult;
  }

  @override
  Future<Result<List<FolderIndexEntry>, AppFailure>> tryFetchFolderIndexes() async {
    fetchIndexesCalled = true;
    return Result.ok(_indexesResult);
  }

  @override
  Future<List<FolderIndexEntry>> fetchMusicDirectory(String id) async {
    fetchDirectoryCalled = true;
    lastDirectoryId = id;
    return _directoryResult;
  }

  @override
  Future<Result<List<FolderIndexEntry>, AppFailure>> tryFetchMusicDirectory(
    String id,
  ) async {
    fetchDirectoryCalled = true;
    lastDirectoryId = id;
    return Result.ok(_directoryResult);
  }
}

void main() {
  group('folderIndexesProvider', () {
    test('returns empty list when repository returns empty list', () async {
      final mockRepository = _MockFoldersRepository();
      mockRepository.setIndexesResult([]);

      final container = ProviderContainer(
        overrides: [
          foldersRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(folderIndexesProvider.future);

      expect(result, isEmpty);
      expect(mockRepository.fetchIndexesCalled, isTrue);
    });

    test('returns folder indexes from repository', () async {
      final mockIndexes = [
        FolderIndexEntry(id: 'folder-1', name: 'Artist A'),
        FolderIndexEntry(id: 'folder-2', name: 'Artist B'),
      ];
      final mockRepository = _MockFoldersRepository();
      mockRepository.setIndexesResult(mockIndexes);

      final container = ProviderContainer(
        overrides: [
          foldersRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(folderIndexesProvider.future);

      expect(result, isNotEmpty);
      expect(result.length, equals(2));
      expect(result.first.id, equals('folder-1'));
      expect(mockRepository.fetchIndexesCalled, isTrue);
    });
  });

  group('folderContentsProvider', () {
    test('returns folder indexes when no folder selected', () async {
      final mockIndexes = [
        FolderIndexEntry(id: 'folder-1', name: 'Artist A'),
      ];
      final mockRepository = _MockFoldersRepository();
      mockRepository.setIndexesResult(mockIndexes);

      final container = ProviderContainer(
        overrides: [
          foldersRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(folderContentsProvider.future);

      expect(result, isNotEmpty);
      expect(result.first.id, equals('folder-1'));
    });

    test('returns directory contents when folder selected', () async {
      final mockDirectory = [
        FolderIndexEntry(id: 'child-1', name: 'Subfolder', isDir: true),
        FolderIndexEntry(id: 'child-2', name: 'Song', isDir: false),
      ];
      final mockRepository = _MockFoldersRepository();
      mockRepository.setDirectoryResult(mockDirectory);

      final container = ProviderContainer(
        overrides: [
          foldersRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      container.read(selectedFolderProvider.notifier).set(
            FolderIndexEntry(id: 'folder-1', name: 'Selected Folder'),
          );

      final result = await container.read(folderContentsProvider.future);

      expect(result, isNotEmpty);
      expect(result.length, equals(2));
      expect(mockRepository.fetchDirectoryCalled, isTrue);
      expect(mockRepository.lastDirectoryId, 'folder-1');
    });
  });

  group('selectedFolderProvider', () {
    test('initial state is null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = container.read(selectedFolderProvider);

      expect(result, isNull);
    });

    test('set updates state', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(selectedFolderProvider.notifier).set(
            FolderIndexEntry(id: 'folder-1', name: 'Test Folder'),
          );

      final result = container.read(selectedFolderProvider);
      expect(result, isNotNull);
      expect(result?.id, 'folder-1');
    });
  });

  group('expandedFolderIdsProvider', () {
    test('initial state is empty set', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final result = container.read(expandedFolderIdsProvider);

      expect(result, isEmpty);
    });

    test('toggle adds and removes ids', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(expandedFolderIdsProvider.notifier).toggle('folder-1');
      expect(container.read(expandedFolderIdsProvider), contains('folder-1'));

      container.read(expandedFolderIdsProvider.notifier).toggle('folder-1');
      expect(container.read(expandedFolderIdsProvider), isNot(contains('folder-1')));
    });

    test('add only adds if not present', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(expandedFolderIdsProvider.notifier).add('folder-1');
      container.read(expandedFolderIdsProvider.notifier).add('folder-1');

      expect(container.read(expandedFolderIdsProvider), contains('folder-1'));
      expect(container.read(expandedFolderIdsProvider).length, equals(1));
    });
  });

  group('FolderIndexEntry', () {
    test('toSong converts entry to song entity', () {
      const entry = FolderIndexEntry(
        id: 'song-1',
        name: 'Test Song',
        artist: 'Test Artist',
        album: 'Test Album',
        duration: 180,
      );

      final song = entry.toSong();

      expect(song.id, equals('song-1'));
      expect(song.title, equals('Test Song'));
      expect(song.artist, equals('Test Artist'));
      expect(song.album, equals('Test Album'));
      expect(song.duration, equals(180));
    });

    test('equality based on id', () {
      const entry1 = FolderIndexEntry(id: 'folder-1', name: 'Name 1');
      const entry2 = FolderIndexEntry(id: 'folder-1', name: 'Name 2');
      const entry3 = FolderIndexEntry(id: 'folder-2', name: 'Name 1');

      expect(entry1, equals(entry2));
      expect(entry1, isNot(equals(entry3)));
    });

    test('hashCode based on id', () {
      const entry1 = FolderIndexEntry(id: 'folder-1', name: 'Name 1');
      const entry2 = FolderIndexEntry(id: 'folder-1', name: 'Name 2');

      expect(entry1.hashCode, equals(entry2.hashCode));
    });
  });
}
