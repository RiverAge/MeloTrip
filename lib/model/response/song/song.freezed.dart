// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'song.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SongEntity {

 String? get id; String? get parent; bool? get isDir; String? get title; String? get album; String? get artist; int? get track; int? get year; String? get coverArt; int? get size; String? get contentType; String? get suffix; DateTime? get starred; int? get duration; int? get bitRate; String? get path; int? get discNumber; DateTime? get created; String? get albumId; String? get artistId; String? get type; int? get userRating; bool? get isVideo; int? get bpm; String? get comment; String? get sortName; String? get mediaType; String? get musicBrainzId; List<GenreElement>? get genres; ReplayGain? get replayGain; int? get channelCount; String? get genre; int? get samplingRate; int? get bitDepth; List<String>? get moods; List<ParticipateEntity>? get artists; String? get displayArtist; List<ParticipateEntity>? get albumArtists; String? get displayAlbumArtist; List<ContributorEntity>? get contributors; String? get displayComposer; String? get explicitStatus;
/// Create a copy of SongEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SongEntityCopyWith<SongEntity> get copyWith => _$SongEntityCopyWithImpl<SongEntity>(this as SongEntity, _$identity);

  /// Serializes this SongEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SongEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.isDir, isDir) || other.isDir == isDir)&&(identical(other.title, title) || other.title == title)&&(identical(other.album, album) || other.album == album)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.track, track) || other.track == track)&&(identical(other.year, year) || other.year == year)&&(identical(other.coverArt, coverArt) || other.coverArt == coverArt)&&(identical(other.size, size) || other.size == size)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.suffix, suffix) || other.suffix == suffix)&&(identical(other.starred, starred) || other.starred == starred)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.bitRate, bitRate) || other.bitRate == bitRate)&&(identical(other.path, path) || other.path == path)&&(identical(other.discNumber, discNumber) || other.discNumber == discNumber)&&(identical(other.created, created) || other.created == created)&&(identical(other.albumId, albumId) || other.albumId == albumId)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.type, type) || other.type == type)&&(identical(other.userRating, userRating) || other.userRating == userRating)&&(identical(other.isVideo, isVideo) || other.isVideo == isVideo)&&(identical(other.bpm, bpm) || other.bpm == bpm)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.sortName, sortName) || other.sortName == sortName)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.musicBrainzId, musicBrainzId) || other.musicBrainzId == musicBrainzId)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.replayGain, replayGain) || other.replayGain == replayGain)&&(identical(other.channelCount, channelCount) || other.channelCount == channelCount)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.samplingRate, samplingRate) || other.samplingRate == samplingRate)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&const DeepCollectionEquality().equals(other.moods, moods)&&const DeepCollectionEquality().equals(other.artists, artists)&&(identical(other.displayArtist, displayArtist) || other.displayArtist == displayArtist)&&const DeepCollectionEquality().equals(other.albumArtists, albumArtists)&&(identical(other.displayAlbumArtist, displayAlbumArtist) || other.displayAlbumArtist == displayAlbumArtist)&&const DeepCollectionEquality().equals(other.contributors, contributors)&&(identical(other.displayComposer, displayComposer) || other.displayComposer == displayComposer)&&(identical(other.explicitStatus, explicitStatus) || other.explicitStatus == explicitStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,parent,isDir,title,album,artist,track,year,coverArt,size,contentType,suffix,starred,duration,bitRate,path,discNumber,created,albumId,artistId,type,userRating,isVideo,bpm,comment,sortName,mediaType,musicBrainzId,const DeepCollectionEquality().hash(genres),replayGain,channelCount,genre,samplingRate,bitDepth,const DeepCollectionEquality().hash(moods),const DeepCollectionEquality().hash(artists),displayArtist,const DeepCollectionEquality().hash(albumArtists),displayAlbumArtist,const DeepCollectionEquality().hash(contributors),displayComposer,explicitStatus]);

