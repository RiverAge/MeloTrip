import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/artist/artists.dart';

class ArtistsRepository {
  ArtistsRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<List<ArtistIndexEntry>> fetchAllArtists() async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>('/rest/getArtists');
    final data = res.data;
    if (data == null) return const <ArtistIndexEntry>[];

    final indexes =
        data['subsonic-response']?['artists']?['index'] as List<dynamic>? ??
        const <dynamic>[];
    final entries = <ArtistIndexEntry>[];
    for (final idx in indexes) {
      final artists = idx['artist'] as List<dynamic>? ?? const <dynamic>[];
      for (final artist in artists) {
        entries.add(
          ArtistIndexEntry(
            id: artist['id']?.toString() ?? '',
            name: artist['name']?.toString() ?? '',
            coverArt: artist['coverArt']?.toString(),
            albumCount: artist['albumCount'] as int?,
          ),
        );
      }
    }
    return entries;
  }
}

final artistsRepositoryProvider = Provider<ArtistsRepository>((ref) {
  return ArtistsRepository(() => ref.read(apiProvider.future));
});
