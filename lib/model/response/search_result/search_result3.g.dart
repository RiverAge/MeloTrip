// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_result3.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchResult3Entity _$SearchResult3EntityFromJson(Map<String, dynamic> json) =>
    _SearchResult3Entity(
      album:
          (json['album'] as List<dynamic>?)
              ?.map((e) => AlbumEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
      song:
          (json['song'] as List<dynamic>?)
              ?.map((e) => SongEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
      artist:
          (json['artist'] as List<dynamic>?)
              ?.map((e) => ArtistEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$SearchResult3EntityToJson(
  _SearchResult3Entity instance,
) => <String, dynamic>{
  'album': instance.album,
  'song': instance.song,
  'artist': instance.artist,
};
