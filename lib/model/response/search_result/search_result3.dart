import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/song/song.dart';

part 'search_result3.freezed.dart';
part 'search_result3.g.dart';

@freezed
abstract class SearchResult3Entity with _$SearchResult3Entity {
  const factory SearchResult3Entity({
    List<AlbumEntity>? album,
    List<SongEntity>? song,
    List<ArtistEntity>? artist,
  }) = _SearchResult3Entity;

  factory SearchResult3Entity.fromJson(Map<String, dynamic> json) =>
      _$SearchResult3EntityFromJson(json);
}
