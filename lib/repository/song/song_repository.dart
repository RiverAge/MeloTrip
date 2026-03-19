import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/song/songs.dart';
import 'package:melo_trip/repository/common/repository_guard.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

class SongRepository {
  SongRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse> fetchSongSearchResponse({
    required SongSearchQuery query,
    CancelToken? cancelToken,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/search3',
      queryParameters: query.toQueryParameters(),
      cancelToken: cancelToken,
    );

    return parseSubsonicResponseOrThrow(res.data, endpoint: '/rest/search3');
  }

  Future<Result<SubsonicResponse, AppFailure>> tryFetchSongSearchResponse({
    required SongSearchQuery query,
    CancelToken? cancelToken,
  }) {
    return runGuarded(
      () => fetchSongSearchResponse(query: query, cancelToken: cancelToken),
    );
  }

  Future<List<SongEntity>> fetchSongSearchItems({
    required SongSearchQuery query,
    CancelToken? cancelToken,
  }) async {
    final response = await fetchSongSearchResponse(
      query: query,
      cancelToken: cancelToken,
    );
    return response.subsonicResponse?.searchResult3?.song ??
        const <SongEntity>[];
  }
}

final songRepositoryProvider = Provider<SongRepository>((ref) {
  return SongRepository(() => ref.read(apiProvider.future));
});
