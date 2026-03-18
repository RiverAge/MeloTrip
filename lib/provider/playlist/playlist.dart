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

  Future<SubsonicResponse?> deletePlaytlist(String? playlistId) async {
    if (playlistId == null) return null;
    final repository = ref.read(playlistRepositoryProvider);
    final data = await repository.deletePlaylist(playlistId);
    ref.invalidateSelf();
    return data;
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
}
