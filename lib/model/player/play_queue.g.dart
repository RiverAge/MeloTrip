// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_queue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayQueue _$PlayQueueFromJson(Map<String, dynamic> json) => _PlayQueue(
  songs:
      (json['songs'] as List<dynamic>?)
          ?.map((e) => SongEntity.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  index: (json['index'] as num?)?.toInt() ?? -1,
);

Map<String, dynamic> _$PlayQueueToJson(_PlayQueue instance) =>
    <String, dynamic>{'songs': instance.songs, 'index': instance.index};