@override
String toString() {
  return 'SongEntity(id: $id, parent: $parent, isDir: $isDir, title: $title, album: $album, artist: $artist, track: $track, year: $year, coverArt: $coverArt, size: $size, contentType: $contentType, suffix: $suffix, starred: $starred, duration: $duration, bitRate: $bitRate, path: $path, discNumber: $discNumber, created: $created, albumId: $albumId, artistId: $artistId, type: $type, userRating: $userRating, isVideo: $isVideo, bpm: $bpm, comment: $comment, sortName: $sortName, mediaType: $mediaType, musicBrainzId: $musicBrainzId, genres: $genres, replayGain: $replayGain, channelCount: $channelCount, genre: $genre, samplingRate: $samplingRate, bitDepth: $bitDepth, moods: $moods, artists: $artists, displayArtist: $displayArtist, albumArtists: $albumArtists, displayAlbumArtist: $displayAlbumArtist, contributors: $contributors, displayComposer: $displayComposer, explicitStatus: $explicitStatus)';
}


}

/// @nodoc
abstract mixin class $SongEntityCopyWith<$Res>  {
  factory $SongEntityCopyWith(SongEntity value, $Res Function(SongEntity) _then) = _$SongEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String? parent, bool? isDir, String? title, String? album, String? artist, int? track, int? year, String? coverArt, int? size, String? contentType, String? suffix, DateTime? starred, int? duration, int? bitRate, String? path, int? discNumber, DateTime? created, String? albumId, String? artistId, String? type, int? userRating, bool? isVideo, int? bpm, String? comment, String? sortName, String? mediaType, String? musicBrainzId, List<GenreElement>? genres, ReplayGain? replayGain, int? channelCount, String? genre, int? samplingRate, int? bitDepth, List<String>? moods, List<ParticipateEntity>? artists, String? displayArtist, List<ParticipateEntity>? albumArtists, String? displayAlbumArtist, List<ContributorEntity>? contributors, String? displayComposer, String? explicitStatus
});


