import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/song/song_detail_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_detail.g.dart';

@riverpod
class SongDetail extends _$SongDetail {
  @override
  Future<Result<SubsonicResponse, AppFailure>?> build(String? songId) async {
    final id = songId;
    if (id == null) {
      return null;
    }

    final repository = ref.read(songDetailRepositoryProvider);
    return repository.tryFetchSongDetail(id);
  }

  Future<Result<SubsonicResponse, AppFailure>?> toggleFavorite({
    bool? currentlyStarred,
  }) async {
    final id = songId;
    if (id == null) {
      return null;
    }

    final current = switch (state) {
      AsyncData(:final value) => value?.data,
      _ => null,
    };
    final starred =
        currentlyStarred ?? current?.subsonicResponse?.song?.starred != null;
    final result = await ref
        .read(songDetailRepositoryProvider)
        .tryToggleFavorite(songId: id, isStarred: starred);

    if (result.isOk) {
      ref.invalidateSelf();
    }

    final previous = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (!ref.mounted) {
      return result;
    }
    state = result.when(
      ok: (_) => AsyncData(result),
      err: (_) =>
          previous == null ? const AsyncData(null) : AsyncData(previous),
    );
    return result;
  }

  Future<Result<SubsonicResponse, AppFailure>?> updateRating(
    int? rating,
  ) async {
    final id = songId;
    if (id == null || rating == null) {
      return null;
    }

    final result = await ref
        .read(songDetailRepositoryProvider)
        .trySetRating(songId: id, rating: rating);

    if (result.isOk) {
      ref.invalidateSelf();
    }

    final previous = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    if (!ref.mounted) {
      return result;
    }
    state = result.when(
      ok: (_) => AsyncData(result),
      err: (_) =>
          previous == null ? const AsyncData(null) : AsyncData(previous),
    );
    return result;
  }
}

