import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/smart_suggestion/smart_suggestion.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_detail.g.dart';

@riverpod
Future<SubsonicResponse?> albumDetail(Ref ref, String? albumId) async {
  final id = albumId;
  if (id == null) {
    return null;
  }

  final api = await ref.read(apiProvider.future);
  final res = await api.get<Map<String, dynamic>>(
    '/rest/getAlbum',
    queryParameters: {'id': albumId},
  );

  final data = res.data;
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

  Future<SubsonicResponse?> toggleFavorite(AlbumEntity? album) async {
    if (album == null || album.id == null) {
      return null;
    }

    final res = await ref.read(albumDetailProvider(album.id).future);
    final api = await ref.read(apiProvider.future);

    final starred = res?.subsonicResponse?.album?.starred;
    final ret = await api.get<Map<String, dynamic>>(
      '/rest/${starred != null ? 'un' : ''}star',
      queryParameters: {'albumId': album.id},
    );

    final data = ret.data;
    if (data == null) return null;
    final subsonic = SubsonicResponse.fromJson(data);
    if (subsonic.subsonicResponse?.status == 'ok') {
      ref.invalidate(albumDetailProvider(album.id));
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

    final api = await ref.read(apiProvider.future);
    final ret = await api.get<Map<String, dynamic>>(
      '/rest/setRating',
      queryParameters: {'id': albumId, 'rating': rating},
    );

    final data = ret.data;
    if (data == null) return null;
    final subsonic = SubsonicResponse.fromJson(data);
    if (subsonic.subsonicResponse?.status == 'ok') {
      ref.invalidate(albumDetailProvider(albumId));
    }
    return subsonic;
  }
}
