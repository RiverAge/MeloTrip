import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/song/song_detail_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_detail.g.dart';

@riverpod
class SongDetail extends _$SongDetail {
  @override
  Future<SubsonicResponse?> build(String? songId) async {
    final id = songId;
    if (id == null) {
      return null;
    }

    final repository = ref.read(songDetailRepositoryProvider);
    return repository.fetchSongDetail(id);
  }

  Future<Result<SubsonicResponse, AppFailure>?> toggleFavoriteResult({
    bool? currentlyStarred,
  }) async {
    final id = songId;
    if (id == null) {
      return null;
    }

    final current = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final starred = currentlyStarred ?? current?.subsonicResponse?.song?.starred != null;
    final result = await ref.read(songDetailRepositoryProvider).toggleFavoriteResult(
      songId: id,
      isStarred: starred,
    );

    if (result.isOk) {
      ref.invalidateSelf();
      ref.invalidate(songDetailResultProvider(id));
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

  Future<Result<SubsonicResponse, AppFailure>?> updateRatingResult(
    int? rating,
  ) async {
    final id = songId;
    if (id == null || rating == null) {
      return null;
    }

    final result = await ref
        .read(songDetailRepositoryProvider)
        .setRatingResult(songId: id, rating: rating);

    if (result.isOk) {
      ref.invalidateSelf();
      ref.invalidate(songDetailResultProvider(id));
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
Future<Result<SubsonicResponse, AppFailure>?> songDetailResult(
  Ref ref,
  String? songId,
) async {
  final id = songId;
  if (id == null) {
    return null;
  }

  final repository = ref.read(songDetailRepositoryProvider);
  return repository.fetchSongDetailResult(id);
}
