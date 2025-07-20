// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subsonic_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SubsonicResponse _$SubsonicResponseFromJson(Map<String, dynamic> json) =>
    _SubsonicResponse(
      subsonicResponse:
          json['subsonic-response'] == null
              ? null
              : SubsonicResponseClass.fromJson(
                json['subsonic-response'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$SubsonicResponseToJson(_SubsonicResponse instance) =>
    <String, dynamic>{'subsonic-response': instance.subsonicResponse};

_SubsonicResponseClass _$SubsonicResponseClassFromJson(
  Map<String, dynamic> json,
) => _SubsonicResponseClass(
  status: json['status'] as String?,
  version: json['version'] as String?,
  type: json['type'] as String?,
  serverVersion: json['serverVersion'] as String?,
  openSubsonic: json['openSubsonic'] as bool?,
  album:
      json['album'] == null
          ? null
          : AlbumEntity.fromJson(json['album'] as Map<String, dynamic>),
  albumList:
      json['albumList'] == null
          ? null
          : AlbumListEntity.fromJson(json['albumList'] as Map<String, dynamic>),
  searchResult3:
      json['searchResult3'] == null
          ? null
          : SearchResult3Entity.fromJson(
            json['searchResult3'] as Map<String, dynamic>,
          ),
  similarSongs2:
      json['similarSongs2'] == null
          ? null
          : SimilarSongs2Entity.fromJson(
            json['similarSongs2'] as Map<String, dynamic>,
          ),
  randomSongs:
      json['randomSongs'] == null
          ? null
          : RandomSongsEntity.fromJson(
            json['randomSongs'] as Map<String, dynamic>,
          ),
  song:
      json['song'] == null
          ? null
          : SongEntity.fromJson(json['song'] as Map<String, dynamic>),
  playlist:
      json['playlist'] == null
          ? null
          : PlaylistEntity.fromJson(json['playlist'] as Map<String, dynamic>),
  playlists:
      json['playlists'] == null
          ? null
          : PlaylistsEntity.fromJson(json['playlists'] as Map<String, dynamic>),
  playQueue:
      json['playQueue'] == null
          ? null
          : PlayQueueEntity.fromJson(json['playQueue'] as Map<String, dynamic>),
  lyricsList:
      json['lyricsList'] == null
          ? null
          : LyricsListEntity.fromJson(
            json['lyricsList'] as Map<String, dynamic>,
          ),
  scanStatus:
      json['scanStatus'] == null
          ? null
          : ScanStatusEntity.fromJson(
            json['scanStatus'] as Map<String, dynamic>,
          ),
  starred:
      json['starred'] == null
          ? null
          : StarredEntity.fromJson(json['starred'] as Map<String, dynamic>),
  artist:
      json['artist'] == null
          ? null
          : ArtistEntity.fromJson(json['artist'] as Map<String, dynamic>),
  songsByGenre:
      json['songsByGenre'] == null
          ? null
          : SongsByGenreEntity.fromJson(
            json['songsByGenre'] as Map<String, dynamic>,
          ),
  error:
      json['error'] == null
          ? null
          : ErrorEntity.fromJson(json['error'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SubsonicResponseClassToJson(
  _SubsonicResponseClass instance,
) => <String, dynamic>{
  'status': instance.status,
  'version': instance.version,
  'type': instance.type,
  'serverVersion': instance.serverVersion,
  'openSubsonic': instance.openSubsonic,
  'album': instance.album,
  'albumList': instance.albumList,
  'searchResult3': instance.searchResult3,
  'similarSongs2': instance.similarSongs2,
  'randomSongs': instance.randomSongs,
  'song': instance.song,
  'playlist': instance.playlist,
  'playlists': instance.playlists,
  'playQueue': instance.playQueue,
  'lyricsList': instance.lyricsList,
  'scanStatus': instance.scanStatus,
  'starred': instance.starred,
  'artist': instance.artist,
  'songsByGenre': instance.songsByGenre,
  'error': instance.error,
};
