import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
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
}

final playlistRepositoryProvider = Provider<PlaylistRepository>((ref) {
  return PlaylistRepository(() => ref.read(apiProvider.future));
});
