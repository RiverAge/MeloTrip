import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_completion_chunk.freezed.dart';
part 'chat_completion_chunk.g.dart';

@freezed
abstract class ChatCompletionChunk with _$ChatCompletionChunk {
  const factory ChatCompletionChunk({
    String? id,
    String? object,
    int? created,
    String? model,
    List<ChatCompletionChunkChoice>? choices,
    ChatCompletionChunkUsage? usage,
  }) = _ChatCompletionChunk;

  factory ChatCompletionChunk.fromJson(Map<String, dynamic> json) =>
      _$ChatCompletionChunkFromJson(json);
}

@freezed
abstract class ChatCompletionChunkChoice with _$ChatCompletionChunkChoice {
  const factory ChatCompletionChunkChoice({
    num? index,
    ChatCompletionChunkChoiceDelta? delta,
    ChatCompletionChunkChoiceDelta? message,
    String? logprobs,
    @JsonKey(name: 'finish_reason') String? finishReason,
    @JsonKey(name: 'matched_stop') num? matchedStop,
  }) = _ChatCompletionChunkChoice;

  factory ChatCompletionChunkChoice.fromJson(Map<String, dynamic> json) =>
      _$ChatCompletionChunkChoiceFromJson(json);
}

@freezed
abstract class ChatCompletionChunkChoiceDelta
    with _$ChatCompletionChunkChoiceDelta {
  const factory ChatCompletionChunkChoiceDelta({
    String? role,
    String? content,
    @JsonKey(name: 'reasoning_content') String? reasoningContent,
    @JsonKey(name: 'tool_calls') String? toolCalls,
  }) = _ChatCompletionChunkChoiceDelta;

  factory ChatCompletionChunkChoiceDelta.fromJson(Map<String, dynamic> json) =>
      _$ChatCompletionChunkChoiceDeltaFromJson(json);
}

@freezed
abstract class ChatCompletionChunkUsage with _$ChatCompletionChunkUsage {
  const factory ChatCompletionChunkUsage({
    @JsonKey(name: 'prompt_tokens') num? promptTokens,
    @JsonKey(name: 'total_tokens') num? totalTokens,
    @JsonKey(name: 'completion_tokens') num? completionTokens,
    @JsonKey(name: 'prompt_tokens_details') String? promptTokensDetails,
    @JsonKey(name: 'reasoning_tokens') num? reasoningTokens,
  }) = _ChatCompletionChunkUsage;

  factory ChatCompletionChunkUsage.fromJson(Map<String, dynamic> json) =>
      _$ChatCompletionChunkUsageFromJson(json);
}
