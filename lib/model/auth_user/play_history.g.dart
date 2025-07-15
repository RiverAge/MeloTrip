// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'play_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayHistory _$PlayHistoryFromJson(Map<String, dynamic> json) => _PlayHistory(
  songId: json['song_id'] as String?,
  playCount: (json['play_count'] as num?)?.toInt(),
  lastPlayed: (json['last_played'] as num?)?.toInt(),
  isCompleted: json['is_completed'] as String?,
  isSkipped: json['is_skipped'] as String?,
  userId: json['user_id'] as String?,
);

Map<String, dynamic> _$PlayHistoryToJson(_PlayHistory instance) =>
    <String, dynamic>{
      'song_id': instance.songId,
      'play_count': instance.playCount,
      'last_played': instance.lastPlayed,
      'is_completed': instance.isCompleted,
      'is_skipped': instance.isSkipped,
      'user_id': instance.userId,
    };
