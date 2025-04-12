// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'album.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AlbumEntity _$AlbumEntityFromJson(Map<String, dynamic> json) => _AlbumEntity(
  id: json['id'] as String?,
  name: json['name'] as String?,
  artist: json['artist'] as String?,
  artistId: json['artistId'] as String?,
  coverArt: json['coverArt'] as String?,
  songCount: (json['songCount'] as num?)?.toInt(),
  duration: (json['duration'] as num?)?.toInt(),
  created:
      json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
  starred:
      json['starred'] == null
          ? null
          : DateTime.parse(json['starred'] as String),
  year: (json['year'] as num?)?.toInt(),
  genre: json['genre'] as String?,
  userRating: (json['userRating'] as num?)?.toInt(),
  genres:
      (json['genres'] as List<dynamic>?)
          ?.map((e) => GenreElement.fromJson(e as Map<String, dynamic>))
          .toList(),
  musicBrainzId: json['musicBrainzId'] as String?,
  isCompilation: json['isCompilation'] as bool?,
  sortName: json['sortName'] as String?,
  discTitles:
      (json['discTitles'] as List<dynamic>?)
          ?.map((e) => DiscTitle.fromJson(e as Map<String, dynamic>))
          .toList(),
  originalReleaseDate:
      json['originalReleaseDate'] == null
          ? null
          : ReleaseDate.fromJson(
            json['originalReleaseDate'] as Map<String, dynamic>,
          ),
  releaseDate:
      json['releaseDate'] == null
          ? null
          : ReleaseDate.fromJson(json['releaseDate'] as Map<String, dynamic>),
  song:
      (json['song'] as List<dynamic>?)
          ?.map((e) => SongEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$AlbumEntityToJson(_AlbumEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'artist': instance.artist,
      'artistId': instance.artistId,
      'coverArt': instance.coverArt,
      'songCount': instance.songCount,
      'duration': instance.duration,
      'created': instance.created?.toIso8601String(),
      'starred': instance.starred?.toIso8601String(),
      'year': instance.year,
      'genre': instance.genre,
      'userRating': instance.userRating,
      'genres': instance.genres,
      'musicBrainzId': instance.musicBrainzId,
      'isCompilation': instance.isCompilation,
      'sortName': instance.sortName,
      'discTitles': instance.discTitles,
      'originalReleaseDate': instance.originalReleaseDate,
      'releaseDate': instance.releaseDate,
      'song': instance.song,
    };

_DiscTitle _$DiscTitleFromJson(Map<String, dynamic> json) => _DiscTitle(
  disc: (json['disc'] as num?)?.toInt(),
  title: json['title'] as String?,
);

Map<String, dynamic> _$DiscTitleToJson(_DiscTitle instance) =>
    <String, dynamic>{'disc': instance.disc, 'title': instance.title};

_ReleaseDate _$ReleaseDateFromJson(Map<String, dynamic> json) => _ReleaseDate();

Map<String, dynamic> _$ReleaseDateToJson(_ReleaseDate instance) =>
    <String, dynamic>{};

_AlbumListEntity _$AlbumListEntityFromJson(Map<String, dynamic> json) =>
    _AlbumListEntity(
      album:
          (json['album'] as List<dynamic>?)
              ?.map((e) => AlbumEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$AlbumListEntityToJson(_AlbumListEntity instance) =>
    <String, dynamic>{'album': instance.album};
