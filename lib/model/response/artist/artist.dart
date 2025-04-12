import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:melo_trip/model/response/album/album.dart';

part 'artist.freezed.dart';
part 'artist.g.dart';

@freezed
abstract class ArtistEntity with _$ArtistEntity {
  const factory ArtistEntity({
    String? id,
    String? name,
    String? coverArt,
    int? albumCount,
    String? artistImageUrl,
    List<AlbumEntity>? album,
  }) = _ArtistEntity;

  factory ArtistEntity.fromJson(Map<String, dynamic> json) =>
      _$ArtistEntityFromJson(json);
}
