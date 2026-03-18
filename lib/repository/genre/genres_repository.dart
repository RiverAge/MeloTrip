import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/genre/genre.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

class GenresRepository {
  GenresRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse> fetchGenresResponse() async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>('/rest/getGenres');
    return parseSubsonicResponseOrThrow(res.data, endpoint: '/rest/getGenres');
  }

  Future<List<GenreEntity>> fetchGenresItems() async {
    final response = await fetchGenresResponse();
    return response.subsonicResponse?.genres?.genre ?? const <GenreEntity>[];
  }
}

final genresRepositoryProvider = Provider<GenresRepository>((ref) {
  return GenresRepository(() => ref.read(apiProvider.future));
});
