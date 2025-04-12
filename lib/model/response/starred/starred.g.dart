// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'starred.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StarredEntity _$StarredEntityFromJson(Map<String, dynamic> json) =>
    _StarredEntity(
      song:
          (json['song'] as List<dynamic>?)
              ?.map((e) => SongEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
      album:
          (json['album'] as List<dynamic>?)
              ?.map((e) => AlbumEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$StarredEntityToJson(_StarredEntity instance) =>
    <String, dynamic>{'song': instance.song, 'album': instance.album};
