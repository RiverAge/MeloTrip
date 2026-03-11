import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
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

  final api = await ref.read(apiProvider.future);
  final res = await api.get<Map<String, dynamic>>(
    '/rest/updatePlaylist',
    queryParameters: queryParameters,
  );
  final data = res.data;
  if (data == null) return null;

  final subsonicRes = SubsonicResponse.fromJson(data);
  if (subsonicRes.subsonicResponse?.status != 'ok') return null;

  ref.invalidate(playlistDetailProvider(playlistId));
  ref.invalidate(playlistsProvider);
  return subsonicRes;
}

@riverpod
class Playlists extends _$Playlists {
  @override
  Future<SubsonicResponse?> build() async {
    final api = await ref.read(apiProvider.future);
    final res = await api.get<Map<String, dynamic>>('/rest/getPlaylists');
    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }

  Future<SubsonicResponse?> createPlaylist(String? name) async {
    if (name == null) return null;

    final api = await ref.read(apiProvider.future);
    final res = await api.get<Map<String, dynamic>>(
      '/rest/createPlaylist',
      queryParameters: {'name': name},
    );
    final data = res.data;
    if (data == null) return null;
    ref.invalidateSelf();
    return SubsonicResponse.fromJson(data);
  }

  Future<SubsonicResponse?> deletePlaytlist(String? playlistId) async {
    if (playlistId == null) return null;
    final api = await ref.read(apiProvider.future);
    final res = await api.get<Map<String, dynamic>>(
      '/rest/deletePlaylist',
      queryParameters: {'id': playlistId},
    );
    final data = res.data;
    if (data == null) return null;
    ref.invalidateSelf();
    return SubsonicResponse.fromJson(data);
  }
}

@riverpod
Future<SubsonicResponse?> playlistDetail(Ref ref, String? playlistId) async {
  if (playlistId == null) return null;
  final api = await ref.read(apiProvider.future);
  final res = await api.get<Map<String, dynamic>>(
    '/rest/getPlaylist',
    queryParameters: {'id': playlistId},
  );
  final data = res.data;
  if (data == null) return null;
  return SubsonicResponse.fromJson(data);
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
    if (subsonicRes == null) return null;
    state = AsyncData(subsonicRes);
    return subsonicRes;
  }
}
