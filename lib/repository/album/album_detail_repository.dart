import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/repository/common/repository_guard.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

class AlbumDetailRepository {
  AlbumDetailRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse> fetchAlbumDetail(String albumId) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/getAlbum',
      queryParameters: <String, dynamic>{'id': albumId},
    );

    return parseSubsonicResponseOrThrow(res.data, endpoint: '/rest/getAlbum');
  }

  Future<Result<SubsonicResponse, AppFailure>> fetchAlbumDetailResult(
    String albumId,
  ) {
    return runGuarded(() => fetchAlbumDetail(albumId));
  }

  Future<SubsonicResponse> toggleFavorite({
    required String albumId,
    required bool isStarred,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/${isStarred ? 'un' : ''}star',
      queryParameters: <String, dynamic>{'albumId': albumId},
    );

    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/${isStarred ? 'un' : ''}star',
    );
  }

  Future<Result<SubsonicResponse, AppFailure>> toggleFavoriteResult({
    required String albumId,
    required bool isStarred,
  }) {
    return runGuarded(
      () => toggleFavorite(albumId: albumId, isStarred: isStarred),
    );
  }

  Future<SubsonicResponse> setRating({
    required String albumId,
    required int rating,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/setRating',
      queryParameters: <String, dynamic>{'id': albumId, 'rating': rating},
    );

    return parseSubsonicResponseOrThrow(res.data, endpoint: '/rest/setRating');
  }

  Future<Result<SubsonicResponse, AppFailure>> setRatingResult({
    required String albumId,
    required int rating,
  }) {
    return runGuarded(() => setRating(albumId: albumId, rating: rating));
  }
}

final albumDetailRepositoryProvider = Provider<AlbumDetailRepository>((ref) {
  return AlbumDetailRepository(() => ref.read(apiProvider.future));
});
