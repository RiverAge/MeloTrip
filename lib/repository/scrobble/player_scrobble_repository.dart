import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/repository/common/repository_guard.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

class PlayerScrobbleRepository {
  PlayerScrobbleRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse> scrobble({
    required String songId,
    required bool submission,
    int? time,
  }) async {
    final api = await _readApi();
    final queryParameters = <String, dynamic>{
      'id': songId,
      'submission': submission,
      'time': time,
    }..removeWhere((_, value) => value == null);
    final res = await api.get<Map<String, dynamic>>(
      '/rest/scrobble',
      queryParameters: queryParameters,
    );

    return parseSubsonicResponseOrThrow(res.data, endpoint: '/rest/scrobble');
  }

  Future<Result<SubsonicResponse, AppFailure>> tryScrobble({
    required String songId,
    required bool submission,
    int? time,
  }) {
    return runGuarded(
      () => scrobble(songId: songId, submission: submission, time: time),
    );
  }

  Future<SubsonicResponse> savePlayQueue({
    required List<String> songIds,
    String? currentSongId,
  }) async {
    final api = await _readApi();
    final path = _buildSavePlayQueuePath(
      songIds: songIds,
      currentSongId: currentSongId,
    );
    final res = await api.get<Map<String, dynamic>>(path);
    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/savePlayQueue',
    );
  }

  Future<Result<SubsonicResponse, AppFailure>> trySavePlayQueue({
    required List<String> songIds,
    String? currentSongId,
  }) {
    return runGuarded(
      () => savePlayQueue(songIds: songIds, currentSongId: currentSongId),
    );
  }

  String _buildSavePlayQueuePath({
    required List<String> songIds,
    String? currentSongId,
  }) {
    if (songIds.isEmpty) {
      return '/rest/savePlayQueue';
    }

    final parameters = <String>[
      for (final songId in songIds)
        'id=${Uri.encodeQueryComponent(songId)}',
      if (currentSongId != null && currentSongId.isNotEmpty)
        'current=${Uri.encodeQueryComponent(currentSongId)}',
    ];

    return '/rest/savePlayQueue?${parameters.join('&')}';
  }
}

final playerScrobbleRepositoryProvider = Provider<PlayerScrobbleRepository>((
  ref,
) {
  return PlayerScrobbleRepository(() => ref.read(apiProvider.future));
});
