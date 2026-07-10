import 'package:freezed_annotation/freezed_annotation.dart';

part 'song.freezed.dart';
part 'song.g.dart';

@freezed
abstract class SongEntity with _$SongEntity {
  const factory SongEntity({
    String? id,
    String? parent,
    bool? isDir,
    String? title,
    String? album,
    String? artist,
    int? track,
    int? year,
    String? coverArt,
    int? size,
    String? contentType,
    String? suffix,
    DateTime? starred,
    int? duration,
    int? bitRate,
    String? path,
    int? discNumber,
    DateTime? created,
    String? albumId,
    String? artistId,
    String? type,
    int? userRating,
    bool? isVideo,
    int? bpm,
    String? comment,
    String? sortName,
    String? mediaType,
    String? musicBrainzId,
    List<GenreElement>? genres,
    ReplayGain? replayGain,
    int? channelCount,
    String? genre,
    int? samplingRate,
    int? bitDepth,
    List<String>? moods,
    List<ParticipateEntity>? artists,
    String? displayArtist,
    List<ParticipateEntity>? albumArtists,
    String? displayAlbumArtist,
    @ContributorConverter() List<ContributorEntity>? contributors,
    String? displayComposer,
    String? explicitStatus,
  }) = _SongEntity;

  factory SongEntity.fromJson(Map<String, Object?> json) =>
      _$SongEntityFromJson(json);
}

@freezed
abstract class ParticipateEntity with _$ParticipateEntity {
  const factory ParticipateEntity({String? id, String? name}) =
      _ParticipateEntity;

  factory ParticipateEntity.fromJson(Map<String, Object?> json) =>
      _$ParticipateEntityFromJson(json);
}

/// A non-artist participant on a track (composer, lyricist, performer, ...).
///
/// Mirrors the OpenSubsonic `contributor` object as served by Navidrome:
/// `{ role, subRole?, artist: { id, name } }`. The nested `artist` is flattened
/// onto this entity via [ContributorConverter] so callers can read
/// `id`/`name` directly.
@freezed
abstract class ContributorEntity with _$ContributorEntity {
  const factory ContributorEntity({
    String? role,
    String? subRole,
    String? id,
    String? name,
  }) = _ContributorEntity;

  factory ContributorEntity.fromJson(Map<String, Object?> json) =>
      _$ContributorEntityFromJson(json);
}

/// Converts between Navidrome's nested OpenSubsonic `contributor` shape
/// `{ role, subRole?, artist: { id, name } }` and the flat [ContributorEntity].
class ContributorConverter
    implements JsonConverter<ContributorEntity, Map<String, dynamic>> {
  const ContributorConverter();

  @override
  ContributorEntity fromJson(Map<String, dynamic> json) {
    final artist = json['artist'];
    final artistMap = artist is Map<String, dynamic>
        ? artist
        : const <String, dynamic>{};
    return ContributorEntity(
      role: json['role'] as String?,
      subRole: json['subRole'] as String?,
      id: artistMap['id'] as String?,
      name: artistMap['name'] as String?,
    );
  }

  @override
  Map<String, dynamic> toJson(ContributorEntity object) => <String, dynamic>{
        'role': object.role,
        'subRole': object.subRole,
        'artist': {'id': object.id, 'name': object.name},
      };
}

@freezed
abstract class GenreElement with _$GenreElement {
  const factory GenreElement({String? name}) = _GenreElement;

  factory GenreElement.fromJson(Map<String, Object?> json) =>
      _$GenreElementFromJson(json);
}

@freezed
abstract class ReplayGain with _$ReplayGain {
  const factory ReplayGain({int? trackPeak, int? albumPeak}) = _ReplayGain;
  factory ReplayGain.fromJson(Map<String, Object?> json) =>
      _$ReplayGainFromJson(json);
}
