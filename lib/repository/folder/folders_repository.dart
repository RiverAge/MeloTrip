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

  Future<List<FolderIndexEntry>> fetchMusicDirectory(String id) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/getMusicDirectory',
      queryParameters: {'id': id},
    );
    final data = res.data;
    if (data == null) return const <FolderIndexEntry>[];

    final children =
        data['subsonic-response']?['directory']?['child'] as List<dynamic>? ??
        const <dynamic>[];

    return children.map((c) {
      return FolderIndexEntry(
        id: c['id']?.toString() ?? '',
        name: c['title']?.toString() ?? c['name']?.toString() ?? '',
        isDir: c['isDir'] == true,
        album: c['album']?.toString(),
        genre: c['genre']?.toString(),
        year: int.tryParse(c['year']?.toString() ?? ''),
        duration: int.tryParse(c['duration']?.toString() ?? ''),
        coverArt: c['coverArt']?.toString(),
        artist: c['artist']?.toString(),
      );
    }).toList();
  }
}

final foldersRepositoryProvider = Provider<FoldersRepository>((ref) {
  return FoldersRepository(() => ref.read(apiProvider.future));
});
