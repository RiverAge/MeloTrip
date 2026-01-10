// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_completion_chunk.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ChatCompletionChunk _$ChatCompletionChunkFromJson(Map<String, dynamic> json) =>
    _ChatCompletionChunk(
      id: json['id'] as String?,
      object: json['object'] as String?,
      created: (json['created'] as num?)?.toInt(),
      model: json['model'] as String?,
      choices: (json['choices'] as List<dynamic>?)
          ?.map(
            (e) =>
                ChatCompletionChunkChoice.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      usage: json['usage'] == null
          ? null
          : ChatCompletionChunkUsage.fromJson(
              json['usage'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ChatCompletionChunkToJson(
  _ChatCompletionChunk instance,
) => <String, dynamic>{
  'id': instance.id,
  'object': instance.object,
  'created': instance.created,
  'model': instance.model,
  'choices': instance.choices,
  'usage': instance.usage,
};

_ChatCompletionChunkChoice _$ChatCompletionChunkChoiceFromJson(
  Map<String, dynamic> json,
) => _ChatCompletionChunkChoice(
  index: json['index'] as num?,
  delta: json['delta'] == null
      ? null
      : ChatCompletionChunkChoiceDelta.fromJson(
          json['delta'] as Map<String, dynamic>,
        ),
  message: json['message'] == null
      ? null
      : ChatCompletionChunkChoiceDelta.fromJson(
          json['message'] as Map<String, dynamic>,
        ),
  logprobs: json['logprobs'] as String?,
  finishReason: json['finish_reason'] as String?,
  matchedStop: json['matched_stop'] as num?,
);

Map<String, dynamic> _$ChatCompletionChunkChoiceToJson(
  _ChatCompletionChunkChoice instance,
) => <String, dynamic>{
  'index': instance.index,
  'delta': instance.delta,
  'message': instance.message,
  'logprobs': instance.logprobs,
  'finish_reason': instance.finishReason,
  'matched_stop': instance.matchedStop,
};

_ChatCompletionChunkChoiceDelta _$ChatCompletionChunkChoiceDeltaFromJson(
  Map<String, dynamic> json,
) => _ChatCompletionChunkChoiceDelta(
  role: json['role'] as String?,
  content: json['content'] as String?,
  reasoningContent: json['reasoning_content'] as String?,
  toolCalls: json['tool_calls'] as String?,
);

Map<String, dynamic> _$ChatCompletionChunkChoiceDeltaToJson(
  _ChatCompletionChunkChoiceDelta instance,
) => <String, dynamic>{
  'role': instance.role,
  'content': instance.content,
  'reasoning_content': instance.reasoningContent,
  'tool_calls': instance.toolCalls,
};

_ChatCompletionChunkUsage _$ChatCompletionChunkUsageFromJson(
  Map<String, dynamic> json,
) => _ChatCompletionChunkUsage(
  promptTokens: json['prompt_tokens'] as num?,
  totalTokens: json['total_tokens'] as num?,
  completionTokens: json['completion_tokens'] as num?,
  promptTokensDetails: json['prompt_tokens_details'] as String?,
  reasoningTokens: json['reasoning_tokens'] as num?,
);

Map<String, dynamic> _$ChatCompletionChunkUsageToJson(
  _ChatCompletionChunkUsage instance,
) => <String, dynamic>{
  'prompt_tokens': instance.promptTokens,
  'total_tokens': instance.totalTokens,
  'completion_tokens': instance.completionTokens,
  'prompt_tokens_details': instance.promptTokensDetails,
  'reasoning_tokens': instance.reasoningTokens,
};
