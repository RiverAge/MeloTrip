// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'album.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AlbumEntity {

 String? get id; String? get name; String? get artist; String? get artistId; String? get coverArt; int? get songCount; int? get duration; DateTime? get created; DateTime? get starred; int? get year; String? get genre; int? get userRating; List<GenreElement>? get genres; String? get musicBrainzId; bool? get isCompilation; String? get sortName; List<DiscTitle>? get discTitles; ReleaseDate? get originalReleaseDate; ReleaseDate? get releaseDate; List<SongEntity>? get song;
/// Create a copy of AlbumEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumEntityCopyWith<AlbumEntity> get copyWith => _$AlbumEntityCopyWithImpl<AlbumEntity>(this as AlbumEntity, _$identity);

  /// Serializes this AlbumEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlbumEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.coverArt, coverArt) || other.coverArt == coverArt)&&(identical(other.songCount, songCount) || other.songCount == songCount)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.created, created) || other.created == created)&&(identical(other.starred, starred) || other.starred == starred)&&(identical(other.year, year) || other.year == year)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.userRating, userRating) || other.userRating == userRating)&&const DeepCollectionEquality().equals(other.genres, genres)&&(identical(other.musicBrainzId, musicBrainzId) || other.musicBrainzId == musicBrainzId)&&(identical(other.isCompilation, isCompilation) || other.isCompilation == isCompilation)&&(identical(other.sortName, sortName) || other.sortName == sortName)&&const DeepCollectionEquality().equals(other.discTitles, discTitles)&&(identical(other.originalReleaseDate, originalReleaseDate) || other.originalReleaseDate == originalReleaseDate)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&const DeepCollectionEquality().equals(other.song, song));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,artist,artistId,coverArt,songCount,duration,created,starred,year,genre,userRating,const DeepCollectionEquality().hash(genres),musicBrainzId,isCompilation,sortName,const DeepCollectionEquality().hash(discTitles),originalReleaseDate,releaseDate,const DeepCollectionEquality().hash(song)]);

@override
String toString() {
  return 'AlbumEntity(id: $id, name: $name, artist: $artist, artistId: $artistId, coverArt: $coverArt, songCount: $songCount, duration: $duration, created: $created, starred: $starred, year: $year, genre: $genre, userRating: $userRating, genres: $genres, musicBrainzId: $musicBrainzId, isCompilation: $isCompilation, sortName: $sortName, discTitles: $discTitles, originalReleaseDate: $originalReleaseDate, releaseDate: $releaseDate, song: $song)';
}


}

/// @nodoc
abstract mixin class $AlbumEntityCopyWith<$Res>  {
  factory $AlbumEntityCopyWith(AlbumEntity value, $Res Function(AlbumEntity) _then) = _$AlbumEntityCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? artist, String? artistId, String? coverArt, int? songCount, int? duration, DateTime? created, DateTime? starred, int? year, String? genre, int? userRating, List<GenreElement>? genres, String? musicBrainzId, bool? isCompilation, String? sortName, List<DiscTitle>? discTitles, ReleaseDate? originalReleaseDate, ReleaseDate? releaseDate, List<SongEntity>? song
});


