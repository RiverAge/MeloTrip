import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'chat_message.freezed.dart';
part 'chat_message.g.dart';

enum MessageRole {
  @JsonValue('user')
  user,
  @JsonValue('assistant')
  assistant,
  @JsonValue('system')
  system,
}

@freezed
abstract class ChatMessage with _$ChatMessage {
  const factory ChatMessage({
    required String id,
    required MessageRole role,
    required String content,
    @JsonKey(name: 'reasoning_content') String? reasoningContent,
    String? model,
    @JsonKey(name: 'reasoning_duration') Duration? reasoningDuration,
    @JsonKey(name: 'total_duration') Duration? totalDuration,

    @EpochDateTimeConverter() required DateTime timestamp,
    @BooleanConvert()
    @JsonKey(name: 'is_streaming')
    @Default(false)
    bool isStreaming,

    String? error,
  }) = _ChatMessage;

  factory ChatMessage.create({
    required String content,
    required MessageRole role,
    String? reasoningContent,
    String? model,
    Duration? reasoningDuration,
    Duration? totalDuration,
    bool isStreaming = false,
    String? error,
  }) => ChatMessage(
    id: const Uuid().v4(),
    timestamp: DateTime.now(),
    reasoningContent: reasoningContent,
    model: model,
    reasoningDuration: reasoningDuration,
    totalDuration: totalDuration,
    isStreaming: isStreaming,
    error: error,
    role: role,
    content: content,
  );

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
}

class EpochDateTimeConverter implements JsonConverter<DateTime, int> {
  const EpochDateTimeConverter();

  @override
  DateTime fromJson(int json) {
    return DateTime.fromMillisecondsSinceEpoch(json);
  }

  @override
  int toJson(DateTime object) {
    return object.millisecondsSinceEpoch;
  }
}

class BooleanConvert implements JsonConverter<bool, int?> {
  const BooleanConvert();

  @override
  bool fromJson(int? json) {
    return json == 1;
  }

  @override
  int? toJson(bool val) {
    return val == true ? 1 : 0;
  }
}

@freezed
abstract class ChatCoversation with _$ChatCoversation {
  const factory ChatCoversation({
    required String id,
    required String title,
    @Default([]) List<ChatMessage> messages,
  }) = _ChatCoversation;

  factory ChatCoversation.create({
    String title = '',
    List<ChatMessage> messages = const [],
  }) => ChatCoversation(id: Uuid().v4(), title: title, messages: messages);

  factory ChatCoversation.fromJson(Map<String, dynamic> json) =>
      _$ChatCoversationFromJson(json);
}
