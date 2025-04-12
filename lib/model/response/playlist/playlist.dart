import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:melo_trip/model/response/song/song.dart';

part 'playlist.freezed.dart';
part 'playlist.g.dart';

@freezed
abstract class PlaylistEntity with _$PlaylistEntity {
  const factory PlaylistEntity({
    String? id,
    String? name,
    String? comment,
    int? songCount,
    int? duration,
    bool? public,
    String? owner,
    DateTime? created,
    DateTime? changed,
    String? coverArt,
    List<SongEntity>? entry,
  }) = _PlaylistEntity;

  factory PlaylistEntity.fromJson(Map<String, dynamic> json) =>
      _$PlaylistEntityFromJson(json);
}

@freezed
abstract class PlaylistsEntity with _$PlaylistsEntity {
  const factory PlaylistsEntity({List<PlaylistEntity>? playlist}) =
      _PlaylistsEntity;

  factory PlaylistsEntity.fromJson(Map<String, dynamic> json) =>
      _$PlaylistsEntityFromJson(json);
}
