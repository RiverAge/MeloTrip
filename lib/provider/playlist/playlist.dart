import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/playlist/playlist_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlist.g.dart';

Future<Result<SubsonicResponse, AppFailure>> updatePlaylistRequestResult({
  required Ref ref,
  required String playlistId,
  int? songIndexToRemove,
  String? songIdToAdd,
  String? name,
  String? comment,
  bool? public,
}) async {
  final repository = ref.read(playlistRepositoryProvider);
  final result = await repository.updatePlaylistResult(
    playlistId: playlistId,
    songIndexToRemove: songIndexToRemove,
    songIdToAdd: songIdToAdd,
    name: name,
    comment: comment,
    public: public,
  );

  if (result.isOk) {
    ref.invalidate(playlistDetailResultProvider(playlistId));
    ref.invalidate(playlistsResultProvider);
  }

  return result;
}

@riverpod
class PlaylistActions extends _$PlaylistActions {
  @override
  Future<void> build() async {}

  Future<Result<SubsonicResponse, AppFailure>?> createPlaylist(
    String? name,
  ) async {
    if (name == null) return null;
    final repository = ref.read(playlistRepositoryProvider);
    final result = await repository.createPlaylistResult(name);
    if (result.isOk) {
      ref.invalidate(playlistsResultProvider);
    }
    return result;
  }

  Future<Result<SubsonicResponse, AppFailure>?> deletePlaytlist(
    String? playlistId,
  ) async {
    if (playlistId == null) return null;
    final repository = ref.read(playlistRepositoryProvider);
    final result = await repository.deletePlaylistResult(playlistId);
    if (result.isOk) {
      ref.invalidate(playlistsResultProvider);
    }
    return result;
  }
}

@riverpod
class PlaylistUpdate extends _$PlaylistUpdate {
  @override
  Future<SubsonicResponse?> build() async {
    return null;
  }

  Future<Result<SubsonicResponse, AppFailure>> modifyResult({
    required String playlistId,
    int? songIndexToRemove,
    String? songIdToAdd,
    String? name,
    String? comment,
    bool? public,
  }) async {
    final previous = switch (state) {
      AsyncData(:final value) => value,
      _ => null,
    };
    state = const AsyncLoading();
    final result = await updatePlaylistRequestResult(
      ref: ref,
      playlistId: playlistId,
      songIndexToRemove: songIndexToRemove,
      songIdToAdd: songIdToAdd,
      name: name,
      comment: comment,
      public: public,
    );

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
Future<Result<SubsonicResponse, AppFailure>> playlistsResult(Ref ref) async {
  final repository = ref.read(playlistRepositoryProvider);
  return repository.fetchPlaylistsResult();
}

@riverpod
Future<Result<SubsonicResponse, AppFailure>?> playlistDetailResult(
  Ref ref,
  String? playlistId,
) async {
  if (playlistId == null) return null;
  final repository = ref.read(playlistRepositoryProvider);
  return repository.fetchPlaylistDetailResult(playlistId);
}
