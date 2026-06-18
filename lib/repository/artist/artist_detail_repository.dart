import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/repository/common/repository_guard.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

class ArtistDetailRepository {
  ArtistDetailRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse> fetchArtistDetail(String artistId) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/getArtist',
      queryParameters: <String, dynamic>{'id': artistId},
    );

    return parseSubsonicResponseOrThrow(res.data, endpoint: '/rest/getArtist');
  }

  Future<Result<SubsonicResponse, AppFailure>> tryFetchArtistDetail(
    String artistId,
  ) {
    return runGuarded(() => fetchArtistDetail(artistId));
  }

  /// Fetches artist info including similar artists from getArtistInfo2 endpoint.
  ///
  /// This is an OpenSubsonic extension provided by Navidrome.
  /// Returns similar artists based on the requested artist.
  Future<SubsonicResponse> fetchArtistInfo2({
    required String artistId,
    int? count,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/getArtistInfo2',
      queryParameters: <String, dynamic>{
        'id': artistId,
        ...?count != null ? {'count': count} : null,
      },
    );

    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/getArtistInfo2',
    );
  }

  /// Safely fetches artist info with error handling.
  ///
  /// Returns Result.ok with the response on success,
  /// or Result.err with AppFailure on failure.
  Future<Result<SubsonicResponse, AppFailure>> tryFetchArtistInfo2({
    required String artistId,
    int? count,
  }) {
    return runGuarded(() => fetchArtistInfo2(artistId: artistId, count: count));
  }
}

final artistDetailRepositoryProvider = Provider<ArtistDetailRepository>((ref) {
  return ArtistDetailRepository(() => ref.read(apiProvider.future));
});
