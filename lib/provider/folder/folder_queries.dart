part of 'folders.dart';

@riverpod
class FolderIndexes extends _$FolderIndexes {
  @override
  Future<List<FolderIndexEntry>> build() async {
    final repository = ref.read(foldersRepositoryProvider);
    final result = await repository.tryFetchFolderIndexes();
    return result.when(
      ok: (items) => items,
      err: (failure) => throw failure,
    );
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
    final result = await repository.tryFetchMusicDirectory(selected.id);
    return result.when(
      ok: (items) => items,
      err: (failure) => throw failure,
    );
  }
}
