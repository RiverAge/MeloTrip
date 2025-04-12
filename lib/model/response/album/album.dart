import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:melo_trip/model/response/song/song.dart';
part 'album.freezed.dart';
part 'album.g.dart';

@freezed
abstract class AlbumEntity with _$AlbumEntity {
  const factory AlbumEntity({
    String? id,
    String? name,
    String? artist,
    String? artistId,
    String? coverArt,
    int? songCount,
    int? duration,
    DateTime? created,
    DateTime? starred,
    int? year,
    String? genre,
    int? userRating,
    List<GenreElement>? genres,
    String? musicBrainzId,
    bool? isCompilation,
    String? sortName,
    List<DiscTitle>? discTitles,
    ReleaseDate? originalReleaseDate,
    ReleaseDate? releaseDate,
    List<SongEntity>? song,
  }) = _AlbumEntity;

  factory AlbumEntity.fromJson(Map<String, dynamic> json) =>
      _$AlbumEntityFromJson(json);
}

@freezed
abstract class DiscTitle with _$DiscTitle {
  const factory DiscTitle({int? disc, String? title}) = _DiscTitle;

  factory DiscTitle.fromJson(Map<String, dynamic> json) =>
      _$DiscTitleFromJson(json);
}

@freezed
abstract class ReleaseDate with _$ReleaseDate {
  const factory ReleaseDate() = _ReleaseDate;

  factory ReleaseDate.fromJson(Map<String, dynamic> json) =>
      _$ReleaseDateFromJson(json);
}

@freezed
abstract class AlbumListEntity with _$AlbumListEntity {
  const factory AlbumListEntity({List<AlbumEntity>? album}) = _AlbumListEntity;

  factory AlbumListEntity.fromJson(Map<String, dynamic> json) =>
      _$AlbumListEntityFromJson(json);
}
