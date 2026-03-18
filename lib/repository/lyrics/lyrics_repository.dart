import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

class LyricsRepository {
  LyricsRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse> fetchLyrics(String songId) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/getLyricsBySongId',
      queryParameters: <String, dynamic>{'id': songId},
    );

    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/getLyricsBySongId',
    );
  }
}

final lyricsRepositoryProvider = Provider<LyricsRepository>((ref) {
  return LyricsRepository(() => ref.read(apiProvider.future));
});
