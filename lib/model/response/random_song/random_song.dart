import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:melo_trip/model/response/song/song.dart';

part 'random_song.freezed.dart';
part 'random_song.g.dart';

@freezed
abstract class RandomSongsEntity with _$RandomSongsEntity {
  const factory RandomSongsEntity({List<SongEntity>? song}) =
      _RandomSongsEntity;

  factory RandomSongsEntity.fromJson(Map<String, Object?> json) =>
      _$RandomSongsEntityFromJson(json);
}
