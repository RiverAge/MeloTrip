import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:melo_trip/model/response/song/song.dart';

part 'rec_today.freezed.dart';
part 'rec_today.g.dart';

@freezed
abstract class RecTodayEntity with _$RecTodayEntity {
  const factory RecTodayEntity({DateTime? update, List<SongEntity>? songs}) =
      _RecTodayEntity;

  factory RecTodayEntity.fromJson(Map<String, dynamic> json) =>
      _$RecTodayEntityFromJson(json);
}
