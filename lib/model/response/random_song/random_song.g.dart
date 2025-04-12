// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RandomSongsEntity _$RandomSongsEntityFromJson(Map<String, dynamic> json) =>
    _RandomSongsEntity(
      song:
          (json['song'] as List<dynamic>?)
              ?.map((e) => SongEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$RandomSongsEntityToJson(_RandomSongsEntity instance) =>
    <String, dynamic>{'song': instance.song};
