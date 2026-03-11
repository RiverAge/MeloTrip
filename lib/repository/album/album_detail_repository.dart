import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';

class AlbumDetailRepository {
  AlbumDetailRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse?> fetchAlbumDetail(String albumId) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/getAlbum',
      queryParameters: <String, dynamic>{'id': albumId},
    );

    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }

  Future<SubsonicResponse?> toggleFavorite({
    required String albumId,
    required bool isStarred,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/${isStarred ? 'un' : ''}star',
      queryParameters: <String, dynamic>{'albumId': albumId},
    );

    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }

  Future<SubsonicResponse?> setRating({
    required String albumId,
    required int rating,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/setRating',
      queryParameters: <String, dynamic>{'id': albumId, 'rating': rating},
    );

    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }
}

final albumDetailRepositoryProvider = Provider<AlbumDetailRepository>((ref) {
  return AlbumDetailRepository(() => ref.read(apiProvider.future));
});
