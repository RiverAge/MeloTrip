// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'smart_suggestion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SmartSuggestion _$SmartSuggestionFromJson(Map<String, dynamic> json) =>
    _SmartSuggestion(
      songId: json['song_id'] as String?,
      meta: json['meta'] as String?,
      userId: json['user_id'] as String?,
    );

Map<String, dynamic> _$SmartSuggestionToJson(_SmartSuggestion instance) =>
    <String, dynamic>{
      'song_id': instance.songId,
      'meta': instance.meta,
      'user_id': instance.userId,
    };
