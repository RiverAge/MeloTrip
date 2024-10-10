import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'albums.g.dart';

enum AlumsType { random, newest }

@riverpod
Future<SubsonicResponse?> albums(AlbumsRef ref, AlumsType type) async {
  final res = await Http.get<Map<String, dynamic>>('/rest/getAlbumList',
      queryParameters: {'type': type.name});

  final data = res?.data;
  if (data != null) {
    return SubsonicResponse.fromJson(data);
  }
  return null;
}
