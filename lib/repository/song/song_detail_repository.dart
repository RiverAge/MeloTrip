import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/repository/common/repository_guard.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

class SongDetailRepository {
  SongDetailRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse> fetchSongDetail(String songId) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/getSong',
      queryParameters: <String, dynamic>{'id': songId},
    );

    return parseSubsonicResponseOrThrow(res.data, endpoint: '/rest/getSong');
  }

  Future<Result<SubsonicResponse, AppFailure>> fetchSongDetailResult(
    String songId,
  ) {
    return runGuarded(() => fetchSongDetail(songId));
  }

  Future<SubsonicResponse> toggleFavorite({
    required String songId,
    required bool isStarred,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/${isStarred ? 'un' : ''}star',
      queryParameters: <String, dynamic>{'id': songId},
    );

    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/${isStarred ? 'un' : ''}star',
    );
  }

  Future<Result<SubsonicResponse, AppFailure>> toggleFavoriteResult({
    required String songId,
    required bool isStarred,
  }) {
    return runGuarded(
      () => toggleFavorite(songId: songId, isStarred: isStarred),
    );
  }

  Future<SubsonicResponse> setRating({
    required String songId,
    required int rating,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/setRating',
      queryParameters: <String, dynamic>{'id': songId, 'rating': rating},
    );

    return parseSubsonicResponseOrThrow(res.data, endpoint: '/rest/setRating');
  }

  Future<Result<SubsonicResponse, AppFailure>> setRatingResult({
    required String songId,
    required int rating,
  }) {
    return runGuarded(() => setRating(songId: songId, rating: rating));
  }
}

final songDetailRepositoryProvider = Provider<SongDetailRepository>((ref) {
  return SongDetailRepository(() => ref.read(apiProvider.future));
});
