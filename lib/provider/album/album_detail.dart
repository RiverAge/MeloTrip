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

@riverpod
class AlbumFavorite extends _$AlbumFavorite {
  @override
  Future<SubsonicResponse?> build() async => null;

  Future<Result<SubsonicResponse, AppFailure>?> toggleFavoriteResult({
    required String? albumId,
    bool? currentlyStarred,
  }) async {
    if (albumId == null) return null;
    final detail = await ref.read(albumDetailProvider(albumId).future);
    final starred = currentlyStarred ?? detail?.subsonicResponse?.album?.starred != null;

    final result = await ref.read(albumDetailRepositoryProvider).toggleFavoriteResult(
      albumId: albumId,
      isStarred: starred,
    );

    if (result.isOk) {
      ref.invalidate(albumDetailProvider(albumId));
      ref.invalidate(albumDetailResultProvider(albumId));
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
class AlbumRating extends _$AlbumRating {
  @override
  Future<SubsonicResponse?> build() async => null;

  Future<Result<SubsonicResponse, AppFailure>?> setRatingResult({
    required String? albumId,
    required int? rating,
  }) async {
    if (albumId == null || rating == null) return null;
    final result = await ref.read(albumDetailRepositoryProvider).setRatingResult(
      albumId: albumId,
      rating: rating,
    );

    if (result.isOk) {
      ref.invalidate(albumDetailProvider(albumId));
      ref.invalidate(albumDetailResultProvider(albumId));
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
