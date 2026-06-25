import 'package:melo_trip/model/response/song/song.dart';

/// Result type for sonic similarity API calls.
///
/// Wraps the list of similar songs with metadata about whether
/// the source song has been analyzed by AudioMuse-AI.
class SonicSimilarityResult {
  const SonicSimilarityResult({
    required this.songs,
    this.isUnanalyzed = false,
  });

  /// Empty result with no songs.
  static const empty = SonicSimilarityResult(songs: []);

  /// Result for songs not yet analyzed by AudioMuse-AI.
  static const unanalyzed = SonicSimilarityResult(
    songs: [],
    isUnanalyzed: true,
  );

  /// List of similar songs found.
  final List<SongEntity> songs;

  /// True if the source song has not been analyzed by AudioMuse-AI plugin.
  ///
  /// When true, [songs] will be empty and the UI should show a message
  /// indicating the song needs to be analyzed before similar songs can be found.
  final bool isUnanalyzed;

  /// Returns true if there are no songs in the result.
  bool get isEmpty => songs.isEmpty;

  /// Returns true if there are songs in the result.
  bool get isNotEmpty => songs.isNotEmpty;
}
