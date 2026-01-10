// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => _ChatModel(
  id: json['id'] as String?,
  object: json['object'] as String?,
  ownedBy: json['owned_by'] as String?,
  created: (json['created'] as num?)?.toInt(),
  maxTokens: (json['maxTokens'] as num?)?.toInt() ?? 4096,
);

Map<String, dynamic> _$ChatModelToJson(_ChatModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'object': instance.object,
      'owned_by': instance.ownedBy,
      'created': instance.created,
      'maxTokens': instance.maxTokens,
    };
