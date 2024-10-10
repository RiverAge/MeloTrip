// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'starred.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StarredEntityImpl _$$StarredEntityImplFromJson(Map<String, dynamic> json) =>
    _$StarredEntityImpl(
      song: (json['song'] as List<dynamic>?)
          ?.map((e) => SongEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      album: (json['album'] as List<dynamic>?)
          ?.map((e) => AlbumEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$StarredEntityImplToJson(_$StarredEntityImpl instance) =>
    <String, dynamic>{
      'song': instance.song,
      'album': instance.album,
    };
