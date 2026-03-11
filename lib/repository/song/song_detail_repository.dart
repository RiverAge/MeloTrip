import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';

class SongDetailRepository {
  SongDetailRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse?> fetchSongDetail(String songId) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/getSong',
      queryParameters: <String, dynamic>{'id': songId},
    );

    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }

  Future<SubsonicResponse?> toggleFavorite({
    required String songId,
    required bool isStarred,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/${isStarred ? 'un' : ''}star',
      queryParameters: <String, dynamic>{'id': songId},
    );

    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }

  Future<SubsonicResponse?> setRating({
    required String songId,
    required int rating,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/setRating',
      queryParameters: <String, dynamic>{'id': songId, 'rating': rating},
    );

    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }
}

final songDetailRepositoryProvider = Provider<SongDetailRepository>((ref) {
  return SongDetailRepository(() => ref.read(apiProvider.future));
});
