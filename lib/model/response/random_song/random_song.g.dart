// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'random_song.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RandomSongsEntityImpl _$$RandomSongsEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$RandomSongsEntityImpl(
      song: (json['song'] as List<dynamic>?)
          ?.map((e) => SongEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RandomSongsEntityImplToJson(
        _$RandomSongsEntityImpl instance) =>
    <String, dynamic>{
      'song': instance.song,
    };
