// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subsonic_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubsonicResponse {

@JsonKey(name: "subsonic-response") SubsonicResponseClass? get subsonicResponse;
/// Create a copy of SubsonicResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubsonicResponseCopyWith<SubsonicResponse> get copyWith => _$SubsonicResponseCopyWithImpl<SubsonicResponse>(this as SubsonicResponse, _$identity);

  /// Serializes this SubsonicResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubsonicResponse&&(identical(other.subsonicResponse, subsonicResponse) || other.subsonicResponse == subsonicResponse));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subsonicResponse);

@override
String toString() {
  return 'SubsonicResponse(subsonicResponse: $subsonicResponse)';
}


}

/// @nodoc
abstract mixin class $SubsonicResponseCopyWith<$Res>  {
  factory $SubsonicResponseCopyWith(SubsonicResponse value, $Res Function(SubsonicResponse) _then) = _$SubsonicResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "subsonic-response") SubsonicResponseClass? subsonicResponse
});


$SubsonicResponseClassCopyWith<$Res>? get subsonicResponse;

}
/// @nodoc
class _$SubsonicResponseCopyWithImpl<$Res>
    implements $SubsonicResponseCopyWith<$Res> {
  _$SubsonicResponseCopyWithImpl(this._self, this._then);

  final SubsonicResponse _self;
  final $Res Function(SubsonicResponse) _then;

/// Create a copy of SubsonicResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subsonicResponse = freezed,}) {
  return _then(_self.copyWith(
subsonicResponse: freezed == subsonicResponse ? _self.subsonicResponse : subsonicResponse // ignore: cast_nullable_to_non_nullable
as SubsonicResponseClass?,
  ));
}
/// Create a copy of SubsonicResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubsonicResponseClassCopyWith<$Res>? get subsonicResponse {
    if (_self.subsonicResponse == null) {
    return null;
  }

  return $SubsonicResponseClassCopyWith<$Res>(_self.subsonicResponse!, (value) {
    return _then(_self.copyWith(subsonicResponse: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _SubsonicResponse implements SubsonicResponse {
  const _SubsonicResponse({@JsonKey(name: "subsonic-response") this.subsonicResponse});
  factory _SubsonicResponse.fromJson(Map<String, dynamic> json) => _$SubsonicResponseFromJson(json);

@override@JsonKey(name: "subsonic-response") final  SubsonicResponseClass? subsonicResponse;

/// Create a copy of SubsonicResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubsonicResponseCopyWith<_SubsonicResponse> get copyWith => __$SubsonicResponseCopyWithImpl<_SubsonicResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubsonicResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubsonicResponse&&(identical(other.subsonicResponse, subsonicResponse) || other.subsonicResponse == subsonicResponse));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,subsonicResponse);

@override
String toString() {
  return 'SubsonicResponse(subsonicResponse: $subsonicResponse)';
}


}

/// @nodoc
abstract mixin class _$SubsonicResponseCopyWith<$Res> implements $SubsonicResponseCopyWith<$Res> {
  factory _$SubsonicResponseCopyWith(_SubsonicResponse value, $Res Function(_SubsonicResponse) _then) = __$SubsonicResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "subsonic-response") SubsonicResponseClass? subsonicResponse
});


@override $SubsonicResponseClassCopyWith<$Res>? get subsonicResponse;

}
/// @nodoc
class __$SubsonicResponseCopyWithImpl<$Res>
    implements _$SubsonicResponseCopyWith<$Res> {
  __$SubsonicResponseCopyWithImpl(this._self, this._then);

  final _SubsonicResponse _self;
  final $Res Function(_SubsonicResponse) _then;

/// Create a copy of SubsonicResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subsonicResponse = freezed,}) {
  return _then(_SubsonicResponse(
subsonicResponse: freezed == subsonicResponse ? _self.subsonicResponse : subsonicResponse // ignore: cast_nullable_to_non_nullable
as SubsonicResponseClass?,
  ));
}

/// Create a copy of SubsonicResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubsonicResponseClassCopyWith<$Res>? get subsonicResponse {
    if (_self.subsonicResponse == null) {
    return null;
  }

  return $SubsonicResponseClassCopyWith<$Res>(_self.subsonicResponse!, (value) {
    return _then(_self.copyWith(subsonicResponse: value));
  });
}
}


