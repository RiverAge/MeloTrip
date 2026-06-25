import 'package:melo_trip/model/response/subsonic_response.dart';

/// Error thrown when a song has not been analyzed by AudioMuse-AI plugin.
class SongNotAnalyzedError implements Exception {
  const SongNotAnalyzedError(this.songId, this.endpoint);

  final String? songId;
  final String endpoint;

  @override
  String toString() => 'Song $songId has not been analyzed by AudioMuse-AI (endpoint: $endpoint)';
}

SubsonicResponse parseSubsonicResponseOrThrow(
  Map<String, dynamic>? data, {
  required String endpoint,
  String? songId,
}) {
  if (data == null) {
    throw StateError('Empty response payload: $endpoint');
  }

  final response = SubsonicResponse.fromJson(data);
  final status = response.subsonicResponse?.status;
  final message = response.subsonicResponse?.error?.message;

  // Detect 404 from AudioMuse-AI plugin - song not analyzed
  if (message != null && message.contains('AudioMuse-AI returned status 404')) {
    throw SongNotAnalyzedError(songId, endpoint);
  }

  if (message != null && message.isNotEmpty) {
    throw StateError(message);
  }

  if (status != null && status != 'ok') {
    throw StateError('Subsonic request failed: $endpoint (status=$status)');
  }

  return response;
}
