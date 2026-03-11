import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/folder/folders.dart';

class FoldersRepository {
  FoldersRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<List<FolderIndexEntry>> fetchFolderIndexes() async {
    final api = await _readApi();
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
  }
}

final foldersRepositoryProvider = Provider<FoldersRepository>((ref) {
  return FoldersRepository(() => ref.read(apiProvider.future));
});
