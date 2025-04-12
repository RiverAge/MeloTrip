// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rec_today.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecTodayEntity _$RecTodayEntityFromJson(Map<String, dynamic> json) =>
    _RecTodayEntity(
      update:
          json['update'] == null
              ? null
              : DateTime.parse(json['update'] as String),
      songs:
          (json['songs'] as List<dynamic>?)
              ?.map((e) => SongEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$RecTodayEntityToJson(_RecTodayEntity instance) =>
    <String, dynamic>{
      'update': instance.update?.toIso8601String(),
      'songs': instance.songs,
    };