$ReleaseDateCopyWith<$Res>? get originalReleaseDate;$ReleaseDateCopyWith<$Res>? get releaseDate;

}
/// @nodoc
class _$AlbumEntityCopyWithImpl<$Res>
    implements $AlbumEntityCopyWith<$Res> {
  _$AlbumEntityCopyWithImpl(this._self, this._then);

  final AlbumEntity _self;
  final $Res Function(AlbumEntity) _then;

/// Create a copy of AlbumEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? artist = freezed,Object? artistId = freezed,Object? coverArt = freezed,Object? songCount = freezed,Object? duration = freezed,Object? created = freezed,Object? starred = freezed,Object? year = freezed,Object? genre = freezed,Object? userRating = freezed,Object? genres = freezed,Object? musicBrainzId = freezed,Object? isCompilation = freezed,Object? sortName = freezed,Object? discTitles = freezed,Object? originalReleaseDate = freezed,Object? releaseDate = freezed,Object? song = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,artistId: freezed == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String?,coverArt: freezed == coverArt ? _self.coverArt : coverArt // ignore: cast_nullable_to_non_nullable
as String?,songCount: freezed == songCount ? _self.songCount : songCount // ignore: cast_nullable_to_non_nullable
as int?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime?,starred: freezed == starred ? _self.starred : starred // ignore: cast_nullable_to_non_nullable
as DateTime?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,userRating: freezed == userRating ? _self.userRating : userRating // ignore: cast_nullable_to_non_nullable
as int?,genres: freezed == genres ? _self.genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreElement>?,musicBrainzId: freezed == musicBrainzId ? _self.musicBrainzId : musicBrainzId // ignore: cast_nullable_to_non_nullable
as String?,isCompilation: freezed == isCompilation ? _self.isCompilation : isCompilation // ignore: cast_nullable_to_non_nullable
as bool?,sortName: freezed == sortName ? _self.sortName : sortName // ignore: cast_nullable_to_non_nullable
as String?,discTitles: freezed == discTitles ? _self.discTitles : discTitles // ignore: cast_nullable_to_non_nullable
as List<DiscTitle>?,originalReleaseDate: freezed == originalReleaseDate ? _self.originalReleaseDate : originalReleaseDate // ignore: cast_nullable_to_non_nullable
as ReleaseDate?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as ReleaseDate?,song: freezed == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,
  ));
}
/// Create a copy of AlbumEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReleaseDateCopyWith<$Res>? get originalReleaseDate {
    if (_self.originalReleaseDate == null) {
    return null;
  }

  return $ReleaseDateCopyWith<$Res>(_self.originalReleaseDate!, (value) {
    return _then(_self.copyWith(originalReleaseDate: value));
  });
}/// Create a copy of AlbumEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReleaseDateCopyWith<$Res>? get releaseDate {
    if (_self.releaseDate == null) {
    return null;
  }

  return $ReleaseDateCopyWith<$Res>(_self.releaseDate!, (value) {
    return _then(_self.copyWith(releaseDate: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _AlbumEntity implements AlbumEntity {
  const _AlbumEntity({this.id, this.name, this.artist, this.artistId, this.coverArt, this.songCount, this.duration, this.created, this.starred, this.year, this.genre, this.userRating, final  List<GenreElement>? genres, this.musicBrainzId, this.isCompilation, this.sortName, final  List<DiscTitle>? discTitles, this.originalReleaseDate, this.releaseDate, final  List<SongEntity>? song}): _genres = genres,_discTitles = discTitles,_song = song;
  factory _AlbumEntity.fromJson(Map<String, dynamic> json) => _$AlbumEntityFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String? artist;
@override final  String? artistId;
@override final  String? coverArt;
@override final  int? songCount;
@override final  int? duration;
@override final  DateTime? created;
@override final  DateTime? starred;
@override final  int? year;
@override final  String? genre;
@override final  int? userRating;
 final  List<GenreElement>? _genres;
@override List<GenreElement>? get genres {
  final value = _genres;
  if (value == null) return null;
  if (_genres is EqualUnmodifiableListView) return _genres;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? musicBrainzId;
@override final  bool? isCompilation;
@override final  String? sortName;
 final  List<DiscTitle>? _discTitles;
@override List<DiscTitle>? get discTitles {
  final value = _discTitles;
  if (value == null) return null;
  if (_discTitles is EqualUnmodifiableListView) return _discTitles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  ReleaseDate? originalReleaseDate;
@override final  ReleaseDate? releaseDate;
 final  List<SongEntity>? _song;
@override List<SongEntity>? get song {
  final value = _song;
  if (value == null) return null;
  if (_song is EqualUnmodifiableListView) return _song;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AlbumEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumEntityCopyWith<_AlbumEntity> get copyWith => __$AlbumEntityCopyWithImpl<_AlbumEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlbumEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlbumEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.artist, artist) || other.artist == artist)&&(identical(other.artistId, artistId) || other.artistId == artistId)&&(identical(other.coverArt, coverArt) || other.coverArt == coverArt)&&(identical(other.songCount, songCount) || other.songCount == songCount)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.created, created) || other.created == created)&&(identical(other.starred, starred) || other.starred == starred)&&(identical(other.year, year) || other.year == year)&&(identical(other.genre, genre) || other.genre == genre)&&(identical(other.userRating, userRating) || other.userRating == userRating)&&const DeepCollectionEquality().equals(other._genres, _genres)&&(identical(other.musicBrainzId, musicBrainzId) || other.musicBrainzId == musicBrainzId)&&(identical(other.isCompilation, isCompilation) || other.isCompilation == isCompilation)&&(identical(other.sortName, sortName) || other.sortName == sortName)&&const DeepCollectionEquality().equals(other._discTitles, _discTitles)&&(identical(other.originalReleaseDate, originalReleaseDate) || other.originalReleaseDate == originalReleaseDate)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate)&&const DeepCollectionEquality().equals(other._song, _song));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,artist,artistId,coverArt,songCount,duration,created,starred,year,genre,userRating,const DeepCollectionEquality().hash(_genres),musicBrainzId,isCompilation,sortName,const DeepCollectionEquality().hash(_discTitles),originalReleaseDate,releaseDate,const DeepCollectionEquality().hash(_song)]);

