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

  Future<Result<SubsonicResponse, AppFailure>> tryFetchSongDetail(
    String songId,
  ) {
    return runGuarded(() => fetchSongDetail(songId));
  }

  Future<Result<SubsonicResponse, AppFailure>> tryToggleFavorite({
    required String songId,
    required bool isStarred,
  }) {
    return runGuarded(() async {
      final api = await _readApi();
      final endpoint = '/rest/${isStarred ? 'un' : ''}star';
      final res = await api.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: <String, dynamic>{'id': songId},
      );

      return parseSubsonicResponseOrThrow(res.data, endpoint: endpoint);
    });
  }

  Future<Result<SubsonicResponse, AppFailure>> trySetRating({
    required String songId,
    required int rating,
  }) {
    return runGuarded(() async {
      final api = await _readApi();
      final endpoint = '/rest/setRating';
      final res = await api.get<Map<String, dynamic>>(
        endpoint,
        queryParameters: <String, dynamic>{'id': songId, 'rating': rating},
      );

      return parseSubsonicResponseOrThrow(res.data, endpoint: endpoint);
    });
  }
}

final songDetailRepositoryProvider = Provider<SongDetailRepository>((ref) {
  return SongDetailRepository(() => ref.read(apiProvider.future));
});