$ReplayGainCopyWith<$Res>? get replayGain;

}
/// @nodoc
class _$SongEntityCopyWithImpl<$Res>
    implements $SongEntityCopyWith<$Res> {
  _$SongEntityCopyWithImpl(this._self, this._then);

  final SongEntity _self;
  final $Res Function(SongEntity) _then;

/// Create a copy of SongEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? parent = freezed,Object? isDir = freezed,Object? title = freezed,Object? album = freezed,Object? artist = freezed,Object? track = freezed,Object? year = freezed,Object? coverArt = freezed,Object? size = freezed,Object? contentType = freezed,Object? suffix = freezed,Object? starred = freezed,Object? duration = freezed,Object? bitRate = freezed,Object? path = freezed,Object? discNumber = freezed,Object? created = freezed,Object? albumId = freezed,Object? artistId = freezed,Object? type = freezed,Object? userRating = freezed,Object? isVideo = freezed,Object? bpm = freezed,Object? comment = freezed,Object? sortName = freezed,Object? mediaType = freezed,Object? musicBrainzId = freezed,Object? genres = freezed,Object? replayGain = freezed,Object? channelCount = freezed,Object? genre = freezed,Object? samplingRate = freezed,Object? bitDepth = freezed,Object? moods = freezed,Object? artists = freezed,Object? displayArtist = freezed,Object? albumArtists = freezed,Object? displayAlbumArtist = freezed,Object? contributors = freezed,Object? displayComposer = freezed,Object? explicitStatus = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as String?,isDir: freezed == isDir ? _self.isDir : isDir // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,track: freezed == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as int?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,coverArt: freezed == coverArt ? _self.coverArt : coverArt // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,suffix: freezed == suffix ? _self.suffix : suffix // ignore: cast_nullable_to_non_nullable
as String?,starred: freezed == starred ? _self.starred : starred // ignore: cast_nullable_to_non_nullable
as DateTime?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,bitRate: freezed == bitRate ? _self.bitRate : bitRate // ignore: cast_nullable_to_non_nullable
as int?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,discNumber: freezed == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime?,albumId: freezed == albumId ? _self.albumId : albumId // ignore: cast_nullable_to_non_nullable
as String?,artistId: freezed == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,userRating: freezed == userRating ? _self.userRating : userRating // ignore: cast_nullable_to_non_nullable
as int?,isVideo: freezed == isVideo ? _self.isVideo : isVideo // ignore: cast_nullable_to_non_nullable
as bool?,bpm: freezed == bpm ? _self.bpm : bpm // ignore: cast_nullable_to_non_nullable
as int?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,sortName: freezed == sortName ? _self.sortName : sortName // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,musicBrainzId: freezed == musicBrainzId ? _self.musicBrainzId : musicBrainzId // ignore: cast_nullable_to_non_nullable
as String?,genres: freezed == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreElement>?,replayGain: freezed == replayGain ? _self.replayGain : replayGain // ignore: cast_nullable_to_non_nullable
as ReplayGain?,channelCount: freezed == channelCount ? _self.channelCount : channelCount // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,samplingRate: freezed == samplingRate ? _self.samplingRate : samplingRate // ignore: cast_nullable_to_non_nullable
as int?,bitDepth: freezed == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int?,moods: freezed == moods ? _self.moods : moods // ignore: cast_nullable_to_non_nullable
as List<String>?,artists: freezed == artists ? _self.artists : artists // ignore: cast_nullable_to_non_nullable
as List<ParticipateEntity>?,displayArtist: freezed == displayArtist ? _self.displayArtist : displayArtist // ignore: cast_nullable_to_non_nullable
as String?,albumArtists: freezed == albumArtists ? _self.albumArtists : albumArtists // ignore: cast_nullable_to_non_nullable
as List<ParticipateEntity>?,displayAlbumArtist: freezed == displayAlbumArtist ? _self.displayAlbumArtist : displayAlbumArtist // ignore: cast_nullable_to_non_nullable
as String?,contributors: freezed == contributors ? _self.contributors : contributors // ignore: cast_nullable_to_non_nullable
as List<ContributorEntity>?,displayComposer: freezed == displayComposer ? _self.displayComposer : displayComposer // ignore: cast_nullable_to_non_nullable
as String?,explicitStatus: freezed == explicitStatus ? _self.explicitStatus : explicitStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of SongEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReplayGainCopyWith<$Res>? get replayGain {
    if (_self.replayGain == null) {
    return null;
  }

  return $ReplayGainCopyWith<$Res>(_self.replayGain!, (value) {
    return _then(_self.copyWith(replayGain: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _SongEntity implements SongEntity {
  const _SongEntity({this.id, this.parent, this.isDir, this.title, this.album, this.artist, this.track, this.year, this.coverArt, this.size, this.contentType, this.suffix, this.starred, this.duration, this.bitRate, this.path, this.discNumber, this.created, this.albumId, this.artistId, this.type, this.userRating, this.isVideo, this.bpm, this.comment, this.sortName, this.mediaType, this.musicBrainzId, final  List<GenreElement>? genres, this.replayGain, this.channelCount, this.genre, this.samplingRate, this.bitDepth, final  List<String>? moods, final  List<ParticipateEntity>? artists, this.displayArtist, final  List<ParticipateEntity>? albumArtists, this.displayAlbumArtist, final  List<ContributorEntity>? contributors, this.displayComposer, this.explicitStatus}): _genres = genres,_moods = moods,_artists = artists,_albumArtists = albumArtists,_contributors = contributors;
  factory _SongEntity.fromJson(Map<String, dynamic> json) => _$SongEntityFromJson(json);

@override final  String? id;
@override final  String? parent;
@override final  bool? isDir;
@override final  String? title;
@override final  String? album;
@override final  String? artist;
@override final  int? track;
@override final  int? year;
@override final  String? coverArt;
@override final  int? size;
@override final  String? contentType;
@override final  String? suffix;
@override final  DateTime? starred;
@override final  int? duration;
@override final  int? bitRate;
@override final  String? path;
@override final  int? discNumber;
@override final  DateTime? created;
@override final  String? albumId;
@override final  String? artistId;
@override final  String? type;
@override final  int? userRating;
@override final  bool? isVideo;
@override final  int? bpm;
@override final  String? comment;
@override final  String? sortName;
@override final  String? mediaType;
@override final  String? musicBrainzId;
 final  List<GenreElement>? _genres;
@override List<GenreElement>? get genres {
  final value = _genres;
  if (value == null) return null;
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  ReplayGain? replayGain;
@override final  int? channelCount;
@override final  String? genre;
@override final  int? samplingRate;
@override final  int? bitDepth;
 final  List<String>? _moods;
@override List<String>? get moods {
  final value = _moods;
  if (value == null) return null;
  if (_moods is EqualUnmodifiableListView) return _moods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ParticipateEntity>? _artists;
@override List<ParticipateEntity>? get artists {
  final value = _artists;
  if (value == null) return null;
  if (_artists is EqualUnmodifiableListView) return _artists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? displayArtist;
 final  List<ParticipateEntity>? _albumArtists;
@override List<ParticipateEntity>? get albumArtists {
  final value = _albumArtists;
  if (value == null) return null;
  if (_albumArtists is EqualUnmodifiableListView) return _albumArtists;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? displayAlbumArtist;
 final  List<ContributorEntity>? _contributors;
@override List<ContributorEntity>? get contributors {
  final value = _contributors;
  if (value == null) return null;
  if (_contributors is EqualUnmodifiableListView) return _contributors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? displayComposer;
@override final  String? explicitStatus;

/// Create a copy of SongEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SongEntityCopyWith<_SongEntity> get copyWith => __$SongEntityCopyWithImpl<_SongEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SongEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SongEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.parent, parent) || other.parent == parent)&&(identical(other.isDir, isDir) || other.isDir == isDir)&&(identical(other.title, title) || other.title == title)&&(identical(other.album, album) || other.album == album)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.track, track) || other.track == track)&&(identical(other.year, year) || other.year == year)&&(identical(other.coverArt, coverArt) || other.coverArt == coverArt)&&(identical(other.size, size) || other.size == size)&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.suffix, suffix) || other.suffix == suffix)&&(identical(other.starred, starred) || other.starred == starred)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.bitRate, bitRate) || other.bitRate == bitRate)&&(identical(other.path, path) || other.path == path)&&(identical(other.discNumber, discNumber) || other.discNumber == discNumber)&&(identical(other.created, created) || other.created == created)&&(identical(other.albumId, albumId) || other.albumId == albumId)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.type, type) || other.type == type)&&(identical(other.userRating, userRating) || other.userRating == userRating)&&(identical(other.isVideo, isVideo) || other.isVideo == isVideo)&&(identical(other.bpm, bpm) || other.bpm == bpm)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.sortName, sortName) || other.sortName == sortName)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.musicBrainzId, musicBrainzId) || other.musicBrainzId == musicBrainzId)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.replayGain, replayGain) || other.replayGain == replayGain)&&(identical(other.channelCount, channelCount) || other.channelCount == channelCount)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.samplingRate, samplingRate) || other.samplingRate == samplingRate)&&(identical(other.bitDepth, bitDepth) || other.bitDepth == bitDepth)&&const DeepCollectionEquality().equals(other._moods, _moods)&&const DeepCollectionEquality().equals(other._artists, _artists)&&(identical(other.displayArtist, displayArtist) || other.displayArtist == displayArtist)&&const DeepCollectionEquality().equals(other._albumArtists, _albumArtists)&&(identical(other.displayAlbumArtist, displayAlbumArtist) || other.displayAlbumArtist == displayAlbumArtist)&&const DeepCollectionEquality().equals(other._contributors, _contributors)&&(identical(other.displayComposer, displayComposer) || other.displayComposer == displayComposer)&&(identical(other.explicitStatus, explicitStatus) || other.explicitStatus == explicitStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,parent,isDir,title,album,artist,track,year,coverArt,size,contentType,suffix,starred,duration,bitRate,path,discNumber,created,albumId,artistId,type,userRating,isVideo,bpm,comment,sortName,mediaType,musicBrainzId,const DeepCollectionEquality().hash(_genres),replayGain,channelCount,genre,samplingRate,bitDepth,const DeepCollectionEquality().hash(_moods),const DeepCollectionEquality().hash(_artists),displayArtist,const DeepCollectionEquality().hash(_albumArtists),displayAlbumArtist,const DeepCollectionEquality().hash(_contributors),displayComposer,explicitStatus]);

@override
String toString() {
  return 'SongEntity(id: $id, parent: $parent, isDir: $isDir, title: $title, album: $album, artist: $artist, track: $track, year: $year, coverArt: $coverArt, size: $size, contentType: $contentType, suffix: $suffix, starred: $starred, duration: $duration, bitRate: $bitRate, path: $path, discNumber: $discNumber, created: $created, albumId: $albumId, artistId: $artistId, type: $type, userRating: $userRating, isVideo: $isVideo, bpm: $bpm, comment: $comment, sortName: $sortName, mediaType: $mediaType, musicBrainzId: $musicBrainzId, genres: $genres, replayGain: $replayGain, channelCount: $channelCount, genre: $genre, samplingRate: $samplingRate, bitDepth: $bitDepth, moods: $moods, artists: $artists, displayArtist: $displayArtist, albumArtists: $albumArtists, displayAlbumArtist: $displayAlbumArtist, contributors: $contributors, displayComposer: $displayComposer, explicitStatus: $explicitStatus)';
}


}

/// @nodoc
abstract mixin class _$SongEntityCopyWith<$Res> implements $SongEntityCopyWith<$Res> {
  factory _$SongEntityCopyWith(_SongEntity value, $Res Function(_SongEntity) _then) = __$SongEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? parent, bool? isDir, String? title, String? album, String? artist, int? track, int? year, String? coverArt, int? size, String? contentType, String? suffix, DateTime? starred, int? duration, int? bitRate, String? path, int? discNumber, DateTime? created, String? albumId, String? artistId, String? type, int? userRating, bool? isVideo, int? bpm, String? comment, String? sortName, String? mediaType, String? musicBrainzId, List<GenreElement>? genres, ReplayGain? replayGain, int? channelCount, String? genre, int? samplingRate, int? bitDepth, List<String>? moods, List<ParticipateEntity>? artists, String? displayArtist, List<ParticipateEntity>? albumArtists, String? displayAlbumArtist, List<ContributorEntity>? contributors, String? displayComposer, String? explicitStatus
});


@override $ReplayGainCopyWith<$Res>? get replayGain;

}
/// @nodoc
class __$SongEntityCopyWithImpl<$Res>
    implements _$SongEntityCopyWith<$Res> {
  __$SongEntityCopyWithImpl(this._self, this._then);

  final _SongEntity _self;
  final $Res Function(_SongEntity) _then;

/// Create a copy of SongEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? parent = freezed,Object? isDir = freezed,Object? title = freezed,Object? album = freezed,Object? artist = freezed,Object? track = freezed,Object? year = freezed,Object? coverArt = freezed,Object? size = freezed,Object? contentType = freezed,Object? suffix = freezed,Object? starred = freezed,Object? duration = freezed,Object? bitRate = freezed,Object? path = freezed,Object? discNumber = freezed,Object? created = freezed,Object? albumId = freezed,Object? artistId = freezed,Object? type = freezed,Object? userRating = freezed,Object? isVideo = freezed,Object? bpm = freezed,Object? comment = freezed,Object? sortName = freezed,Object? mediaType = freezed,Object? musicBrainzId = freezed,Object? genres = freezed,Object? replayGain = freezed,Object? channelCount = freezed,Object? genre = freezed,Object? samplingRate = freezed,Object? bitDepth = freezed,Object? moods = freezed,Object? artists = freezed,Object? displayArtist = freezed,Object? albumArtists = freezed,Object? displayAlbumArtist = freezed,Object? contributors = freezed,Object? displayComposer = freezed,Object? explicitStatus = freezed,}) {
  return _then(_SongEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,parent: freezed == parent ? _self.parent : parent // ignore: cast_nullable_to_non_nullable
as String?,isDir: freezed == isDir ? _self.isDir : isDir // ignore: cast_nullable_to_non_nullable
as bool?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,track: freezed == track ? _self.track : track // ignore: cast_nullable_to_non_nullable
as int?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,coverArt: freezed == coverArt ? _self.coverArt : coverArt // ignore: cast_nullable_to_non_nullable
as String?,size: freezed == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as int?,contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as String?,suffix: freezed == suffix ? _self.suffix : suffix // ignore: cast_nullable_to_non_nullable
as String?,starred: freezed == starred ? _self.starred : starred // ignore: cast_nullable_to_non_nullable
as DateTime?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,bitRate: freezed == bitRate ? _self.bitRate : bitRate // ignore: cast_nullable_to_non_nullable
as int?,path: freezed == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String?,discNumber: freezed == discNumber ? _self.discNumber : discNumber // ignore: cast_nullable_to_non_nullable
as int?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime?,albumId: freezed == albumId ? _self.albumId : albumId // ignore: cast_nullable_to_non_nullable
as String?,artistId: freezed == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,userRating: freezed == userRating ? _self.userRating : userRating // ignore: cast_nullable_to_non_nullable
as int?,isVideo: freezed == isVideo ? _self.isVideo : isVideo // ignore: cast_nullable_to_non_nullable
as bool?,bpm: freezed == bpm ? _self.bpm : bpm // ignore: cast_nullable_to_non_nullable
as int?,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,sortName: freezed == sortName ? _self.sortName : sortName // ignore: cast_nullable_to_non_nullable
as String?,mediaType: freezed == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String?,musicBrainzId: freezed == musicBrainzId ? _self.musicBrainzId : musicBrainzId // ignore: cast_nullable_to_non_nullable
as String?,genres: freezed == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreElement>?,replayGain: freezed == replayGain ? _self.replayGain : replayGain // ignore: cast_nullable_to_non_nullable
as ReplayGain?,channelCount: freezed == channelCount ? _self.channelCount : channelCount // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,samplingRate: freezed == samplingRate ? _self.samplingRate : samplingRate // ignore: cast_nullable_to_non_nullable
as int?,bitDepth: freezed == bitDepth ? _self.bitDepth : bitDepth // ignore: cast_nullable_to_non_nullable
as int?,moods: freezed == moods ? _self._moods : moods // ignore: cast_nullable_to_non_nullable
as List<String>?,artists: freezed == artists ? _self._artists : artists // ignore: cast_nullable_to_non_nullable
as List<ParticipateEntity>?,displayArtist: freezed == displayArtist ? _self.displayArtist : displayArtist // ignore: cast_nullable_to_non_nullable
as String?,albumArtists: freezed == albumArtists ? _self._albumArtists : albumArtists // ignore: cast_nullable_to_non_nullable
as List<ParticipateEntity>?,displayAlbumArtist: freezed == displayAlbumArtist ? _self.displayAlbumArtist : displayAlbumArtist // ignore: cast_nullable_to_non_nullable
as String?,contributors: freezed == contributors ? _self._contributors : contributors // ignore: cast_nullable_to_non_nullable
as List<ContributorEntity>?,displayComposer: freezed == displayComposer ? _self.displayComposer : displayComposer // ignore: cast_nullable_to_non_nullable
as String?,explicitStatus: freezed == explicitStatus ? _self.explicitStatus : explicitStatus // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of SongEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReplayGainCopyWith<$Res>? get replayGain {
    if (_self.replayGain == null) {
    return null;
  }

  return $ReplayGainCopyWith<$Res>(_self.replayGain!, (value) {
    return _then(_self.copyWith(replayGain: value));
  });
}
}


/// @nodoc
mixin _$ParticipateEntity {

 String? get id; String? get name;
/// Create a copy of ParticipateEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParticipateEntityCopyWith<ParticipateEntity> get copyWith => _$ParticipateEntityCopyWithImpl<ParticipateEntity>(this as ParticipateEntity, _$identity);

  /// Serializes this ParticipateEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParticipateEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ParticipateEntity(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $ParticipateEntityCopyWith<$Res>  {
  factory $ParticipateEntityCopyWith(ParticipateEntity value, $Res Function(ParticipateEntity) _then) = _$ParticipateEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String? name
});




}
/// @nodoc
class _$ParticipateEntityCopyWithImpl<$Res>
    implements $ParticipateEntityCopyWith<$Res> {
  _$ParticipateEntityCopyWithImpl(this._self, this._then);

  final ParticipateEntity _self;
  final $Res Function(ParticipateEntity) _then;

/// Create a copy of ParticipateEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ParticipateEntity implements ParticipateEntity {
  const _ParticipateEntity({this.id, this.name});
  factory _ParticipateEntity.fromJson(Map<String, dynamic> json) => _$ParticipateEntityFromJson(json);

@override final  String? id;
@override final  String? name;

/// Create a copy of ParticipateEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParticipateEntityCopyWith<_ParticipateEntity> get copyWith => __$ParticipateEntityCopyWithImpl<_ParticipateEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ParticipateEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParticipateEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ParticipateEntity(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$ParticipateEntityCopyWith<$Res> implements $ParticipateEntityCopyWith<$Res> {
  factory _$ParticipateEntityCopyWith(_ParticipateEntity value, $Res Function(_ParticipateEntity) _then) = __$ParticipateEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name
});




}
/// @nodoc
class __$ParticipateEntityCopyWithImpl<$Res>
    implements _$ParticipateEntityCopyWith<$Res> {
  __$ParticipateEntityCopyWithImpl(this._self, this._then);

  final _ParticipateEntity _self;
  final $Res Function(_ParticipateEntity) _then;

/// Create a copy of ParticipateEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,}) {
  return _then(_ParticipateEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ContributorEntity {

 String? get id; String? get name;
/// Create a copy of ContributorEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContributorEntityCopyWith<ContributorEntity> get copyWith => _$ContributorEntityCopyWithImpl<ContributorEntity>(this as ContributorEntity, _$identity);

  /// Serializes this ContributorEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContributorEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ContributorEntity(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $ContributorEntityCopyWith<$Res>  {
  factory $ContributorEntityCopyWith(ContributorEntity value, $Res Function(ContributorEntity) _then) = _$ContributorEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String? name
});




}
/// @nodoc
class _$ContributorEntityCopyWithImpl<$Res>
    implements $ContributorEntityCopyWith<$Res> {
  _$ContributorEntityCopyWithImpl(this._self, this._then);

  final ContributorEntity _self;
  final $Res Function(ContributorEntity) _then;

/// Create a copy of ContributorEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ContributorEntity implements ContributorEntity {
  const _ContributorEntity({this.id, this.name});
  factory _ContributorEntity.fromJson(Map<String, dynamic> json) => _$ContributorEntityFromJson(json);

@override final  String? id;
@override final  String? name;

/// Create a copy of ContributorEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContributorEntityCopyWith<_ContributorEntity> get copyWith => __$ContributorEntityCopyWithImpl<_ContributorEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContributorEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContributorEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'ContributorEntity(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$ContributorEntityCopyWith<$Res> implements $ContributorEntityCopyWith<$Res> {
  factory _$ContributorEntityCopyWith(_ContributorEntity value, $Res Function(_ContributorEntity) _then) = __$ContributorEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name
});




}
/// @nodoc
class __$ContributorEntityCopyWithImpl<$Res>
    implements _$ContributorEntityCopyWith<$Res> {
  __$ContributorEntityCopyWithImpl(this._self, this._then);

  final _ContributorEntity _self;
  final $Res Function(_ContributorEntity) _then;

/// Create a copy of ContributorEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,}) {
  return _then(_ContributorEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GenreElement {

 String? get name;
/// Create a copy of GenreElement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenreElementCopyWith<GenreElement> get copyWith => _$GenreElementCopyWithImpl<GenreElement>(this as GenreElement, _$identity);

  /// Serializes this GenreElement to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenreElement&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'GenreElement(name: $name)';
}


}

/// @nodoc
abstract mixin class $GenreElementCopyWith<$Res>  {
  factory $GenreElementCopyWith(GenreElement value, $Res Function(GenreElement) _then) = _$GenreElementCopyWithImpl;
@useResult
$Res call({
 String? name
});




}
/// @nodoc
class _$GenreElementCopyWithImpl<$Res>
    implements $GenreElementCopyWith<$Res> {
  _$GenreElementCopyWithImpl(this._self, this._then);

  final GenreElement _self;
  final $Res Function(GenreElement) _then;

/// Create a copy of GenreElement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = freezed,}) {
  return _then(_self.copyWith(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _GenreElement implements GenreElement {
  const _GenreElement({this.name});
  factory _GenreElement.fromJson(Map<String, dynamic> json) => _$GenreElementFromJson(json);

@override final  String? name;

/// Create a copy of GenreElement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenreElementCopyWith<_GenreElement> get copyWith => __$GenreElementCopyWithImpl<_GenreElement>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenreElementToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenreElement&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'GenreElement(name: $name)';
}


}

/// @nodoc
abstract mixin class _$GenreElementCopyWith<$Res> implements $GenreElementCopyWith<$Res> {
  factory _$GenreElementCopyWith(_GenreElement value, $Res Function(_GenreElement) _then) = __$GenreElementCopyWithImpl;
@override @useResult
$Res call({
 String? name
});




}
/// @nodoc
class __$GenreElementCopyWithImpl<$Res>
    implements _$GenreElementCopyWith<$Res> {
  __$GenreElementCopyWithImpl(this._self, this._then);

  final _GenreElement _self;
  final $Res Function(_GenreElement) _then;

/// Create a copy of GenreElement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = freezed,}) {
  return _then(_GenreElement(
name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReplayGain {

 int? get trackPeak; int? get albumPeak;
/// Create a copy of ReplayGain
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReplayGainCopyWith<ReplayGain> get copyWith => _$ReplayGainCopyWithImpl<ReplayGain>(this as ReplayGain, _$identity);

  /// Serializes this ReplayGain to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReplayGain&&(identical(other.trackPeak, trackPeak) || other.trackPeak == trackPeak)&&(identical(other.albumPeak, albumPeak) || other.albumPeak == albumPeak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trackPeak,albumPeak);

@override
String toString() {
  return 'ReplayGain(trackPeak: $trackPeak, albumPeak: $albumPeak)';
}


}

/// @nodoc
abstract mixin class $ReplayGainCopyWith<$Res>  {
  factory $ReplayGainCopyWith(ReplayGain value, $Res Function(ReplayGain) _then) = _$ReplayGainCopyWithImpl;
@useResult
$Res call({
 int? trackPeak, int? albumPeak
});




}
/// @nodoc
class _$ReplayGainCopyWithImpl<$Res>
    implements $ReplayGainCopyWith<$Res> {
  _$ReplayGainCopyWithImpl(this._self, this._then);

  final ReplayGain _self;
  final $Res Function(ReplayGain) _then;

/// Create a copy of ReplayGain
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? trackPeak = freezed,Object? albumPeak = freezed,}) {
  return _then(_self.copyWith(
trackPeak: freezed == trackPeak ? _self.trackPeak : trackPeak // ignore: cast_nullable_to_non_nullable
as int?,albumPeak: freezed == albumPeak ? _self.albumPeak : albumPeak // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ReplayGain implements ReplayGain {
  const _ReplayGain({this.trackPeak, this.albumPeak});
  factory _ReplayGain.fromJson(Map<String, dynamic> json) => _$ReplayGainFromJson(json);

@override final  int? trackPeak;
@override final  int? albumPeak;

/// Create a copy of ReplayGain
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReplayGainCopyWith<_ReplayGain> get copyWith => __$ReplayGainCopyWithImpl<_ReplayGain>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReplayGainToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReplayGain&&(identical(other.trackPeak, trackPeak) || other.trackPeak == trackPeak)&&(identical(other.albumPeak, albumPeak) || other.albumPeak == albumPeak));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,trackPeak,albumPeak);

@override
String toString() {
  return 'ReplayGain(trackPeak: $trackPeak, albumPeak: $albumPeak)';
}


}

/// @nodoc
abstract mixin class _$ReplayGainCopyWith<$Res> implements $ReplayGainCopyWith<$Res> {
  factory _$ReplayGainCopyWith(_ReplayGain value, $Res Function(_ReplayGain) _then) = __$ReplayGainCopyWithImpl;
@override @useResult
$Res call({
 int? trackPeak, int? albumPeak
});




}
/// @nodoc
class __$ReplayGainCopyWithImpl<$Res>
    implements _$ReplayGainCopyWith<$Res> {
  __$ReplayGainCopyWithImpl(this._self, this._then);

  final _ReplayGain _self;
  final $Res Function(_ReplayGain) _then;

/// Create a copy of ReplayGain
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? trackPeak = freezed,Object? albumPeak = freezed,}) {
  return _then(_ReplayGain(
trackPeak: freezed == trackPeak ? _self.trackPeak : trackPeak // ignore: cast_nullable_to_non_nullable
as int?,albumPeak: freezed == albumPeak ? _self.albumPeak : albumPeak // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
