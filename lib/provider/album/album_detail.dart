import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
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

  Future<Result<SubsonicResponse, AppFailure>?> toggleFavoriteResult({
    bool? currentlyStarred,
  }) async {
    final id = albumId;
    if (id == null) return null;

    final current = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final starred = currentlyStarred ?? current?.subsonicResponse?.album?.starred != null;

    final result = await ref.read(albumDetailRepositoryProvider).toggleFavoriteResult(
      albumId: id,
      isStarred: starred,
    );

    if (result.isOk) {
      ref.invalidateSelf();
      ref.invalidate(albumDetailResultProvider(id));
    }

    final previous = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (!ref.mounted) {
      return result;
    }
    state = result.when(
      ok: AsyncData.new,
      err: (_) => previous == null ? const AsyncData(null) : AsyncData(previous),
    );
    return result;
  }

  Future<Result<SubsonicResponse, AppFailure>?> setRatingResult(
    int? rating,
  ) async {
    final id = albumId;
    if (id == null || rating == null) return null;
    final result = await ref.read(albumDetailRepositoryProvider).setRatingResult(
      albumId: id,
      rating: rating,
    );

    if (result.isOk) {
      ref.invalidateSelf();
      ref.invalidate(albumDetailResultProvider(id));
    }

    final previous = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (!ref.mounted) {
      return result;
    }
    state = result.when(
      ok: AsyncData.new,
      err: (_) => previous == null ? const AsyncData(null) : AsyncData(previous),
    );
    return result;
  }
}

@riverpod
Future<Result<SubsonicResponse, AppFailure>?> albumDetailResult(
  Ref ref,
  String? albumId,
) async {
  if (albumId == null) return null;
  final repository = ref.read(albumDetailRepositoryProvider);
  return repository.fetchAlbumDetailResult(albumId);
}
