import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

class FavoriteRepository {
  FavoriteRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse> fetchStarred() async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>('/rest/getStarred');
    return parseSubsonicResponseOrThrow(res.data, endpoint: '/rest/getStarred');
  }
}

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepository(() => ref.read(apiProvider.future));
});
