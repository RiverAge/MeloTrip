import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/album/album_detail_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'album_detail.g.dart';

@riverpod
class AlbumDetail extends _$AlbumDetail {
  @override
  Future<SubsonicResponse?> build(String? albumId) async {
    if (albumId == null) return null;
    return ref.read(albumDetailRepositoryProvider).fetchAlbumDetail(albumId);
  }

  Future<SubsonicResponse?> toggleFavorite({bool? currentlyStarred}) async {
    final id = albumId;
    if (id == null) return null;

    final repository = ref.read(albumDetailRepositoryProvider);

    final current = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };

    final starred = currentlyStarred ?? current?.subsonicResponse?.album?.starred != null;

    final result = await repository.toggleFavorite(
      albumId: id,
      isStarred: starred,
    );

    if (!ref.mounted) return result;

    if (result?.subsonicResponse?.status == 'ok') {
      ref.invalidateSelf();
    }

    return result;
  }

  Future<SubsonicResponse?> setRating(int? rating) async {
    final id = albumId;
    if (id == null || rating == null) return null;

    final repository = ref.read(albumDetailRepositoryProvider);
    final result = await repository.setRating(albumId: id, rating: rating);

    if (!ref.mounted) return result;

    if (result?.subsonicResponse?.status == 'ok') {
      ref.invalidateSelf();
    }

    return result;
  }
}
