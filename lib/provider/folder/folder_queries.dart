part of 'folders.dart';

@riverpod
class FolderIndexes extends _$FolderIndexes {
  @override
  Future<List<FolderIndexEntry>> build() async {
    final repository = ref.read(foldersRepositoryProvider);
    return repository.fetchFolderIndexes();
  }
}

@riverpod
class FolderContents extends _$FolderContents {
  @override
  Future<List<FolderIndexEntry>> build() async {
    final selected = ref.watch(selectedFolderProvider);
    if (selected == null) {
      return ref.watch(folderIndexesProvider.future);
    }

    final repository = ref.read(foldersRepositoryProvider);
    return repository.fetchMusicDirectory(selected.id);
  }
}
