import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/playlist/playlist_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlist.g.dart';

@riverpod
class PlaylistActions extends _$PlaylistActions {
  @override
  Future<void> build() async {}

  Future<Result<SubsonicResponse, AppFailure>?> createPlaylist(
    String? name,
  ) async {
    if (name == null) return null;
    final repository = ref.read(playlistRepositoryProvider);
    final result = await repository.tryCreatePlaylist(name);
    if (result.isOk) {
      ref.invalidate(playlistsProvider);
    }
    return result;
  }
}

@riverpod
Future<Result<List<PlaylistEntity>, AppFailure>> playlists(Ref ref) async {
  final repository = ref.read(playlistRepositoryProvider);
  return repository.tryFetchPlaylistItems();
}

@riverpod
class PlaylistDetail extends _$PlaylistDetail {
  @override
  Future<Result<SubsonicResponse, AppFailure>?> build(String? playlistId) async {
    if (playlistId == null) return null;
    final repository = ref.read(playlistRepositoryProvider);
    return repository.tryFetchPlaylistDetail(playlistId);
  }

  Future<Result<SubsonicResponse, AppFailure>?> delete() async {
    final id = playlistId;
    if (id == null) return null;

    final previous = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    state = const AsyncLoading();
    final repository = ref.read(playlistRepositoryProvider);
    final result = await repository.tryDeletePlaylist(id);

    if (result.isOk) {
      ref.invalidate(playlistsProvider);
      ref.invalidateSelf();
    }

    if (!ref.mounted) {
      return result;
    }
    state = result.when(
      ok: (_) => AsyncData(result),
      err: (_) => previous == null ? const AsyncData(null) : AsyncData(previous),
    );
    return result;
  }

  Future<Result<SubsonicResponse, AppFailure>?> modify({
    int? songIndexToRemove,
    String? songIdToAdd,
    String? name,
    String? comment,
    bool? public,
  }) async {
    final id = playlistId;
    if (id == null) return null;

    final previous = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    state = const AsyncLoading();
    final repository = ref.read(playlistRepositoryProvider);
    final result = await repository.tryUpdatePlaylist(
      playlistId: id,
      songIndexToRemove: songIndexToRemove,
      songIdToAdd: songIdToAdd,
      name: name,
      comment: comment,
      public: public,
    );

    if (result.isOk) {
      ref.invalidate(playlistsProvider);
      ref.invalidateSelf();
    }

    if (!ref.mounted) {
      return result;
    }
    state = result.when(
      ok: (_) => AsyncData(result),
      err: (_) => previous == null ? const AsyncData(null) : AsyncData(previous),
    );
    return result;
  }
}
