import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:melo_trip/model/response/song/song.dart';

part 'sonic_similarity.freezed.dart';
part 'sonic_similarity.g.dart';

/// Represents a single match in sonic similarity results.
/// Contains the song (as Child/Entry) and its similarity score.
/// Maps to Navidrome's SonicMatch type in responses.
@freezed
abstract class SonicMatch with _$SonicMatch {
  const factory SonicMatch({
    /// The matched song entry (named "entry" in Navidrome response)
    @JsonKey(name: 'entry') SongEntity? entry,

    /// Similarity score (0.0 to 1.0, higher is more similar)
    /// This field comes from the AudioMuse-AI plugin response
    double? similarity,
  }) = _SonicMatch;

  factory SonicMatch.fromJson(Map<String, dynamic> json) =>
      _$SonicMatchFromJson(json);
}

/// Response wrapper for sonic match array
/// The Navidrome response has "sonicMatch" as the key (Array type)
@freezed
abstract class SonicMatchesEntity with _$SonicMatchesEntity {
  const factory SonicMatchesEntity({
    /// List of sonic matches
    @JsonKey(name: 'sonicMatch') @Default([]) List<SonicMatch> sonicMatch,
  }) = _SonicMatchesEntity;

  factory SonicMatchesEntity.fromJson(Map<String, dynamic> json) =>
      _$SonicMatchesEntityFromJson(json);
}

