import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:melo_trip/model/response/song/song.dart';

part 'similar_songs2.freezed.dart';
part 'similar_songs2.g.dart';

@freezed
abstract class SimilarSongs2Entity with _$SimilarSongs2Entity {
  const factory SimilarSongs2Entity({List<SongEntity>? song}) =
      _SimilarSongs2Entity;

  factory SimilarSongs2Entity.fromJson(Map<String, dynamic> json) =>
      _$SimilarSongs2EntityFromJson(json);
}
