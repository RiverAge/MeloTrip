import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite.g.dart';

@riverpod
class Favorite extends _$Favorite {
  @override
  Future<SubsonicResponse?> build() async {
    final res = await Http.get<Map<String, dynamic>>('/rest/getStarred');
    final data = res?.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }

  Future<SubsonicResponse?> toggleSong(SongEntity? song) async {
    if (song?.id == null) return null;
    final songs = state.value?.subsonicResponse?.starred?.song;
    final index = songs?.indexWhere((e) => e.id == song?.id);
    if (index == null) return null;
    final res = await Http.get<Map<String, dynamic>>(
        '/rest/${index != -1 ? 'un' : ''}star',
        queryParameters: {'id': song?.id});
    final data = res?.data;
    if (data == null) return null;
    final subsonicRes = SubsonicResponse.fromJson(data);
    if (subsonicRes.subsonicResponse?.status != 'ok') return null;
    ref.invalidateSelf();
    return subsonicRes;
  }

  Future<SubsonicResponse?> toggleAlbum(AlbumEntity? album) async {
    if (album?.id == null) return null;
    final albums = state.value?.subsonicResponse?.starred?.album;
    final index = albums?.indexWhere((e) => e.id == album?.id);
    if (index == null) return null;
    final res = await Http.get<Map<String, dynamic>>(
        '/rest/${index != -1 ? 'un' : ''}star',
        queryParameters: {'albumId': album?.id});
    final data = res?.data;
    if (data == null) return null;
    final subsonicRes = SubsonicResponse.fromJson(data);
    if (subsonicRes.subsonicResponse?.status != 'ok') return null;
    ref.invalidateSelf();
    return subsonicRes;
  }
}