@override
String toString() {
  return 'AlbumEntity(id: $id, name: $name, artist: $artist, artistId: $artistId, coverArt: $coverArt, songCount: $songCount, duration: $duration, created: $created, starred: $starred, year: $year, genre: $genre, userRating: $userRating, genres: $genres, musicBrainzId: $musicBrainzId, isCompilation: $isCompilation, sortName: $sortName, discTitles: $discTitles, originalReleaseDate: $originalReleaseDate, releaseDate: $releaseDate, song: $song)';
}


}

/// @nodoc
abstract mixin class _$AlbumEntityCopyWith<$Res> implements $AlbumEntityCopyWith<$Res> {
  factory _$AlbumEntityCopyWith(_AlbumEntity value, $Res Function(_AlbumEntity) _then) = __$AlbumEntityCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? artist, String? artistId, String? coverArt, int? songCount, int? duration, DateTime? created, DateTime? starred, int? year, String? genre, int? userRating, List<GenreElement>? genres, String? musicBrainzId, bool? isCompilation, String? sortName, List<DiscTitle>? discTitles, ReleaseDate? originalReleaseDate, ReleaseDate? releaseDate, List<SongEntity>? song
});


@override $ReleaseDateCopyWith<$Res>? get originalReleaseDate;@override $ReleaseDateCopyWith<$Res>? get releaseDate;

}
/// @nodoc
class __$AlbumEntityCopyWithImpl<$Res>
    implements _$AlbumEntityCopyWith<$Res> {
  __$AlbumEntityCopyWithImpl(this._self, this._then);

  final _AlbumEntity _self;
  final $Res Function(_AlbumEntity) _then;

/// Create a copy of AlbumEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? artist = freezed,Object? artistId = freezed,Object? coverArt = freezed,Object? songCount = freezed,Object? duration = freezed,Object? created = freezed,Object? starred = freezed,Object? year = freezed,Object? genre = freezed,Object? userRating = freezed,Object? genres = freezed,Object? musicBrainzId = freezed,Object? isCompilation = freezed,Object? sortName = freezed,Object? discTitles = freezed,Object? originalReleaseDate = freezed,Object? releaseDate = freezed,Object? song = freezed,}) {
  return _then(_AlbumEntity(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as String?,artistId: freezed == artistId ? _self.artistId : artistId // ignore: cast_nullable_to_non_nullable
as String?,coverArt: freezed == coverArt ? _self.coverArt : coverArt // ignore: cast_nullable_to_non_nullable
as String?,songCount: freezed == songCount ? _self.songCount : songCount // ignore: cast_nullable_to_non_nullable
as int?,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,created: freezed == created ? _self.created : created // ignore: cast_nullable_to_non_nullable
as DateTime?,starred: freezed == starred ? _self.starred : starred // ignore: cast_nullable_to_non_nullable
as DateTime?,year: freezed == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int?,genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as String?,userRating: freezed == userRating ? _self.userRating : userRating // ignore: cast_nullable_to_non_nullable
as int?,genres: freezed == genres ? _self._genres : genres // ignore: cast_nullable_to_non_nullable
as List<GenreElement>?,musicBrainzId: freezed == musicBrainzId ? _self.musicBrainzId : musicBrainzId // ignore: cast_nullable_to_non_nullable
as String?,isCompilation: freezed == isCompilation ? _self.isCompilation : isCompilation // ignore: cast_nullable_to_non_nullable
as bool?,sortName: freezed == sortName ? _self.sortName : sortName // ignore: cast_nullable_to_non_nullable
as String?,discTitles: freezed == discTitles ? _self._discTitles : discTitles // ignore: cast_nullable_to_non_nullable
as List<DiscTitle>?,originalReleaseDate: freezed == originalReleaseDate ? _self.originalReleaseDate : originalReleaseDate // ignore: cast_nullable_to_non_nullable
as ReleaseDate?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as ReleaseDate?,song: freezed == song ? _self._song : song // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,
  ));
}