/// @nodoc
mixin _$SubsonicResponseClass {

 String? get status; String? get version; String? get type; String? get serverVersion; bool? get openSubsonic; AlbumEntity? get album; AlbumListEntity? get albumList; SearchResult3Entity? get searchResult3; RandomSongsEntity? get randomSongs; SongEntity? get song; PlaylistEntity? get playlist; PlaylistsEntity? get playlists; PlayQueueEntity? get playQueue; LyricsListEntity? get lyricsList; ScanStatusEntity? get scanStatus; StarredEntity? get starred; ArtistEntity? get artist; ErrorEntity? get error;
/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubsonicResponseClassCopyWith<SubsonicResponseClass> get copyWith => _$SubsonicResponseClassCopyWithImpl<SubsonicResponseClass>(this as SubsonicResponseClass, _$identity);

  /// Serializes this SubsonicResponseClass to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubsonicResponseClass&&(identical(other.status, status) || other.status == status)&&(identical(other.version, version) || other.version == version)&&(identical(other.type, type) || other.type == type)&&(identical(other.serverVersion, serverVersion) || other.serverVersion == serverVersion)&&(identical(other.openSubsonic, openSubsonic) || other.openSubsonic == openSubsonic)&&(identical(other.album, album) || other.album == album)&&(identical(other.albumList, albumList) || other.albumList == albumList)&&(identical(other.searchResult3, searchResult3) || other.searchResult3 == searchResult3)&&(identical(other.randomSongs, randomSongs) || other.randomSongs == randomSongs)&&(identical(other.song, song) || other.song == song)&&(identical(other.playlist, playlist) || other.playlist == playlist)&&(identical(other.playlists, playlists) || other.playlists == playlists)&&(identical(other.playQueue, playQueue) || other.playQueue == playQueue)&&(identical(other.lyricsList, lyricsList) || other.lyricsList == lyricsList)&&(identical(other.scanStatus, scanStatus) || other.scanStatus == scanStatus)&&(identical(other.starred, starred) || other.starred == starred)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,version,type,serverVersion,openSubsonic,album,albumList,searchResult3,randomSongs,song,playlist,playlists,playQueue,lyricsList,scanStatus,starred,artist,error);

@override
String toString() {
  return 'SubsonicResponseClass(status: $status, version: $version, type: $type, serverVersion: $serverVersion, openSubsonic: $openSubsonic, album: $album, albumList: $albumList, searchResult3: $searchResult3, randomSongs: $randomSongs, song: $song, playlist: $playlist, playlists: $playlists, playQueue: $playQueue, lyricsList: $lyricsList, scanStatus: $scanStatus, starred: $starred, artist: $artist, error: $error)';
}


}

