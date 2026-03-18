import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/playlist/playlist_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'playlist.g.dart';

Future<SubsonicResponse?> updatePlaylistRequest({
  required Ref ref,
  required String playlistId,
  int? songIndexToRemove,
  String? songIdToAdd,
  String? name,
  String? comment,
  bool? public,
}) async {
  final queryParameters = <String, dynamic>{'playlistId': playlistId};
  if (songIndexToRemove != null) {
    queryParameters['songIndexToRemove'] = songIndexToRemove;
  }
  if (songIdToAdd != null) {
    queryParameters['songIdToAdd'] = songIdToAdd;
  }
  if (name != null) {
    queryParameters['name'] = name;
  }
  if (comment != null) {
    queryParameters['comment'] = comment;
  }
  if (public != null) {
    queryParameters['public'] = public;
  }

  final repository = ref.read(playlistRepositoryProvider);
  final subsonicRes = await repository.updatePlaylist(
    playlistId: playlistId,
    songIndexToRemove: songIndexToRemove,
    songIdToAdd: songIdToAdd,
    name: name,
    comment: comment,
    public: public,
  );
  ref.invalidate(playlistDetailProvider(playlistId));
  ref.invalidate(playlistsProvider);
  return subsonicRes;
}

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
    ref.invalidate(playlistDetailProvider(playlistId));
    ref.invalidate(playlistsProvider);
    ref.invalidate(playlistDetailResultProvider(playlistId));
    ref.invalidate(playlistsResultProvider);
  }

  return result;
}

@riverpod
class Playlists extends _$Playlists {
  @override
  Future<SubsonicResponse?> build() async {
    final repository = ref.read(playlistRepositoryProvider);
    return repository.fetchPlaylists();
  }

  Future<SubsonicResponse?> createPlaylist(String? name) async {
    if (name == null) return null;

    final repository = ref.read(playlistRepositoryProvider);
    final data = await repository.createPlaylist(name);
    ref.invalidateSelf();
    return data;
  }

  Future<Result<SubsonicResponse, AppFailure>?> createPlaylistResult(
    String? name,
  ) async {
    if (name == null) return null;
    final repository = ref.read(playlistRepositoryProvider);
    final result = await repository.createPlaylistResult(name);
    if (result.isOk) {
      ref.invalidateSelf();
      ref.invalidate(playlistsResultProvider);
    }
    return result;
  }

  Future<SubsonicResponse?> deletePlaytlist(String? playlistId) async {
    if (playlistId == null) return null;
    final repository = ref.read(playlistRepositoryProvider);
    final data = await repository.deletePlaylist(playlistId);
    ref.invalidateSelf();
    return data;
  }

  Future<Result<SubsonicResponse, AppFailure>?> deletePlaytlistResult(
    String? playlistId,
  ) async {
    if (playlistId == null) return null;
    final repository = ref.read(playlistRepositoryProvider);
    final result = await repository.deletePlaylistResult(playlistId);
    if (result.isOk) {
      ref.invalidateSelf();
      ref.invalidate(playlistsResultProvider);
    }
    return result;
  }
}

@riverpod
Future<SubsonicResponse?> playlistDetail(Ref ref, String? playlistId) async {
  if (playlistId == null) return null;
  final repository = ref.read(playlistRepositoryProvider);
  return repository.fetchPlaylistDetail(playlistId);
}

@riverpod
class PlaylistUpdate extends _$PlaylistUpdate {
  @override
  Future<SubsonicResponse?> build() async {
    return null;
  }

  Future<SubsonicResponse?> modify({
    required String playlistId,
    int? songIndexToRemove,
    String? songIdToAdd,
    String? name,
    String? comment,
    bool? public,
  }) async {
    state = const AsyncLoading();
    final subsonicRes = await updatePlaylistRequest(
      ref: ref,
      playlistId: playlistId,
      songIndexToRemove: songIndexToRemove,
      songIdToAdd: songIdToAdd,
      name: name,
      comment: comment,
      public: public,
    );
    state = AsyncData(subsonicRes);
    return subsonicRes;
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
