import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/repository/common/repository_guard.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

/// Playback states accepted by the OpenSubsonic `reportPlayback` endpoint.
///
/// Mirrors the server-side `ValidStates` map in Navidrome's `play_tracker.go`:
/// `starting`, `playing`, `paused`, `stopped`. The server drives scrobble
/// submission automatically from this state machine, so clients only report
/// transitions and the current position.
enum PlaybackState { starting, playing, paused, stopped }

class PlayerPlaybackRepository {
  PlayerPlaybackRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  /// Reports a playback event to the server-side state machine.
  ///
  /// The server (Navidrome >= 0.63, OpenSubsonic `reportPlayback`) maintains a
  /// per-client `PlaybackSession` and auto-scrobbles when a track reaches the
  /// configured threshold on `stopped`. Pass the real player position via
  /// [positionMs] so the server can render accurate now-playing state.
  Future<SubsonicResponse> reportPlayback({
    required String mediaId,
    required int positionMs,
    required PlaybackState state,
    String mediaType = 'song',
    double playbackRate = 1.0,
    bool ignoreScrobble = false,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/reportPlayback',
      queryParameters: <String, dynamic>{
        'mediaId': mediaId,
        'mediaType': mediaType,
        'positionMs': positionMs,
        'state': state.name,
        'playbackRate': playbackRate,
        'ignoreScrobble': ignoreScrobble,
      },
    );

    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/reportPlayback',
    );
  }

  Future<Result<SubsonicResponse, AppFailure>> tryReportPlayback({
    required String mediaId,
    required int positionMs,
    required PlaybackState state,
    String mediaType = 'song',
    double playbackRate = 1.0,
    bool ignoreScrobble = false,
  }) {
    return runGuarded(
      () => reportPlayback(
        mediaId: mediaId,
        positionMs: positionMs,
        state: state,
        mediaType: mediaType,
        playbackRate: playbackRate,
        ignoreScrobble: ignoreScrobble,
      ),
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

final playerPlaybackRepositoryProvider = Provider<PlayerPlaybackRepository>((
  ref,
) {
  return PlayerPlaybackRepository(() => ref.read(apiProvider.future));
});
