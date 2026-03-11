import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/repository/folder/folders_repository.dart';

class FolderIndexEntry {
  const FolderIndexEntry({required this.id, required this.name});

  final String id;
  final String name;
}

final folderIndexesProvider = FutureProvider<List<FolderIndexEntry>>((
  ref,
) async {
  final repository = ref.read(foldersRepositoryProvider);
  return repository.fetchFolderIndexes();
});
