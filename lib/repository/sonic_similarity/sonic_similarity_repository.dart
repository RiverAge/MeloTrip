import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/repository/common/repository_guard.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

/// Repository for AudioMuse-AI Navidrome plugin sonic similarity endpoints.
/// These are OpenSubsonic extensions provided by the AudioMuse-AI plugin.
///
/// Endpoints:
/// - `/rest/getSonicSimilarTracks.view?id=<songId>&count=<count>`
/// - `/rest/findSonicPath.view?startSongId=<from>&endSongId=<to>&count=<count>`
///
/// IMPORTANT: Do NOT fallback to `/rest/getSimilarSongs2.view`.
/// If these endpoints are unavailable, return empty results or errors.
class SonicSimilarityRepository {
  SonicSimilarityRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  /// Get similar tracks using AudioMuse-AI plugin.
  /// This is song-level acoustic similarity, NOT user personalized recommendations.
  ///
  /// Endpoint: /rest/getSonicSimilarTracks.view
  /// Parameters:
  /// - id: The song ID to find similar tracks for
  /// - count: Maximum number of similar tracks to return (default 10)
  ///
  /// Returns SonicMatchesEntity with list of SonicMatch (entry + similarity).
  Future<SubsonicResponse> fetchSonicSimilarTracks({
    required String id,
    int? count,
    CancelToken? cancelToken,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/getSonicSimilarTracks.view',
      queryParameters: <String, dynamic>{
        'id': id,
        ...?count != null ? {'count': count} : null,
      },
      cancelToken: cancelToken,
    );
    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/getSonicSimilarTracks.view',
    );
  }

  /// Get similar tracks with Result wrapper.
  /// Returns list of SongEntity extracted from SonicMatch entries.
  /// IMPORTANT: Does NOT fallback to getSimilarSongs2.
  Future<Result<List<SongEntity>, AppFailure>> tryFetchSonicSimilarTracks({
    required String id,
    int? count,
    CancelToken? cancelToken,
  }) {
    return runGuarded(() async {
      final response = await fetchSonicSimilarTracks(
        id: id,
        count: count,
        cancelToken: cancelToken,
      );
      final matches = response.subsonicResponse?.sonicMatch ?? const [];
      // Extract SongEntity from SonicMatch.entry
      return matches
          .map((match) => match.entry)
          .whereType<SongEntity>()
          .toList();
    });
  }

  /// Get similar tracks with similarity scores.
  /// Returns list of (SongEntity, similarity) tuples.
  Future<Result<List<(SongEntity, double?)>, AppFailure>>
  tryFetchSonicSimilarTracksWithScores({
    required String id,
    int? count,
    CancelToken? cancelToken,
  }) {
    return runGuarded(() async {
      final response = await fetchSonicSimilarTracks(
        id: id,
        count: count,
        cancelToken: cancelToken,
      );
      final matches = response.subsonicResponse?.sonicMatch ?? const [];
      return matches
          .where((match) => match.entry != null)
          .map((match) => (match.entry!, match.similarity))
          .toList();
    });
  }

  /// Find sonic path between two songs.
  /// This generates an acoustic transition path from start to end song.
  ///
  /// Endpoint: /rest/findSonicPath.view
  /// Parameters:
  /// - startSongId: The starting song ID
  /// - endSongId: The destination song ID
  /// - count: Number of songs in the path (default 25)
  ///
  /// Returns SonicMatchesEntity with ordered path of SonicMatch.
  Future<SubsonicResponse> findSonicPath({
    required String startSongId,
    required String endSongId,
    int? count,
    CancelToken? cancelToken,
  }) async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>(
      '/rest/findSonicPath.view',
      queryParameters: <String, dynamic>{
        'startSongId': startSongId,
        'endSongId': endSongId,
        ...?count != null ? {'count': count} : null,
      },
      cancelToken: cancelToken,
    );
    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/findSonicPath.view',
    );
  }

  /// Find sonic path with Result wrapper.
  /// Returns ordered list of songs from start to end.
  Future<Result<List<SongEntity>, AppFailure>> tryFindSonicPath({
    required String startSongId,
    required String endSongId,
    int? count,
    CancelToken? cancelToken,
  }) {
    return runGuarded(() async {
      final response = await findSonicPath(
        startSongId: startSongId,
        endSongId: endSongId,
        count: count,
        cancelToken: cancelToken,
      );
      final matches = response.subsonicResponse?.sonicMatch ?? const [];
      // Extract SongEntity from SonicMatch.entry, preserving order
      return matches
          .map((match) => match.entry)
          .whereType<SongEntity>()
          .toList();
    });
  }

  /// Find sonic path with similarity scores.
  /// Returns ordered list of (SongEntity, similarity) tuples.
  Future<Result<List<(SongEntity, double?)>, AppFailure>>
  tryFindSonicPathWithScores({
    required String startSongId,
    required String endSongId,
    int? count,
    CancelToken? cancelToken,
  }) {
    return runGuarded(() async {
      final response = await findSonicPath(
        startSongId: startSongId,
        endSongId: endSongId,
        count: count,
        cancelToken: cancelToken,
      );
      final matches = response.subsonicResponse?.sonicMatch ?? const [];
      return matches
          .where((match) => match.entry != null)
          .map((match) => (match.entry!, match.similarity))
          .toList();
    });
  }
}

/// Provider for SonicSimilarityRepository
final sonicSimilarityRepositoryProvider = Provider<SonicSimilarityRepository>((
  ref,
) {
  return SonicSimilarityRepository(() => ref.read(apiProvider.future));
});
