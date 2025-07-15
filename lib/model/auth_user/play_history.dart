import 'package:freezed_annotation/freezed_annotation.dart';

part 'play_history.freezed.dart';
part 'play_history.g.dart';

@freezed
abstract class PlayHistory with _$PlayHistory {
  const factory PlayHistory({
    @JsonKey(name: 'song_id') String? songId,
    @JsonKey(name: 'play_count') int? playCount,
    @JsonKey(name: 'last_played') int? lastPlayed,
    @JsonKey(name: 'is_completed') String? isCompleted,
    @JsonKey(name: 'is_skipped') String? isSkipped,
    @JsonKey(name: 'user_id') String? userId,
  }) = _PlayHistory;

  factory PlayHistory.fromJson(Map<String, dynamic> json) =>
      _$PlayHistoryFromJson(json);
}
