// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => _ChatMessage(
  id: json['id'] as String,
  role: $enumDecode(_$MessageRoleEnumMap, json['role']),
  content: json['content'] as String,
  reasoningContent: json['reasoning_content'] as String?,
  model: json['model'] as String?,
  reasoningDuration: json['reasoning_duration'] == null
      ? null
      : Duration(microseconds: (json['reasoning_duration'] as num).toInt()),
  totalDuration: json['total_duration'] == null
      ? null
      : Duration(microseconds: (json['total_duration'] as num).toInt()),
  timestamp: const EpochDateTimeConverter().fromJson(
    (json['timestamp'] as num).toInt(),
  ),
  isStreaming: json['is_streaming'] == null
      ? false
      : const BooleanConvert().fromJson(
          (json['is_streaming'] as num?)?.toInt(),
        ),
  error: json['error'] as String?,
);

Map<String, dynamic> _$ChatMessageToJson(_ChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': _$MessageRoleEnumMap[instance.role]!,
      'content': instance.content,
      'reasoning_content': instance.reasoningContent,
      'model': instance.model,
      'reasoning_duration': instance.reasoningDuration?.inMicroseconds,
      'total_duration': instance.totalDuration?.inMicroseconds,
      'timestamp': const EpochDateTimeConverter().toJson(instance.timestamp),
      'is_streaming': const BooleanConvert().toJson(instance.isStreaming),
      'error': instance.error,
    };

const _$MessageRoleEnumMap = {
  MessageRole.user: 'user',
  MessageRole.assistant: 'assistant',
  MessageRole.system: 'system',
};

_ChatCoversation _$ChatCoversationFromJson(Map<String, dynamic> json) =>
    _ChatCoversation(
      id: json['id'] as String,
      title: json['title'] as String,
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ChatCoversationToJson(_ChatCoversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'messages': instance.messages,
    };
