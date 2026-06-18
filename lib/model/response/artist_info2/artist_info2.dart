import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:melo_trip/model/response/artist/artist.dart';

part 'artist_info2.freezed.dart';
part 'artist_info2.g.dart';

/// Response entity for getArtistInfo2 endpoint.
///
/// Contains similar artists recommendation based on the requested artist.
/// This is the OpenSubsonic extension provided by Navidrome.
@freezed
abstract class ArtistInfo2Entity with _$ArtistInfo2Entity {
  const factory ArtistInfo2Entity({
    /// List of similar artists recommended by Navidrome.
    @JsonKey(name: 'similarArtist') List<ArtistEntity>? similarArtist,
  }) = _ArtistInfo2Entity;

  factory ArtistInfo2Entity.fromJson(Map<String, dynamic> json) =>
      _$ArtistInfo2EntityFromJson(json);
}
