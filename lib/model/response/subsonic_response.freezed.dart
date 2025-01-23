// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subsonic_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SubsonicResponse _$SubsonicResponseFromJson(Map<String, dynamic> json) {
  return _SubsonicResponse.fromJson(json);
}

/// @nodoc
mixin _$SubsonicResponse {
  @JsonKey(name: "subsonic-response")
  SubsonicResponseClass? get subsonicResponse =>
      throw _privateConstructorUsedError;

  /// Serializes this SubsonicResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubsonicResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubsonicResponseCopyWith<SubsonicResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubsonicResponseCopyWith<$Res> {
  factory $SubsonicResponseCopyWith(
          SubsonicResponse value, $Res Function(SubsonicResponse) then) =
      _$SubsonicResponseCopyWithImpl<$Res, SubsonicResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: "subsonic-response")
      SubsonicResponseClass? subsonicResponse});

  $SubsonicResponseClassCopyWith<$Res>? get subsonicResponse;
}

/// @nodoc
class _$SubsonicResponseCopyWithImpl<$Res, $Val extends SubsonicResponse>
    implements $SubsonicResponseCopyWith<$Res> {
  _$SubsonicResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubsonicResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subsonicResponse = freezed,
  }) {
    return _then(_value.copyWith(
      subsonicResponse: freezed == subsonicResponse
          ? _value.subsonicResponse
          : subsonicResponse // ignore: cast_nullable_to_non_nullable
              as SubsonicResponseClass?,
    ) as $Val);
  }

  /// Create a copy of SubsonicResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubsonicResponseClassCopyWith<$Res>? get subsonicResponse {
    if (_value.subsonicResponse == null) {
      return null;
    }

    return $SubsonicResponseClassCopyWith<$Res>(_value.subsonicResponse!,
        (value) {
      return _then(_value.copyWith(subsonicResponse: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SubsonicResponseImplCopyWith<$Res>
    implements $SubsonicResponseCopyWith<$Res> {
  factory _$$SubsonicResponseImplCopyWith(_$SubsonicResponseImpl value,
          $Res Function(_$SubsonicResponseImpl) then) =
      __$$SubsonicResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: "subsonic-response")
      SubsonicResponseClass? subsonicResponse});

  @override
  $SubsonicResponseClassCopyWith<$Res>? get subsonicResponse;
}

/// @nodoc
class __$$SubsonicResponseImplCopyWithImpl<$Res>
    extends _$SubsonicResponseCopyWithImpl<$Res, _$SubsonicResponseImpl>
    implements _$$SubsonicResponseImplCopyWith<$Res> {
  __$$SubsonicResponseImplCopyWithImpl(_$SubsonicResponseImpl _value,
      $Res Function(_$SubsonicResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubsonicResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? subsonicResponse = freezed,
  }) {
    return _then(_$SubsonicResponseImpl(
      subsonicResponse: freezed == subsonicResponse
          ? _value.subsonicResponse
          : subsonicResponse // ignore: cast_nullable_to_non_nullable
              as SubsonicResponseClass?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubsonicResponseImpl implements _SubsonicResponse {
  const _$SubsonicResponseImpl(
      {@JsonKey(name: "subsonic-response") this.subsonicResponse});

  factory _$SubsonicResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubsonicResponseImplFromJson(json);

  @override
  @JsonKey(name: "subsonic-response")
  final SubsonicResponseClass? subsonicResponse;

  @override
  String toString() {
    return 'SubsonicResponse(subsonicResponse: $subsonicResponse)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubsonicResponseImpl &&
            (identical(other.subsonicResponse, subsonicResponse) ||
                other.subsonicResponse == subsonicResponse));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, subsonicResponse);

  /// Create a copy of SubsonicResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubsonicResponseImplCopyWith<_$SubsonicResponseImpl> get copyWith =>
      __$$SubsonicResponseImplCopyWithImpl<_$SubsonicResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubsonicResponseImplToJson(
      this,
    );
  }
}

abstract class _SubsonicResponse implements SubsonicResponse {
  const factory _SubsonicResponse(
      {@JsonKey(name: "subsonic-response")
      final SubsonicResponseClass? subsonicResponse}) = _$SubsonicResponseImpl;

  factory _SubsonicResponse.fromJson(Map<String, dynamic> json) =
      _$SubsonicResponseImpl.fromJson;

  @override
  @JsonKey(name: "subsonic-response")
  SubsonicResponseClass? get subsonicResponse;

  /// Create a copy of SubsonicResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubsonicResponseImplCopyWith<_$SubsonicResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SubsonicResponseClass _$SubsonicResponseClassFromJson(
    Map<String, dynamic> json) {
  return _SubsonicResponseClass.fromJson(json);
}

/// @nodoc
mixin _$SubsonicResponseClass {
  String? get status => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  String? get type => throw _privateConstructorUsedError;
  String? get serverVersion => throw _privateConstructorUsedError;
  bool? get openSubsonic => throw _privateConstructorUsedError;
  AlbumEntity? get album => throw _privateConstructorUsedError;
  AlbumListEntity? get albumList => throw _privateConstructorUsedError;
  SearchResult3Entity? get searchResult3 => throw _privateConstructorUsedError;
  RandomSongsEntity? get randomSongs => throw _privateConstructorUsedError;
  SongEntity? get song => throw _privateConstructorUsedError;
  PlaylistEntity? get playlist => throw _privateConstructorUsedError;
  PlaylistsEntity? get playlists => throw _privateConstructorUsedError;
  PlayQueueEntity? get playQueue => throw _privateConstructorUsedError;
  LyricsListEntity? get lyricsList => throw _privateConstructorUsedError;
  ScanStatusEntity? get scanStatus => throw _privateConstructorUsedError;
  StarredEntity? get starred => throw _privateConstructorUsedError;
  ArtistEntity? get artist => throw _privateConstructorUsedError;
  ErrorEntity? get error => throw _privateConstructorUsedError;

  /// Serializes this SubsonicResponseClass to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SubsonicResponseClassCopyWith<SubsonicResponseClass> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SubsonicResponseClassCopyWith<$Res> {
  factory $SubsonicResponseClassCopyWith(SubsonicResponseClass value,
          $Res Function(SubsonicResponseClass) then) =
      _$SubsonicResponseClassCopyWithImpl<$Res, SubsonicResponseClass>;
  @useResult
  $Res call(
      {String? status,
      String? version,
      String? type,
      String? serverVersion,
      bool? openSubsonic,
      AlbumEntity? album,
      AlbumListEntity? albumList,
      SearchResult3Entity? searchResult3,
      RandomSongsEntity? randomSongs,
      SongEntity? song,
      PlaylistEntity? playlist,
      PlaylistsEntity? playlists,
      PlayQueueEntity? playQueue,
      LyricsListEntity? lyricsList,
      ScanStatusEntity? scanStatus,
      StarredEntity? starred,
      ArtistEntity? artist,
      ErrorEntity? error});

  $AlbumEntityCopyWith<$Res>? get album;
  $AlbumListEntityCopyWith<$Res>? get albumList;
  $SearchResult3EntityCopyWith<$Res>? get searchResult3;
  $RandomSongsEntityCopyWith<$Res>? get randomSongs;
  $SongEntityCopyWith<$Res>? get song;
  $PlaylistEntityCopyWith<$Res>? get playlist;
  $PlaylistsEntityCopyWith<$Res>? get playlists;
  $PlayQueueEntityCopyWith<$Res>? get playQueue;
  $LyricsListEntityCopyWith<$Res>? get lyricsList;
  $ScanStatusEntityCopyWith<$Res>? get scanStatus;
  $StarredEntityCopyWith<$Res>? get starred;
  $ArtistEntityCopyWith<$Res>? get artist;
  $ErrorEntityCopyWith<$Res>? get error;
}

/// @nodoc
class _$SubsonicResponseClassCopyWithImpl<$Res,
        $Val extends SubsonicResponseClass>
    implements $SubsonicResponseClassCopyWith<$Res> {
  _$SubsonicResponseClassCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? version = freezed,
    Object? type = freezed,
    Object? serverVersion = freezed,
    Object? openSubsonic = freezed,
    Object? album = freezed,
    Object? albumList = freezed,
    Object? searchResult3 = freezed,
    Object? randomSongs = freezed,
    Object? song = freezed,
    Object? playlist = freezed,
    Object? playlists = freezed,
    Object? playQueue = freezed,
    Object? lyricsList = freezed,
    Object? scanStatus = freezed,
    Object? starred = freezed,
    Object? artist = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      serverVersion: freezed == serverVersion
          ? _value.serverVersion
          : serverVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      openSubsonic: freezed == openSubsonic
          ? _value.openSubsonic
          : openSubsonic // ignore: cast_nullable_to_non_nullable
              as bool?,
      album: freezed == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as AlbumEntity?,
      albumList: freezed == albumList
          ? _value.albumList
          : albumList // ignore: cast_nullable_to_non_nullable
              as AlbumListEntity?,
      searchResult3: freezed == searchResult3
          ? _value.searchResult3
          : searchResult3 // ignore: cast_nullable_to_non_nullable
              as SearchResult3Entity?,
      randomSongs: freezed == randomSongs
          ? _value.randomSongs
          : randomSongs // ignore: cast_nullable_to_non_nullable
              as RandomSongsEntity?,
      song: freezed == song
          ? _value.song
          : song // ignore: cast_nullable_to_non_nullable
              as SongEntity?,
      playlist: freezed == playlist
          ? _value.playlist
          : playlist // ignore: cast_nullable_to_non_nullable
              as PlaylistEntity?,
      playlists: freezed == playlists
          ? _value.playlists
          : playlists // ignore: cast_nullable_to_non_nullable
              as PlaylistsEntity?,
      playQueue: freezed == playQueue
          ? _value.playQueue
          : playQueue // ignore: cast_nullable_to_non_nullable
              as PlayQueueEntity?,
      lyricsList: freezed == lyricsList
          ? _value.lyricsList
          : lyricsList // ignore: cast_nullable_to_non_nullable
              as LyricsListEntity?,
      scanStatus: freezed == scanStatus
          ? _value.scanStatus
          : scanStatus // ignore: cast_nullable_to_non_nullable
              as ScanStatusEntity?,
      starred: freezed == starred
          ? _value.starred
          : starred // ignore: cast_nullable_to_non_nullable
              as StarredEntity?,
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as ArtistEntity?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as ErrorEntity?,
    ) as $Val);
  }

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AlbumEntityCopyWith<$Res>? get album {
    if (_value.album == null) {
      return null;
    }

    return $AlbumEntityCopyWith<$Res>(_value.album!, (value) {
      return _then(_value.copyWith(album: value) as $Val);
    });
  }

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AlbumListEntityCopyWith<$Res>? get albumList {
    if (_value.albumList == null) {
      return null;
    }

    return $AlbumListEntityCopyWith<$Res>(_value.albumList!, (value) {
      return _then(_value.copyWith(albumList: value) as $Val);
    });
  }

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SearchResult3EntityCopyWith<$Res>? get searchResult3 {
    if (_value.searchResult3 == null) {
      return null;
    }

    return $SearchResult3EntityCopyWith<$Res>(_value.searchResult3!, (value) {
      return _then(_value.copyWith(searchResult3: value) as $Val);
    });
  }

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RandomSongsEntityCopyWith<$Res>? get randomSongs {
    if (_value.randomSongs == null) {
      return null;
    }

    return $RandomSongsEntityCopyWith<$Res>(_value.randomSongs!, (value) {
      return _then(_value.copyWith(randomSongs: value) as $Val);
    });
  }

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SongEntityCopyWith<$Res>? get song {
    if (_value.song == null) {
      return null;
    }

    return $SongEntityCopyWith<$Res>(_value.song!, (value) {
      return _then(_value.copyWith(song: value) as $Val);
    });
  }

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlaylistEntityCopyWith<$Res>? get playlist {
    if (_value.playlist == null) {
      return null;
    }

    return $PlaylistEntityCopyWith<$Res>(_value.playlist!, (value) {
      return _then(_value.copyWith(playlist: value) as $Val);
    });
  }

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlaylistsEntityCopyWith<$Res>? get playlists {
    if (_value.playlists == null) {
      return null;
    }

    return $PlaylistsEntityCopyWith<$Res>(_value.playlists!, (value) {
      return _then(_value.copyWith(playlists: value) as $Val);
    });
  }

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PlayQueueEntityCopyWith<$Res>? get playQueue {
    if (_value.playQueue == null) {
      return null;
    }

    return $PlayQueueEntityCopyWith<$Res>(_value.playQueue!, (value) {
      return _then(_value.copyWith(playQueue: value) as $Val);
    });
  }

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LyricsListEntityCopyWith<$Res>? get lyricsList {
    if (_value.lyricsList == null) {
      return null;
    }

    return $LyricsListEntityCopyWith<$Res>(_value.lyricsList!, (value) {
      return _then(_value.copyWith(lyricsList: value) as $Val);
    });
  }

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScanStatusEntityCopyWith<$Res>? get scanStatus {
    if (_value.scanStatus == null) {
      return null;
    }

    return $ScanStatusEntityCopyWith<$Res>(_value.scanStatus!, (value) {
      return _then(_value.copyWith(scanStatus: value) as $Val);
    });
  }

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StarredEntityCopyWith<$Res>? get starred {
    if (_value.starred == null) {
      return null;
    }

    return $StarredEntityCopyWith<$Res>(_value.starred!, (value) {
      return _then(_value.copyWith(starred: value) as $Val);
    });
  }

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ArtistEntityCopyWith<$Res>? get artist {
    if (_value.artist == null) {
      return null;
    }

    return $ArtistEntityCopyWith<$Res>(_value.artist!, (value) {
      return _then(_value.copyWith(artist: value) as $Val);
    });
  }

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ErrorEntityCopyWith<$Res>? get error {
    if (_value.error == null) {
      return null;
    }

    return $ErrorEntityCopyWith<$Res>(_value.error!, (value) {
      return _then(_value.copyWith(error: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SubsonicResponseClassImplCopyWith<$Res>
    implements $SubsonicResponseClassCopyWith<$Res> {
  factory _$$SubsonicResponseClassImplCopyWith(
          _$SubsonicResponseClassImpl value,
          $Res Function(_$SubsonicResponseClassImpl) then) =
      __$$SubsonicResponseClassImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? status,
      String? version,
      String? type,
      String? serverVersion,
      bool? openSubsonic,
      AlbumEntity? album,
      AlbumListEntity? albumList,
      SearchResult3Entity? searchResult3,
      RandomSongsEntity? randomSongs,
      SongEntity? song,
      PlaylistEntity? playlist,
      PlaylistsEntity? playlists,
      PlayQueueEntity? playQueue,
      LyricsListEntity? lyricsList,
      ScanStatusEntity? scanStatus,
      StarredEntity? starred,
      ArtistEntity? artist,
      ErrorEntity? error});

  @override
  $AlbumEntityCopyWith<$Res>? get album;
  @override
  $AlbumListEntityCopyWith<$Res>? get albumList;
  @override
  $SearchResult3EntityCopyWith<$Res>? get searchResult3;
  @override
  $RandomSongsEntityCopyWith<$Res>? get randomSongs;
  @override
  $SongEntityCopyWith<$Res>? get song;
  @override
  $PlaylistEntityCopyWith<$Res>? get playlist;
  @override
  $PlaylistsEntityCopyWith<$Res>? get playlists;
  @override
  $PlayQueueEntityCopyWith<$Res>? get playQueue;
  @override
  $LyricsListEntityCopyWith<$Res>? get lyricsList;
  @override
  $ScanStatusEntityCopyWith<$Res>? get scanStatus;
  @override
  $StarredEntityCopyWith<$Res>? get starred;
  @override
  $ArtistEntityCopyWith<$Res>? get artist;
  @override
  $ErrorEntityCopyWith<$Res>? get error;
}

/// @nodoc
class __$$SubsonicResponseClassImplCopyWithImpl<$Res>
    extends _$SubsonicResponseClassCopyWithImpl<$Res,
        _$SubsonicResponseClassImpl>
    implements _$$SubsonicResponseClassImplCopyWith<$Res> {
  __$$SubsonicResponseClassImplCopyWithImpl(_$SubsonicResponseClassImpl _value,
      $Res Function(_$SubsonicResponseClassImpl) _then)
      : super(_value, _then);

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? version = freezed,
    Object? type = freezed,
    Object? serverVersion = freezed,
    Object? openSubsonic = freezed,
    Object? album = freezed,
    Object? albumList = freezed,
    Object? searchResult3 = freezed,
    Object? randomSongs = freezed,
    Object? song = freezed,
    Object? playlist = freezed,
    Object? playlists = freezed,
    Object? playQueue = freezed,
    Object? lyricsList = freezed,
    Object? scanStatus = freezed,
    Object? starred = freezed,
    Object? artist = freezed,
    Object? error = freezed,
  }) {
    return _then(_$SubsonicResponseClassImpl(
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String?,
      serverVersion: freezed == serverVersion
          ? _value.serverVersion
          : serverVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      openSubsonic: freezed == openSubsonic
          ? _value.openSubsonic
          : openSubsonic // ignore: cast_nullable_to_non_nullable
              as bool?,
      album: freezed == album
          ? _value.album
          : album // ignore: cast_nullable_to_non_nullable
              as AlbumEntity?,
      albumList: freezed == albumList
          ? _value.albumList
          : albumList // ignore: cast_nullable_to_non_nullable
              as AlbumListEntity?,
      searchResult3: freezed == searchResult3
          ? _value.searchResult3
          : searchResult3 // ignore: cast_nullable_to_non_nullable
              as SearchResult3Entity?,
      randomSongs: freezed == randomSongs
          ? _value.randomSongs
          : randomSongs // ignore: cast_nullable_to_non_nullable
              as RandomSongsEntity?,
      song: freezed == song
          ? _value.song
          : song // ignore: cast_nullable_to_non_nullable
              as SongEntity?,
      playlist: freezed == playlist
          ? _value.playlist
          : playlist // ignore: cast_nullable_to_non_nullable
              as PlaylistEntity?,
      playlists: freezed == playlists
          ? _value.playlists
          : playlists // ignore: cast_nullable_to_non_nullable
              as PlaylistsEntity?,
      playQueue: freezed == playQueue
          ? _value.playQueue
          : playQueue // ignore: cast_nullable_to_non_nullable
              as PlayQueueEntity?,
      lyricsList: freezed == lyricsList
          ? _value.lyricsList
          : lyricsList // ignore: cast_nullable_to_non_nullable
              as LyricsListEntity?,
      scanStatus: freezed == scanStatus
          ? _value.scanStatus
          : scanStatus // ignore: cast_nullable_to_non_nullable
              as ScanStatusEntity?,
      starred: freezed == starred
          ? _value.starred
          : starred // ignore: cast_nullable_to_non_nullable
              as StarredEntity?,
      artist: freezed == artist
          ? _value.artist
          : artist // ignore: cast_nullable_to_non_nullable
              as ArtistEntity?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as ErrorEntity?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SubsonicResponseClassImpl implements _SubsonicResponseClass {
  const _$SubsonicResponseClassImpl(
      {this.status,
      this.version,
      this.type,
      this.serverVersion,
      this.openSubsonic,
      this.album,
      this.albumList,
      this.searchResult3,
      this.randomSongs,
      this.song,
      this.playlist,
      this.playlists,
      this.playQueue,
      this.lyricsList,
      this.scanStatus,
      this.starred,
      this.artist,
      this.error});

  factory _$SubsonicResponseClassImpl.fromJson(Map<String, dynamic> json) =>
      _$$SubsonicResponseClassImplFromJson(json);

  @override
  final String? status;
  @override
  final String? version;
  @override
  final String? type;
  @override
  final String? serverVersion;
  @override
  final bool? openSubsonic;
  @override
  final AlbumEntity? album;
  @override
  final AlbumListEntity? albumList;
  @override
  final SearchResult3Entity? searchResult3;
  @override
  final RandomSongsEntity? randomSongs;
  @override
  final SongEntity? song;
  @override
  final PlaylistEntity? playlist;
  @override
  final PlaylistsEntity? playlists;
  @override
  final PlayQueueEntity? playQueue;
  @override
  final LyricsListEntity? lyricsList;
  @override
  final ScanStatusEntity? scanStatus;
  @override
  final StarredEntity? starred;
  @override
  final ArtistEntity? artist;
  @override
  final ErrorEntity? error;

  @override
  String toString() {
    return 'SubsonicResponseClass(status: $status, version: $version, type: $type, serverVersion: $serverVersion, openSubsonic: $openSubsonic, album: $album, albumList: $albumList, searchResult3: $searchResult3, randomSongs: $randomSongs, song: $song, playlist: $playlist, playlists: $playlists, playQueue: $playQueue, lyricsList: $lyricsList, scanStatus: $scanStatus, starred: $starred, artist: $artist, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SubsonicResponseClassImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.serverVersion, serverVersion) ||
                other.serverVersion == serverVersion) &&
            (identical(other.openSubsonic, openSubsonic) ||
                other.openSubsonic == openSubsonic) &&
            (identical(other.album, album) || other.album == album) &&
            (identical(other.albumList, albumList) ||
                other.albumList == albumList) &&
            (identical(other.searchResult3, searchResult3) ||
                other.searchResult3 == searchResult3) &&
            (identical(other.randomSongs, randomSongs) ||
                other.randomSongs == randomSongs) &&
            (identical(other.song, song) || other.song == song) &&
            (identical(other.playlist, playlist) ||
                other.playlist == playlist) &&
            (identical(other.playlists, playlists) ||
                other.playlists == playlists) &&
            (identical(other.playQueue, playQueue) ||
                other.playQueue == playQueue) &&
            (identical(other.lyricsList, lyricsList) ||
                other.lyricsList == lyricsList) &&
            (identical(other.scanStatus, scanStatus) ||
                other.scanStatus == scanStatus) &&
            (identical(other.starred, starred) || other.starred == starred) &&
            (identical(other.artist, artist) || other.artist == artist) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      status,
      version,
      type,
      serverVersion,
      openSubsonic,
      album,
      albumList,
      searchResult3,
      randomSongs,
      song,
      playlist,
      playlists,
      playQueue,
      lyricsList,
      scanStatus,
      starred,
      artist,
      error);

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SubsonicResponseClassImplCopyWith<_$SubsonicResponseClassImpl>
      get copyWith => __$$SubsonicResponseClassImplCopyWithImpl<
          _$SubsonicResponseClassImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SubsonicResponseClassImplToJson(
      this,
    );
  }
}

abstract class _SubsonicResponseClass implements SubsonicResponseClass {
  const factory _SubsonicResponseClass(
      {final String? status,
      final String? version,
      final String? type,
      final String? serverVersion,
      final bool? openSubsonic,
      final AlbumEntity? album,
      final AlbumListEntity? albumList,
      final SearchResult3Entity? searchResult3,
      final RandomSongsEntity? randomSongs,
      final SongEntity? song,
      final PlaylistEntity? playlist,
      final PlaylistsEntity? playlists,
      final PlayQueueEntity? playQueue,
      final LyricsListEntity? lyricsList,
      final ScanStatusEntity? scanStatus,
      final StarredEntity? starred,
      final ArtistEntity? artist,
      final ErrorEntity? error}) = _$SubsonicResponseClassImpl;

  factory _SubsonicResponseClass.fromJson(Map<String, dynamic> json) =
      _$SubsonicResponseClassImpl.fromJson;

  @override
  String? get status;
  @override
  String? get version;
  @override
  String? get type;
  @override
  String? get serverVersion;
  @override
  bool? get openSubsonic;
  @override
  AlbumEntity? get album;
  @override
  AlbumListEntity? get albumList;
  @override
  SearchResult3Entity? get searchResult3;
  @override
  RandomSongsEntity? get randomSongs;
  @override
  SongEntity? get song;
  @override
  PlaylistEntity? get playlist;
  @override
  PlaylistsEntity? get playlists;
  @override
  PlayQueueEntity? get playQueue;
  @override
  LyricsListEntity? get lyricsList;
  @override
  ScanStatusEntity? get scanStatus;
  @override
  StarredEntity? get starred;
  @override
  ArtistEntity? get artist;
  @override
  ErrorEntity? get error;

  /// Create a copy of SubsonicResponseClass
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SubsonicResponseClassImplCopyWith<_$SubsonicResponseClassImpl>
      get copyWith => throw _privateConstructorUsedError;
}
