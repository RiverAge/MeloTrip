import 'package:melo_trip/model/response/song/song.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'songs_by_gener.freezed.dart';
part 'songs_by_gener.g.dart';

@freezed
abstract class SongsByGenreEntity with _$SongsByGenreEntity {
  const factory SongsByGenreEntity({List<SongEntity>? song}) =
      _SongsByGenreEntity;

  factory SongsByGenreEntity.fromJson(Map<String, dynamic> json) =>
      _$SongsByGenreEntityFromJson(json);
}
