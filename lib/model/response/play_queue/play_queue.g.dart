// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_queue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayQueueEntityClass _$PlayQueueEntityClassFromJson(
  Map<String, dynamic> json,
) => _PlayQueueEntityClass(
  entry:
      (json['entry'] as List<dynamic>?)
          ?.map((e) => SongEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
  current: json['current'] as String?,
  position: (json['position'] as num?)?.toInt(),
  username: json['username'] as String?,
  changed:
      json['changed'] == null
          ? null
          : DateTime.parse(json['changed'] as String),
  changedBy: json['changedBy'] as String?,
);

Map<String, dynamic> _$PlayQueueEntityClassToJson(
  _PlayQueueEntityClass instance,
) => <String, dynamic>{
  'entry': instance.entry,
  'current': instance.current,
  'position': instance.position,
  'username': instance.username,
  'changed': instance.changed?.toIso8601String(),
  'changedBy': instance.changedBy,
};
