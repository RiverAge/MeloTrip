import 'package:freezed_annotation/freezed_annotation.dart';

part 'smart_suggestion.freezed.dart';
part 'smart_suggestion.g.dart';

@freezed
abstract class SmartSuggestion with _$SmartSuggestion {
  const factory SmartSuggestion({
    @JsonKey(name: 'song_id') String? songId,
    @JsonKey(name: 'meta') String? meta,
    @JsonKey(name: 'user_id') String? userId,
  }) = _SmartSuggestion;

  factory SmartSuggestion.fromJson(Map<String, dynamic> json) =>
      _$SmartSuggestionFromJson(json);
}