/// @nodoc
abstract mixin class $SubsonicResponseClassCopyWith<$Res>  {
  factory $SubsonicResponseClassCopyWith(SubsonicResponseClass value, $Res Function(SubsonicResponseClass) _then) = _$SubsonicResponseClassCopyWithImpl;
@useResult
$Res call({
 String? status, String? version, String? type, String? serverVersion, bool? openSubsonic, AlbumEntity? album, AlbumListEntity? albumList, SearchResult3Entity? searchResult3, RandomSongsEntity? randomSongs, SongEntity? song, PlaylistEntity? playlist, PlaylistsEntity? playlists, PlayQueueEntity? playQueue, LyricsListEntity? lyricsList, ScanStatusEntity? scanStatus, StarredEntity? starred, ArtistEntity? artist, ErrorEntity? error
});


$AlbumEntityCopyWith<$Res>? get album;$AlbumListEntityCopyWith<$Res>? get albumList;$SearchResult3EntityCopyWith<$Res>? get searchResult3;$RandomSongsEntityCopyWith<$Res>? get randomSongs;$SongEntityCopyWith<$Res>? get song;$PlaylistEntityCopyWith<$Res>? get playlist;$PlaylistsEntityCopyWith<$Res>? get playlists;$PlayQueueEntityCopyWith<$Res>? get playQueue;$LyricsListEntityCopyWith<$Res>? get lyricsList;$ScanStatusEntityCopyWith<$Res>? get scanStatus;$StarredEntityCopyWith<$Res>? get starred;$ArtistEntityCopyWith<$Res>? get artist;$ErrorEntityCopyWith<$Res>? get error;

}
/// @nodoc
class _$SubsonicResponseClassCopyWithImpl<$Res>
    implements $SubsonicResponseClassCopyWith<$Res> {
  _$SubsonicResponseClassCopyWithImpl(this._self, this._then);

  final SubsonicResponseClass _self;
  final $Res Function(SubsonicResponseClass) _then;

/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = freezed,Object? version = freezed,Object? type = freezed,Object? serverVersion = freezed,Object? openSubsonic = freezed,Object? album = freezed,Object? albumList = freezed,Object? searchResult3 = freezed,Object? randomSongs = freezed,Object? song = freezed,Object? playlist = freezed,Object? playlists = freezed,Object? playQueue = freezed,Object? lyricsList = freezed,Object? scanStatus = freezed,Object? starred = freezed,Object? artist = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,serverVersion: freezed == serverVersion ? _self.serverVersion : serverVersion // ignore: cast_nullable_to_non_nullable
as String?,openSubsonic: freezed == openSubsonic ? _self.openSubsonic : openSubsonic // ignore: cast_nullable_to_non_nullable
as bool?,album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as AlbumEntity?,albumList: freezed == albumList ? _self.albumList : albumList // ignore: cast_nullable_to_non_nullable
as AlbumListEntity?,searchResult3: freezed == searchResult3 ? _self.searchResult3 : searchResult3 // ignore: cast_nullable_to_non_nullable
as SearchResult3Entity?,randomSongs: freezed == randomSongs ? _self.randomSongs : randomSongs // ignore: cast_nullable_to_non_nullable
as RandomSongsEntity?,song: freezed == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as SongEntity?,playlist: freezed == playlist ? _self.playlist : playlist // ignore: cast_nullable_to_non_nullable
as PlaylistEntity?,playlists: freezed == playlists ? _self.playlists : playlists // ignore: cast_nullable_to_non_nullable
as PlaylistsEntity?,playQueue: freezed == playQueue ? _self.playQueue : playQueue // ignore: cast_nullable_to_non_nullable
as PlayQueueEntity?,lyricsList: freezed == lyricsList ? _self.lyricsList : lyricsList // ignore: cast_nullable_to_non_nullable
as LyricsListEntity?,scanStatus: freezed == scanStatus ? _self.scanStatus : scanStatus // ignore: cast_nullable_to_non_nullable
as ScanStatusEntity?,starred: freezed == starred ? _self.starred : starred // ignore: cast_nullable_to_non_nullable
as StarredEntity?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as ArtistEntity?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ErrorEntity?,
  ));
}
/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlbumEntityCopyWith<$Res>? get album {
    if (_self.album == null) {
    return null;
  }

  return $AlbumEntityCopyWith<$Res>(_self.album!, (value) {
    return _then(_self.copyWith(album: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlbumListEntityCopyWith<$Res>? get albumList {
    if (_self.albumList == null) {
    return null;
  }

  return $AlbumListEntityCopyWith<$Res>(_self.albumList!, (value) {
    return _then(_self.copyWith(albumList: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchResult3EntityCopyWith<$Res>? get searchResult3 {
    if (_self.searchResult3 == null) {
    return null;
  }

  return $SearchResult3EntityCopyWith<$Res>(_self.searchResult3!, (value) {
    return _then(_self.copyWith(searchResult3: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RandomSongsEntityCopyWith<$Res>? get randomSongs {
    if (_self.randomSongs == null) {
    return null;
  }

  return $RandomSongsEntityCopyWith<$Res>(_self.randomSongs!, (value) {
    return _then(_self.copyWith(randomSongs: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SongEntityCopyWith<$Res>? get song {
    if (_self.song == null) {
    return null;
  }

  return $SongEntityCopyWith<$Res>(_self.song!, (value) {
    return _then(_self.copyWith(song: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaylistEntityCopyWith<$Res>? get playlist {
    if (_self.playlist == null) {
    return null;
  }

  return $PlaylistEntityCopyWith<$Res>(_self.playlist!, (value) {
    return _then(_self.copyWith(playlist: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaylistsEntityCopyWith<$Res>? get playlists {
    if (_self.playlists == null) {
    return null;
  }

  return $PlaylistsEntityCopyWith<$Res>(_self.playlists!, (value) {
    return _then(_self.copyWith(playlists: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayQueueEntityCopyWith<$Res>? get playQueue {
    if (_self.playQueue == null) {
    return null;
  }

  return $PlayQueueEntityCopyWith<$Res>(_self.playQueue!, (value) {
    return _then(_self.copyWith(playQueue: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LyricsListEntityCopyWith<$Res>? get lyricsList {
    if (_self.lyricsList == null) {
    return null;
  }

  return $LyricsListEntityCopyWith<$Res>(_self.lyricsList!, (value) {
    return _then(_self.copyWith(lyricsList: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScanStatusEntityCopyWith<$Res>? get scanStatus {
    if (_self.scanStatus == null) {
    return null;
  }

  return $ScanStatusEntityCopyWith<$Res>(_self.scanStatus!, (value) {
    return _then(_self.copyWith(scanStatus: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StarredEntityCopyWith<$Res>? get starred {
    if (_self.starred == null) {
    return null;
  }

  return $StarredEntityCopyWith<$Res>(_self.starred!, (value) {
    return _then(_self.copyWith(starred: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArtistEntityCopyWith<$Res>? get artist {
    if (_self.artist == null) {
    return null;
  }

  return $ArtistEntityCopyWith<$Res>(_self.artist!, (value) {
    return _then(_self.copyWith(artist: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorEntityCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $ErrorEntityCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _SubsonicResponseClass implements SubsonicResponseClass {
  const _SubsonicResponseClass({this.status, this.version, this.type, this.serverVersion, this.openSubsonic, this.album, this.albumList, this.searchResult3, this.randomSongs, this.song, this.playlist, this.playlists, this.playQueue, this.lyricsList, this.scanStatus, this.starred, this.artist, this.error});
  factory _SubsonicResponseClass.fromJson(Map<String, dynamic> json) => _$SubsonicResponseClassFromJson(json);

@override final  String? status;
@override final  String? version;
@override final  String? type;
@override final  String? serverVersion;
@override final  bool? openSubsonic;
@override final  AlbumEntity? album;
@override final  AlbumListEntity? albumList;
@override final  SearchResult3Entity? searchResult3;
@override final  RandomSongsEntity? randomSongs;
@override final  SongEntity? song;
@override final  PlaylistEntity? playlist;
@override final  PlaylistsEntity? playlists;
@override final  PlayQueueEntity? playQueue;
@override final  LyricsListEntity? lyricsList;
@override final  ScanStatusEntity? scanStatus;
@override final  StarredEntity? starred;
@override final  ArtistEntity? artist;
@override final  ErrorEntity? error;

/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubsonicResponseClassCopyWith<_SubsonicResponseClass> get copyWith => __$SubsonicResponseClassCopyWithImpl<_SubsonicResponseClass>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubsonicResponseClassToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubsonicResponseClass&&(identical(other.status, status) || other.status == status)&&(identical(other.version, version) || other.version == version)&&(identical(other.type, type) || other.type == type)&&(identical(other.serverVersion, serverVersion) || other.serverVersion == serverVersion)&&(identical(other.openSubsonic, openSubsonic) || other.openSubsonic == openSubsonic)&&(identical(other.album, album) || other.album == album)&&(identical(other.albumList, albumList) || other.albumList == albumList)&&(identical(other.searchResult3, searchResult3) || other.searchResult3 == searchResult3)&&(identical(other.randomSongs, randomSongs) || other.randomSongs == randomSongs)&&(identical(other.song, song) || other.song == song)&&(identical(other.playlist, playlist) || other.playlist == playlist)&&(identical(other.playlists, playlists) || other.playlists == playlists)&&(identical(other.playQueue, playQueue) || other.playQueue == playQueue)&&(identical(other.lyricsList, lyricsList) || other.lyricsList == lyricsList)&&(identical(other.scanStatus, scanStatus) || other.scanStatus == scanStatus)&&(identical(other.starred, starred) || other.starred == starred)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,version,type,serverVersion,openSubsonic,album,albumList,searchResult3,randomSongs,song,playlist,playlists,playQueue,lyricsList,scanStatus,starred,artist,error);

@override
String toString() {
  return 'SubsonicResponseClass(status: $status, version: $version, type: $type, serverVersion: $serverVersion, openSubsonic: $openSubsonic, album: $album, albumList: $albumList, searchResult3: $searchResult3, randomSongs: $randomSongs, song: $song, playlist: $playlist, playlists: $playlists, playQueue: $playQueue, lyricsList: $lyricsList, scanStatus: $scanStatus, starred: $starred, artist: $artist, error: $error)';
}


}

/// @nodoc
abstract mixin class _$SubsonicResponseClassCopyWith<$Res> implements $SubsonicResponseClassCopyWith<$Res> {
  factory _$SubsonicResponseClassCopyWith(_SubsonicResponseClass value, $Res Function(_SubsonicResponseClass) _then) = __$SubsonicResponseClassCopyWithImpl;
@override @useResult
$Res call({
 String? status, String? version, String? type, String? serverVersion, bool? openSubsonic, AlbumEntity? album, AlbumListEntity? albumList, SearchResult3Entity? searchResult3, RandomSongsEntity? randomSongs, SongEntity? song, PlaylistEntity? playlist, PlaylistsEntity? playlists, PlayQueueEntity? playQueue, LyricsListEntity? lyricsList, ScanStatusEntity? scanStatus, StarredEntity? starred, ArtistEntity? artist, ErrorEntity? error
});


@override $AlbumEntityCopyWith<$Res>? get album;@override $AlbumListEntityCopyWith<$Res>? get albumList;@override $SearchResult3EntityCopyWith<$Res>? get searchResult3;@override $RandomSongsEntityCopyWith<$Res>? get randomSongs;@override $SongEntityCopyWith<$Res>? get song;@override $PlaylistEntityCopyWith<$Res>? get playlist;@override $PlaylistsEntityCopyWith<$Res>? get playlists;@override $PlayQueueEntityCopyWith<$Res>? get playQueue;@override $LyricsListEntityCopyWith<$Res>? get lyricsList;@override $ScanStatusEntityCopyWith<$Res>? get scanStatus;@override $StarredEntityCopyWith<$Res>? get starred;@override $ArtistEntityCopyWith<$Res>? get artist;@override $ErrorEntityCopyWith<$Res>? get error;

}
/// @nodoc
class __$SubsonicResponseClassCopyWithImpl<$Res>
    implements _$SubsonicResponseClassCopyWith<$Res> {
  __$SubsonicResponseClassCopyWithImpl(this._self, this._then);

  final _SubsonicResponseClass _self;
  final $Res Function(_SubsonicResponseClass) _then;

/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = freezed,Object? version = freezed,Object? type = freezed,Object? serverVersion = freezed,Object? openSubsonic = freezed,Object? album = freezed,Object? albumList = freezed,Object? searchResult3 = freezed,Object? randomSongs = freezed,Object? song = freezed,Object? playlist = freezed,Object? playlists = freezed,Object? playQueue = freezed,Object? lyricsList = freezed,Object? scanStatus = freezed,Object? starred = freezed,Object? artist = freezed,Object? error = freezed,}) {
  return _then(_SubsonicResponseClass(
status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,serverVersion: freezed == serverVersion ? _self.serverVersion : serverVersion // ignore: cast_nullable_to_non_nullable
as String?,openSubsonic: freezed == openSubsonic ? _self.openSubsonic : openSubsonic // ignore: cast_nullable_to_non_nullable
as bool?,album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as AlbumEntity?,albumList: freezed == albumList ? _self.albumList : albumList // ignore: cast_nullable_to_non_nullable
as AlbumListEntity?,searchResult3: freezed == searchResult3 ? _self.searchResult3 : searchResult3 // ignore: cast_nullable_to_non_nullable
as SearchResult3Entity?,randomSongs: freezed == randomSongs ? _self.randomSongs : randomSongs // ignore: cast_nullable_to_non_nullable
as RandomSongsEntity?,song: freezed == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as SongEntity?,playlist: freezed == playlist ? _self.playlist : playlist // ignore: cast_nullable_to_non_nullable
as PlaylistEntity?,playlists: freezed == playlists ? _self.playlists : playlists // ignore: cast_nullable_to_non_nullable
as PlaylistsEntity?,playQueue: freezed == playQueue ? _self.playQueue : playQueue // ignore: cast_nullable_to_non_nullable
as PlayQueueEntity?,lyricsList: freezed == lyricsList ? _self.lyricsList : lyricsList // ignore: cast_nullable_to_non_nullable
as LyricsListEntity?,scanStatus: freezed == scanStatus ? _self.scanStatus : scanStatus // ignore: cast_nullable_to_non_nullable
as ScanStatusEntity?,starred: freezed == starred ? _self.starred : starred // ignore: cast_nullable_to_non_nullable
as StarredEntity?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as ArtistEntity?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as ErrorEntity?,
  ));
}

/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlbumEntityCopyWith<$Res>? get album {
    if (_self.album == null) {
    return null;
  }

  return $AlbumEntityCopyWith<$Res>(_self.album!, (value) {
    return _then(_self.copyWith(album: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AlbumListEntityCopyWith<$Res>? get albumList {
    if (_self.albumList == null) {
    return null;
  }

  return $AlbumListEntityCopyWith<$Res>(_self.albumList!, (value) {
    return _then(_self.copyWith(albumList: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SearchResult3EntityCopyWith<$Res>? get searchResult3 {
    if (_self.searchResult3 == null) {
    return null;
  }

  return $SearchResult3EntityCopyWith<$Res>(_self.searchResult3!, (value) {
    return _then(_self.copyWith(searchResult3: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RandomSongsEntityCopyWith<$Res>? get randomSongs {
    if (_self.randomSongs == null) {
    return null;
  }

  return $RandomSongsEntityCopyWith<$Res>(_self.randomSongs!, (value) {
    return _then(_self.copyWith(randomSongs: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SongEntityCopyWith<$Res>? get song {
    if (_self.song == null) {
    return null;
  }

  return $SongEntityCopyWith<$Res>(_self.song!, (value) {
    return _then(_self.copyWith(song: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaylistEntityCopyWith<$Res>? get playlist {
    if (_self.playlist == null) {
    return null;
  }

  return $PlaylistEntityCopyWith<$Res>(_self.playlist!, (value) {
    return _then(_self.copyWith(playlist: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlaylistsEntityCopyWith<$Res>? get playlists {
    if (_self.playlists == null) {
    return null;
  }

  return $PlaylistsEntityCopyWith<$Res>(_self.playlists!, (value) {
    return _then(_self.copyWith(playlists: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayQueueEntityCopyWith<$Res>? get playQueue {
    if (_self.playQueue == null) {
    return null;
  }

  return $PlayQueueEntityCopyWith<$Res>(_self.playQueue!, (value) {
    return _then(_self.copyWith(playQueue: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LyricsListEntityCopyWith<$Res>? get lyricsList {
    if (_self.lyricsList == null) {
    return null;
  }

  return $LyricsListEntityCopyWith<$Res>(_self.lyricsList!, (value) {
    return _then(_self.copyWith(lyricsList: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScanStatusEntityCopyWith<$Res>? get scanStatus {
    if (_self.scanStatus == null) {
    return null;
  }

  return $ScanStatusEntityCopyWith<$Res>(_self.scanStatus!, (value) {
    return _then(_self.copyWith(scanStatus: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StarredEntityCopyWith<$Res>? get starred {
    if (_self.starred == null) {
    return null;
  }

  return $StarredEntityCopyWith<$Res>(_self.starred!, (value) {
    return _then(_self.copyWith(starred: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArtistEntityCopyWith<$Res>? get artist {
    if (_self.artist == null) {
    return null;
  }

  return $ArtistEntityCopyWith<$Res>(_self.artist!, (value) {
    return _then(_self.copyWith(artist: value));
  });
}/// Create a copy of SubsonicResponseClass
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ErrorEntityCopyWith<$Res>? get error {
    if (_self.error == null) {
    return null;
  }

  return $ErrorEntityCopyWith<$Res>(_self.error!, (value) {
    return _then(_self.copyWith(error: value));
  });
}
}

// dart format on
