import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/library_index/library_index.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
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

    final response = SubsonicResponse.fromJson(data);
    final List<ArtistIndexBucketEntity> indexes =
        response.subsonicResponse?.indexes?.index ??
        const <ArtistIndexBucketEntity>[];
    final entries = <FolderIndexEntry>[];
    for (final idx in indexes) {
      final artists = idx.artist ?? const <ArtistEntity>[];
      for (final artist in artists) {
        final id = artist.id ?? '';
        final name = artist.name ?? '';
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

    final response = SubsonicResponse.fromJson(data);
    final List<DirectoryChildEntity> children =
        response.subsonicResponse?.directory?.child ??
        const <DirectoryChildEntity>[];

    return children.map((c) {
      return FolderIndexEntry(
        id: c.id ?? '',
        name: c.title ?? c.name ?? '',
        isDir: c.isDir ?? false,
        album: c.album,
        genre: c.genre,
        year: c.year,
        duration: c.duration,
        coverArt: c.coverArt,
        artist: c.artist,
      );
    }).toList();
  }
}

final foldersRepositoryProvider = Provider<FoldersRepository>((ref) {
  return FoldersRepository(() => ref.read(apiProvider.future));
});
