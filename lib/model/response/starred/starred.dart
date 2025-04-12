import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'starred.freezed.dart';
part 'starred.g.dart';

@freezed
abstract class StarredEntity with _$StarredEntity {
  const factory StarredEntity({
    List<SongEntity>? song,
    List<AlbumEntity>? album,
  }) = _StarredEntity;

  factory StarredEntity.fromJson(Map<String, dynamic> json) =>
      _$StarredEntityFromJson(json);
}
