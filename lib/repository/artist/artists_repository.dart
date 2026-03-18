import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/library_index/library_index.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/artist/artists.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

class ArtistsRepository {
  ArtistsRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<List<ArtistIndexEntry>> fetchAllArtists() async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>('/rest/getArtists');
    final response = parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/getArtists',
    );
    final List<ArtistIndexBucketEntity> indexes =
        response.subsonicResponse?.artists?.index ??
        const <ArtistIndexBucketEntity>[];
    final entries = <ArtistIndexEntry>[];
    for (final idx in indexes) {
      final artists = idx.artist ?? const <ArtistEntity>[];
      for (final artist in artists) {
        entries.add(
          ArtistIndexEntry(
            id: artist.id ?? '',
            name: artist.name ?? '',
            coverArt: artist.coverArt,
            albumCount: artist.albumCount,
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
