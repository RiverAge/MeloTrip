// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'songs_by_gener.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SongsByGenreEntity _$SongsByGenreEntityFromJson(Map<String, dynamic> json) =>
    _SongsByGenreEntity(
      song:
          (json['song'] as List<dynamic>?)
              ?.map((e) => SongEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$SongsByGenreEntityToJson(_SongsByGenreEntity instance) =>
    <String, dynamic>{'song': instance.song};
