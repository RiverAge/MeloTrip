import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/api/api.dart';

class AlbumRepository {
  AlbumRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse?> fetchAlbumListResponse({
    required AlbumListQuery query,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/getAlbumList',
      queryParameters: query.toQueryParameters(),
    );

    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }

  Future<List<AlbumEntity>> fetchAlbumListItems({
    required AlbumListQuery query,
  }) async {
    final response = await fetchAlbumListResponse(query: query);
    return response?.subsonicResponse?.albumList?.album ??
        const <AlbumEntity>[];
  }
}

final albumRepositoryProvider = Provider<AlbumRepository>((ref) {
  return AlbumRepository(() => ref.read(apiProvider.future));
});
