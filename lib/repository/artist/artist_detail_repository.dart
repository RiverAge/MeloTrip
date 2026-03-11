import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';

class ArtistDetailRepository {
  ArtistDetailRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse?> fetchArtistDetail(String artistId) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/getArtist',
      queryParameters: <String, dynamic>{'id': artistId},
    );

    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }
}

final artistDetailRepositoryProvider = Provider<ArtistDetailRepository>((ref) {
  return ArtistDetailRepository(() => ref.read(apiProvider.future));
});
