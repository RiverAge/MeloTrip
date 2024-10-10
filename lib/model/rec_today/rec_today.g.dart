// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rec_today.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecTodayEntityImpl _$$RecTodayEntityImplFromJson(Map<String, dynamic> json) =>
    _$RecTodayEntityImpl(
      update: json['update'] == null
          ? null
          : DateTime.parse(json['update'] as String),
      songs: (json['songs'] as List<dynamic>?)
          ?.map((e) => SongEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RecTodayEntityImplToJson(
        _$RecTodayEntityImpl instance) =>
    <String, dynamic>{
      'update': instance.update?.toIso8601String(),
      'songs': instance.songs,
    };
