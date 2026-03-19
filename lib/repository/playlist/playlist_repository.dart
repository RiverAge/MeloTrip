import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/repository/common/repository_guard.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

class PlaylistRepository {
  PlaylistRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse> fetchPlaylists() async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>('/rest/getPlaylists');
    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/getPlaylists',
    );
  }

  Future<Result<SubsonicResponse, AppFailure>> tryFetchPlaylists() {
    return runGuarded(fetchPlaylists);
  }

  Future<List<PlaylistEntity>> fetchPlaylistItems() async {
    final response = await fetchPlaylists();
    return response.subsonicResponse?.playlists?.playlist ??
        const <PlaylistEntity>[];
  }

  Future<Result<List<PlaylistEntity>, AppFailure>> tryFetchPlaylistItems() {
    return runGuarded(fetchPlaylistItems);
  }

  Future<SubsonicResponse> fetchPlaylistDetail(String playlistId) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/getPlaylist',
      queryParameters: {'id': playlistId},
    );
    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/getPlaylist',
    );
  }

  Future<Result<SubsonicResponse, AppFailure>> tryFetchPlaylistDetail(
    String playlistId,
  ) {
    return runGuarded(() => fetchPlaylistDetail(playlistId));
  }

  Future<PlaylistEntity> fetchPlaylistEntityDetail(String playlistId) async {
    final response = await fetchPlaylistDetail(playlistId);
    final playlist = response.subsonicResponse?.playlist;
    if (playlist == null) {
      throw StateError('Missing playlist payload for /rest/getPlaylist');
    }
    return playlist;
  }

  Future<Result<PlaylistEntity, AppFailure>> tryFetchPlaylistEntityDetail(
    String playlistId,
  ) {
    return runGuarded(() => fetchPlaylistEntityDetail(playlistId));
  }

  Future<SubsonicResponse> createPlaylist(String name) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/createPlaylist',
      queryParameters: {'name': name},
    );
    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/createPlaylist',
    );
  }

  Future<Result<SubsonicResponse, AppFailure>> tryCreatePlaylist(
    String name,
  ) {
    return runGuarded(() => createPlaylist(name));
  }

  Future<SubsonicResponse> deletePlaylist(String playlistId) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/deletePlaylist',
      queryParameters: {'id': playlistId},
    );
    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/deletePlaylist',
    );
  }

  Future<Result<SubsonicResponse, AppFailure>> tryDeletePlaylist(
    String playlistId,
  ) {
    return runGuarded(() => deletePlaylist(playlistId));
  }

  Future<SubsonicResponse> updatePlaylist({
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

    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/updatePlaylist',
      queryParameters: queryParameters,
    );
    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/updatePlaylist',
    );
  }

  Future<Result<SubsonicResponse, AppFailure>> tryUpdatePlaylist({
    required String playlistId,
    int? songIndexToRemove,
    String? songIdToAdd,
    String? name,
    String? comment,
    bool? public,
  }) {
    return runGuarded(
      () => updatePlaylist(
        playlistId: playlistId,
        songIndexToRemove: songIndexToRemove,
        songIdToAdd: songIdToAdd,
        name: name,
        comment: comment,
        public: public,
      ),
    );
  }
}

final playlistRepositoryProvider = Provider<PlaylistRepository>((ref) {
  return PlaylistRepository(() => ref.read(apiProvider.future));
});
