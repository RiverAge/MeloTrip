import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/provider/api/api.dart';

class FolderIndexEntry {
  const FolderIndexEntry({required this.id, required this.name});

  final String id;
  final String name;
}

final folderIndexesProvider = FutureProvider<List<FolderIndexEntry>>((
  ref,
) async {
  final api = await ref.read(apiProvider.future);
  final res = await api.get<Map<String, dynamic>>('/rest/getIndexes');
  final data = res.data;
  if (data == null) return const <FolderIndexEntry>[];

  final indexes =
      data['subsonic-response']?['indexes']?['index'] as List<dynamic>? ??
      const <dynamic>[];
  final entries = <FolderIndexEntry>[];
  for (final idx in indexes) {
    final artists = idx['artist'] as List<dynamic>? ?? const <dynamic>[];
    for (final artist in artists) {
      final id = artist['id']?.toString() ?? '';
      final name = artist['name']?.toString() ?? '';
      if (id.isNotEmpty) {
        entries.add(FolderIndexEntry(id: id, name: name));
      }
    }
  }
  return entries;
});
