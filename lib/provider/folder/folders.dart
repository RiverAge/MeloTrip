import 'package:melo_trip/repository/folder/folders_repository.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folders.g.dart';

class FolderIndexEntry {
  const FolderIndexEntry({
    required this.id,
    required this.name,
    this.isDir = true,
    this.album,
    this.genre,
    this.year,
    this.duration,
    this.coverArt,
    this.artist,
  });

  final String id;
  final String name;
  final bool isDir;
  final String? album;
  final String? genre;
  final int? year;
  final int? duration; // 秒
  final String? coverArt;
  final String? artist;

  SongEntity toSong() {
    return SongEntity(
      id: id,
      title: name,
      album: album,
      artist: artist,
      coverArt: coverArt,
      year: year,
      duration: duration,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FolderIndexEntry && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class TreeDisplayNode {
  const TreeDisplayNode({
    required this.entry,
    required this.depth,
    required this.isExpanded,
    required this.fullPath,
    this.isLoading = false,
  });

  final FolderIndexEntry entry;
  final int depth;
  final bool isExpanded;
  final List<FolderIndexEntry> fullPath;
  final bool isLoading;

  String get id => entry.id;
}

@riverpod
class FolderIndexes extends _$FolderIndexes {
  @override
  Future<List<FolderIndexEntry>> build() async {
    final repository = ref.read(foldersRepositoryProvider);
    return repository.fetchFolderIndexes();
  }
}

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
  @override
  Map<String, List<FolderIndexEntry>> build() => {};

  Future<List<FolderIndexEntry>> getChildren(String parentId) async {
    if (state.containsKey(parentId)) return state[parentId]!;
    
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

  Future<void> navigateTo(FolderIndexEntry entry, List<FolderIndexEntry> path) async {
    state = entry;
    ref.read(folderPathProvider.notifier).set(path);
    
    final cache = ref.read(folderChildrenCacheProvider.notifier);
    final expanded = ref.read(expandedFolderIdsProvider.notifier);
    
    for (final p in path) {
      await cache.getChildren(p.id);
      expanded.add(p.id);
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

        void flatten(List<FolderIndexEntry> entries, int depth, List<FolderIndexEntry> currentPath) {
          for (final entry in entries) {
            final isExpanded = expanded.contains(entry.id);
            final nodePath = [...currentPath, entry];
            
            result.add(TreeDisplayNode(
              entry: entry,
              depth: depth,
              isExpanded: isExpanded,
              fullPath: nodePath,
              isLoading: isExpanded && !cache.containsKey(entry.id),
            ));
            
            if (isExpanded && cache.containsKey(entry.id)) {
              flatten(cache[entry.id]!, depth + 1, nodePath);
            }
          }
        }

        flatten(data, 0, []);
        return AsyncValue.data(result);
      },
      loading: () => const AsyncValue.loading(),
      error: (e, s) => AsyncValue.error(e, s),
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
    return repository.fetchMusicDirectory(selected.id);
  }
}