/// Create a copy of AlbumEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReleaseDateCopyWith<$Res>? get originalReleaseDate {
    if (_self.originalReleaseDate == null) {
    return null;
  }

  return $ReleaseDateCopyWith<$Res>(_self.originalReleaseDate!, (value) {
    return _then(_self.copyWith(originalReleaseDate: value));
  });
}/// Create a copy of AlbumEntity
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ReleaseDateCopyWith<$Res>? get releaseDate {
    if (_self.releaseDate == null) {
    return null;
  }

  return $ReleaseDateCopyWith<$Res>(_self.releaseDate!, (value) {
    return _then(_self.copyWith(releaseDate: value));
  });
}
}


/// @nodoc
mixin _$DiscTitle {

 int? get disc; String? get title;
/// Create a copy of DiscTitle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiscTitleCopyWith<DiscTitle> get copyWith => _$DiscTitleCopyWithImpl<DiscTitle>(this as DiscTitle, _$identity);

  /// Serializes this DiscTitle to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiscTitle&&(identical(other.disc, disc) || other.disc == disc)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,disc,title);

@override
String toString() {
  return 'DiscTitle(disc: $disc, title: $title)';
}


}

/// @nodoc
abstract mixin class $DiscTitleCopyWith<$Res>  {
  factory $DiscTitleCopyWith(DiscTitle value, $Res Function(DiscTitle) _then) = _$DiscTitleCopyWithImpl;
@useResult
$Res call({
 int? disc, String? title
});




}
/// @nodoc
class _$DiscTitleCopyWithImpl<$Res>
    implements $DiscTitleCopyWith<$Res> {
  _$DiscTitleCopyWithImpl(this._self, this._then);

  final DiscTitle _self;
  final $Res Function(DiscTitle) _then;

/// Create a copy of DiscTitle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? disc = freezed,Object? title = freezed,}) {
  return _then(_self.copyWith(
disc: freezed == disc ? _self.disc : disc // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _DiscTitle implements DiscTitle {
  const _DiscTitle({this.disc, this.title});
  factory _DiscTitle.fromJson(Map<String, dynamic> json) => _$DiscTitleFromJson(json);

@override final  int? disc;
@override final  String? title;

/// Create a copy of DiscTitle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiscTitleCopyWith<_DiscTitle> get copyWith => __$DiscTitleCopyWithImpl<_DiscTitle>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiscTitleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiscTitle&&(identical(other.disc, disc) || other.disc == disc)&&(identical(other.title, title) || other.title == title));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,disc,title);

@override
String toString() {
  return 'DiscTitle(disc: $disc, title: $title)';
}


}

/// @nodoc
abstract mixin class _$DiscTitleCopyWith<$Res> implements $DiscTitleCopyWith<$Res> {
  factory _$DiscTitleCopyWith(_DiscTitle value, $Res Function(_DiscTitle) _then) = __$DiscTitleCopyWithImpl;
@override @useResult
$Res call({
 int? disc, String? title
});




}
/// @nodoc
class __$DiscTitleCopyWithImpl<$Res>
    implements _$DiscTitleCopyWith<$Res> {
  __$DiscTitleCopyWithImpl(this._self, this._then);

  final _DiscTitle _self;
  final $Res Function(_DiscTitle) _then;

/// Create a copy of DiscTitle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? disc = freezed,Object? title = freezed,}) {
  return _then(_DiscTitle(
disc: freezed == disc ? _self.disc : disc // ignore: cast_nullable_to_non_nullable
as int?,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReleaseDate {



  /// Serializes this ReleaseDate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReleaseDate);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReleaseDate()';
}


}

/// @nodoc
class $ReleaseDateCopyWith<$Res>  {
$ReleaseDateCopyWith(ReleaseDate _, $Res Function(ReleaseDate) __);
}


/// @nodoc
@JsonSerializable()

class _ReleaseDate implements ReleaseDate {
  const _ReleaseDate();
  factory _ReleaseDate.fromJson(Map<String, dynamic> json) => _$ReleaseDateFromJson(json);




@override
Map<String, dynamic> toJson() {
  return _$ReleaseDateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReleaseDate);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ReleaseDate()';
}


}





/// @nodoc
mixin _$AlbumListEntity {

 List<AlbumEntity>? get album;
/// Create a copy of AlbumListEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AlbumListEntityCopyWith<AlbumListEntity> get copyWith => _$AlbumListEntityCopyWithImpl<AlbumListEntity>(this as AlbumListEntity, _$identity);

  /// Serializes this AlbumListEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AlbumListEntity&&const DeepCollectionEquality().equals(other.album, album));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(album));

@override
String toString() {
  return 'AlbumListEntity(album: $album)';
}


}

/// @nodoc
abstract mixin class $AlbumListEntityCopyWith<$Res>  {
  factory $AlbumListEntityCopyWith(AlbumListEntity value, $Res Function(AlbumListEntity) _then) = _$AlbumListEntityCopyWithImpl;
@useResult
$Res call({
 List<AlbumEntity>? album
});




}
/// @nodoc
class _$AlbumListEntityCopyWithImpl<$Res>
    implements $AlbumListEntityCopyWith<$Res> {
  _$AlbumListEntityCopyWithImpl(this._self, this._then);

  final AlbumListEntity _self;
  final $Res Function(AlbumListEntity) _then;

/// Create a copy of AlbumListEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? album = freezed,}) {
  return _then(_self.copyWith(
album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as List<AlbumEntity>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _AlbumListEntity implements AlbumListEntity {
  const _AlbumListEntity({final  List<AlbumEntity>? album}): _album = album;
  factory _AlbumListEntity.fromJson(Map<String, dynamic> json) => _$AlbumListEntityFromJson(json);

 final  List<AlbumEntity>? _album;
@override List<AlbumEntity>? get album {
  final value = _album;
  if (value == null) return null;
  if (_album is EqualUnmodifiableListView) return _album;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of AlbumListEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AlbumListEntityCopyWith<_AlbumListEntity> get copyWith => __$AlbumListEntityCopyWithImpl<_AlbumListEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AlbumListEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AlbumListEntity&&const DeepCollectionEquality().equals(other._album, _album));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_album));

@override
String toString() {
  return 'AlbumListEntity(album: $album)';
}


}

/// @nodoc
abstract mixin class _$AlbumListEntityCopyWith<$Res> implements $AlbumListEntityCopyWith<$Res> {
  factory _$AlbumListEntityCopyWith(_AlbumListEntity value, $Res Function(_AlbumListEntity) _then) = __$AlbumListEntityCopyWithImpl;
@override @useResult
$Res call({
 List<AlbumEntity>? album
});




}
/// @nodoc
class __$AlbumListEntityCopyWithImpl<$Res>
    implements _$AlbumListEntityCopyWith<$Res> {
  __$AlbumListEntityCopyWithImpl(this._self, this._then);

  final _AlbumListEntity _self;
  final $Res Function(_AlbumListEntity) _then;

/// Create a copy of AlbumListEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? album = freezed,}) {
  return _then(_AlbumListEntity(
album: freezed == album ? _self._album : album // ignore: cast_nullable_to_non_nullable
as List<AlbumEntity>?,
  ));
}


}

// dart format on
