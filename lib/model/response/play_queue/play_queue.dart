import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:melo_trip/model/response/song/song.dart';

part 'play_queue.freezed.dart';
part 'play_queue.g.dart';

@freezed
abstract class PlayQueueEntity with _$PlayQueueEntity {
  const factory PlayQueueEntity({
    List<SongEntity>? entry,
    String? current,
    int? position,
    String? username,
    DateTime? changed,
    String? changedBy,
  }) = _PlayQueueEntityClass;

  factory PlayQueueEntity.fromJson(Map<String, dynamic> json) =>
      _$PlayQueueEntityFromJson(json);
}
