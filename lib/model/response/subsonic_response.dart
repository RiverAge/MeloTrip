import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/error/error.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/model/response/play_queue/play_queue.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/random_song/random_song.dart';

import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/scan_status/scan_status.dart';
import 'package:melo_trip/model/response/search_result/search_result3.dart';
import 'package:melo_trip/model/response/similar_songs/similar_songs2.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/songs_by_genre/songs_by_gener.dart';
import 'package:melo_trip/model/response/starred/starred.dart';

part 'subsonic_response.freezed.dart';
part 'subsonic_response.g.dart';

@freezed
abstract class SubsonicResponse with _$SubsonicResponse {
  const factory SubsonicResponse({
    @JsonKey(name: "subsonic-response") SubsonicResponseClass? subsonicResponse,
  }) = _SubsonicResponse;

  factory SubsonicResponse.fromJson(Map<String, dynamic> json) =>
      _$SubsonicResponseFromJson(json);
}

@freezed
abstract class SubsonicResponseClass with _$SubsonicResponseClass {
  const factory SubsonicResponseClass({
    String? status,
    String? version,
    String? type,
    String? serverVersion,
    bool? openSubsonic,
    AlbumEntity? album,
    AlbumListEntity? albumList,
    SearchResult3Entity? searchResult3,
    SimilarSongs2Entity? similarSongs2,
    RandomSongsEntity? randomSongs,
    SongEntity? song,
    PlaylistEntity? playlist,
    PlaylistsEntity? playlists,
    PlayQueueEntity? playQueue,
    LyricsListEntity? lyricsList,
    ScanStatusEntity? scanStatus,
    StarredEntity? starred,
    ArtistEntity? artist,
    SongsByGenreEntity? songsByGenre,
    ErrorEntity? error,
  }) = _SubsonicResponseClass;

  factory SubsonicResponseClass.fromJson(Map<String, dynamic> json) =>
      _$SubsonicResponseClassFromJson(json);
}
