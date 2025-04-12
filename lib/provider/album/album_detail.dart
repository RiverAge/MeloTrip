import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_detail.g.dart';

@riverpod
Future<SubsonicResponse?> albumDetail(Ref ref, String? albumId) async {
  final id = albumId;
  if (id == null) {
    return null;
  }

  final res = await Http.get<Map<String, dynamic>>('/rest/getAlbum',
      queryParameters: {'id': albumId});

  final data = res?.data;
  if (data != null) {
    return SubsonicResponse.fromJson(data);
  }
  return null;
}

@riverpod
class AlbumFavorite extends _$AlbumFavorite {
  @override
  Future<SubsonicResponse?> build() async {
    return null;
  }

  Future<SubsonicResponse?> toggleFavorite(String? albumId) async {
    if (albumId == null) {
      return null;
    }

    final res = await ref.watch(albumDetailProvider(albumId).future);
    final starred = res?.subsonicResponse?.album?.starred;

    final ret = await Http.get<Map<String, dynamic>>(
        '/rest/${starred != null ? 'un' : ''}star',
        queryParameters: {'albumId': albumId});

    final data = ret?.data;
    if (data == null) return null;
    final subsonic = SubsonicResponse.fromJson(data);
    if (subsonic.subsonicResponse?.status == 'ok') {
      ref.invalidate(albumDetailProvider(albumId));
    }
    return subsonic;
  }
}

@riverpod
class AlbumRating extends _$AlbumRating {
  @override
  Future<SubsonicResponse?> build() async {
    return null;
  }

  Future<SubsonicResponse?> updateRating(String? albumId, int? rating) async {
    if (albumId == null || rating == null) {
      return null;
    }

    final ret = await Http.get<Map<String, dynamic>>('/rest/setRating',
        queryParameters: {'id': albumId, 'rating': rating});

    final data = ret?.data;
    if (data == null) return null;
    final subsonic = SubsonicResponse.fromJson(data);
    if (subsonic.subsonicResponse?.status == 'ok') {
      ref.invalidate(albumDetailProvider(albumId));
    }
    return subsonic;
  }
}
