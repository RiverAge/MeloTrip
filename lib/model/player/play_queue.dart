import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:melo_trip/model/response/song/song.dart';

part 'play_queue.freezed.dart';
part 'play_queue.g.dart';

@freezed
abstract class PlayQueue with _$PlayQueue {
  const factory PlayQueue({
    @Default([]) List<SongEntity> songs,
    @Default(-1) int index,
  }) = _PlayQueue;

  factory PlayQueue.fromJson(Map<String, dynamic> json) =>
      _$PlayQueueFromJson(json);
}
