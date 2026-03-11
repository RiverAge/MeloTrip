import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/album/album_detail_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_detail.g.dart';

@riverpod
Future<SubsonicResponse?> albumDetail(Ref ref, String? albumId) async {
  final id = albumId;
  if (id == null) {
    return null;
  }

  final repository = ref.read(albumDetailRepositoryProvider);
  return repository.fetchAlbumDetail(id);
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
    final starred = res?.subsonicResponse?.album?.starred;
    final subsonic = await ref.read(albumDetailRepositoryProvider).toggleFavorite(
      albumId: album.id!,
      isStarred: starred != null,
    );
    if (subsonic?.subsonicResponse?.status == 'ok') {
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

    final subsonic = await ref.read(albumDetailRepositoryProvider).setRating(
      albumId: albumId,
      rating: rating,
    );
    if (subsonic?.subsonicResponse?.status == 'ok') {
      ref.invalidate(albumDetailProvider(albumId));
    }
    return subsonic;
  }
}
