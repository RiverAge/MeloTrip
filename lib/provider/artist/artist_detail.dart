import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'artist_detail.g.dart';

@riverpod
Future<SubsonicResponse?> artistDetail(Ref ref, String? artistId) async {
  final id = artistId;
  if (id == null) {
    return null;
  }

  final res = await Http.get<Map<String, dynamic>>('/rest/getArtist',
      queryParameters: {'id': artistId});

  final data = res?.data;
  if (data != null) {
    return SubsonicResponse.fromJson(data);
  }
  return null;
}
