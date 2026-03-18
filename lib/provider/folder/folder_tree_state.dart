part of 'folders.dart';

@riverpod
class FolderPath extends _$FolderPath {
  @override
  List<FolderIndexEntry> build() => [];

  void set(List<FolderIndexEntry> path) => state = path;
}

@riverpod
class ExpandedFolderIds extends _$ExpandedFolderIds {
  @override
  Set<String> build() => {};

  void toggle(String id) {
    state = state.contains(id) ? state.difference({id}) : state.union({id});
  }

  void add(String id) {
    if (!state.contains(id)) {
      state = state.union({id});
    }
  }
}

@riverpod
class FolderChildrenCache extends _$FolderChildrenCache {
  final Map<String, Future<List<FolderIndexEntry>>> _inFlight =
      <String, Future<List<FolderIndexEntry>>>{};

  @override
  Map<String, List<FolderIndexEntry>> build() => {};

  Future<List<FolderIndexEntry>> getChildren(String parentId) async {
    final cached = state[parentId];
    if (cached != null) {
      return cached;
    }

    final inFlight = _inFlight[parentId];
    if (inFlight != null) {
      return inFlight;
    }

    final request = _fetchAndCacheChildren(parentId);
    _inFlight[parentId] = request;
    try {
      return await request;
    } finally {
      _inFlight.remove(parentId);
    }
  }

  Future<List<FolderIndexEntry>> _fetchAndCacheChildren(String parentId) async {
    final repository = ref.read(foldersRepositoryProvider);
    final children = await repository.fetchMusicDirectory(parentId);
    final dirs = children.where((e) => e.isDir).toList();
    state = {...state, parentId: dirs};
    return dirs;
  }
}

@riverpod
class SelectedFolder extends _$SelectedFolder {
  @override
  FolderIndexEntry? build() => null;

  void set(FolderIndexEntry? entry) => state = entry;

  Future<void> navigateTo(
    FolderIndexEntry entry,
    List<FolderIndexEntry> path,
  ) async {
    state = entry;
    ref.read(folderPathProvider.notifier).set(path);

    final cache = ref.read(folderChildrenCacheProvider.notifier);
    final expanded = ref.read(expandedFolderIdsProvider.notifier);

    for (final pathEntry in path) {
      await cache.getChildren(pathEntry.id);
      expanded.add(pathEntry.id);
    }
  }
}

@riverpod
class FlattenedTree extends _$FlattenedTree {
  @override
  AsyncValue<List<TreeDisplayNode>> build() {
    final indexes = ref.watch(folderIndexesProvider);
    return indexes.when(
      data: (data) {
        final expanded = ref.watch(expandedFolderIdsProvider);
        final cache = ref.watch(folderChildrenCacheProvider);
        final result = <TreeDisplayNode>[];

        _flattenNodes(
          entries: data,
          depth: 0,
          currentPath: const <FolderIndexEntry>[],
          expanded: expanded,
          cache: cache,
          out: result,
        );

        return AsyncValue.data(result);
      },
      loading: () => const AsyncValue.loading(),
      error: AsyncValue.error,
    );
  }

  void _flattenNodes({
    required List<FolderIndexEntry> entries,
    required int depth,
    required List<FolderIndexEntry> currentPath,
    required Set<String> expanded,
    required Map<String, List<FolderIndexEntry>> cache,
    required List<TreeDisplayNode> out,
  }) {
    for (final entry in entries) {
      final isExpanded = expanded.contains(entry.id);
      final nodePath = <FolderIndexEntry>[...currentPath, entry];

      out.add(
        TreeDisplayNode(
          entry: entry,
          depth: depth,
          isExpanded: isExpanded,
          fullPath: nodePath,
          isLoading: isExpanded && !cache.containsKey(entry.id),
        ),
      );

      if (isExpanded && cache.containsKey(entry.id)) {
        _flattenNodes(
          entries: cache[entry.id]!,
          depth: depth + 1,
          currentPath: nodePath,
          expanded: expanded,
          cache: cache,
          out: out,
        );
      }
    }
  }
}
