// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'genre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenresEntity _$GenresEntityFromJson(Map<String, dynamic> json) =>
    _GenresEntity(
      genre: (json['genre'] as List<dynamic>?)
          ?.map((e) => GenreEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GenresEntityToJson(_GenresEntity instance) =>
    <String, dynamic>{'genre': instance.genre};

_GenreEntity _$GenreEntityFromJson(Map<String, dynamic> json) => _GenreEntity(
  value: json['value'] as String?,
  songCount: (json['songCount'] as num?)?.toInt(),
  albumCount: (json['albumCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$GenreEntityToJson(_GenreEntity instance) =>
    <String, dynamic>{
      'value': instance.value,
      'songCount': instance.songCount,
      'albumCount': instance.albumCount,
    };
