import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/song/songs.dart';

class SongRepository {
  SongRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse?> fetchSongSearchResponse({
    required SongSearchQuery query,
    CancelToken? cancelToken,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/search3',
      queryParameters: query.toQueryParameters(),
      cancelToken: cancelToken,
    );

    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }

  Future<List<SongEntity>> fetchSongSearchItems({
    required SongSearchQuery query,
    CancelToken? cancelToken,
  }) async {
    final response = await fetchSongSearchResponse(
      query: query,
      cancelToken: cancelToken,
    );
    return response?.subsonicResponse?.searchResult3?.song ??
        const <SongEntity>[];
  }
}

final songRepositoryProvider = Provider<SongRepository>((ref) {
  return SongRepository(() => ref.read(apiProvider.future));
});
