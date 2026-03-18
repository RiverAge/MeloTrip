import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/song/song_detail_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'song_detail.g.dart';

@riverpod
Future<SubsonicResponse?> songDetail(Ref ref, String? songId) async {
  final id = songId;
  if (id == null) {
    return null;
  }

  final repository = ref.read(songDetailRepositoryProvider);
  return repository.fetchSongDetail(id);
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

@riverpod
class SongFavorite extends _$SongFavorite {
  @override
  Future<SubsonicResponse?> build() async {
    return null;
  }

  Future<SubsonicResponse?> toggleFavorite(SongEntity? song) async {
    if (song == null || song.id == null) {
      return null;
    }

    final res = await ref.read(songDetailProvider(song.id).future);
    final starred = res?.subsonicResponse?.song?.starred;
    final subsonic = await ref
        .read(songDetailRepositoryProvider)
        .toggleFavorite(songId: song.id!, isStarred: starred != null);
    ref.invalidate(songDetailProvider(song.id));
    return subsonic;
  }

  Future<Result<SubsonicResponse, AppFailure>?> toggleFavoriteResult(
    SongEntity? song,
  ) async {
    if (song == null || song.id == null) {
      return null;
    }

    final detail = await ref.read(songDetailProvider(song.id).future);
    final starred = detail?.subsonicResponse?.song?.starred;
    final result = await ref.read(songDetailRepositoryProvider).toggleFavoriteResult(
      songId: song.id!,
      isStarred: starred != null,
    );

    if (result.isOk) {
      ref.invalidate(songDetailProvider(song.id));
      ref.invalidate(songDetailResultProvider(song.id));
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
class SongRating extends _$SongRating {
  @override
  Future<SubsonicResponse?> build() async {
    return null;
  }

  Future<SubsonicResponse?> updateRating(String? songId, int? rating) async {
    if (songId == null || rating == null) {
      return null;
    }

    final subsonic = await ref
        .read(songDetailRepositoryProvider)
        .setRating(songId: songId, rating: rating);
    ref.invalidate(songDetailProvider(songId));
    return subsonic;
  }

  Future<Result<SubsonicResponse, AppFailure>?> updateRatingResult(
    String? songId,
    int? rating,
  ) async {
    if (songId == null || rating == null) {
      return null;
    }

    final result = await ref
        .read(songDetailRepositoryProvider)
        .setRatingResult(songId: songId, rating: rating);

    if (result.isOk) {
      ref.invalidate(songDetailProvider(songId));
      ref.invalidate(songDetailResultProvider(songId));
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
