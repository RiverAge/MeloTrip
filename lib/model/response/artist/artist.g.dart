// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ArtistEntity _$ArtistEntityFromJson(Map<String, dynamic> json) =>
    _ArtistEntity(
      id: json['id'] as String?,
      name: json['name'] as String?,
      coverArt: json['coverArt'] as String?,
      albumCount: (json['albumCount'] as num?)?.toInt(),
      artistImageUrl: json['artistImageUrl'] as String?,
      album:
          (json['album'] as List<dynamic>?)
              ?.map((e) => AlbumEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ArtistEntityToJson(_ArtistEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'coverArt': instance.coverArt,
      'albumCount': instance.albumCount,
      'artistImageUrl': instance.artistImageUrl,
      'album': instance.album,
    };
