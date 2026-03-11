import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';

class FavoriteRepository {
  FavoriteRepository(this._readApi);

  final Future<dynamic> Function() _readApi;

  Future<SubsonicResponse?> fetchStarred() async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>('/rest/getStarred');
    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }
}

final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepository(() => ref.read(apiProvider.future));
});
