// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_result3.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchResult3Entity {

 List<AlbumEntity>? get album; List<SongEntity>? get song; List<ArtistEntity>? get artist;
/// Create a copy of SearchResult3Entity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResult3EntityCopyWith<SearchResult3Entity> get copyWith => _$SearchResult3EntityCopyWithImpl<SearchResult3Entity>(this as SearchResult3Entity, _$identity);

  /// Serializes this SearchResult3Entity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResult3Entity&&const DeepCollectionEquality().equals(other.album, album)&&const DeepCollectionEquality().equals(other.song, song)&&const DeepCollectionEquality().equals(other.artist, artist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(album),const DeepCollectionEquality().hash(song),const DeepCollectionEquality().hash(artist));

@override
String toString() {
  return 'SearchResult3Entity(album: $album, song: $song, artist: $artist)';
}


}

/// @nodoc
abstract mixin class $SearchResult3EntityCopyWith<$Res>  {
  factory $SearchResult3EntityCopyWith(SearchResult3Entity value, $Res Function(SearchResult3Entity) _then) = _$SearchResult3EntityCopyWithImpl;
@useResult
$Res call({
 List<AlbumEntity>? album, List<SongEntity>? song, List<ArtistEntity>? artist
});




}
/// @nodoc
class _$SearchResult3EntityCopyWithImpl<$Res>
    implements $SearchResult3EntityCopyWith<$Res> {
  _$SearchResult3EntityCopyWithImpl(this._self, this._then);

  final SearchResult3Entity _self;
  final $Res Function(SearchResult3Entity) _then;

/// Create a copy of SearchResult3Entity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? album = freezed,Object? song = freezed,Object? artist = freezed,}) {
  return _then(_self.copyWith(
album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as List<AlbumEntity>?,song: freezed == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,artist: freezed == artist ? _self.artist : artist // ignore: cast_nullable_to_non_nullable
as List<ArtistEntity>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchResult3Entity].
extension SearchResult3EntityPatterns on SearchResult3Entity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchResult3Entity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchResult3Entity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchResult3Entity value)  $default,){
final _that = this;
switch (_that) {
case _SearchResult3Entity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchResult3Entity value)?  $default,){
final _that = this;
switch (_that) {
case _SearchResult3Entity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<AlbumEntity>? album,  List<SongEntity>? song,  List<ArtistEntity>? artist)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchResult3Entity() when $default != null:
return $default(_that.album,_that.song,_that.artist);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<AlbumEntity>? album,  List<SongEntity>? song,  List<ArtistEntity>? artist)  $default,) {final _that = this;
switch (_that) {
case _SearchResult3Entity():
return $default(_that.album,_that.song,_that.artist);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<AlbumEntity>? album,  List<SongEntity>? song,  List<ArtistEntity>? artist)?  $default,) {final _that = this;
switch (_that) {
case _SearchResult3Entity() when $default != null:
return $default(_that.album,_that.song,_that.artist);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchResult3Entity implements SearchResult3Entity {
  const _SearchResult3Entity({final  List<AlbumEntity>? album, final  List<SongEntity>? song, final  List<ArtistEntity>? artist}): _album = album,_song = song,_artist = artist;
  factory _SearchResult3Entity.fromJson(Map<String, dynamic> json) => _$SearchResult3EntityFromJson(json);

 final  List<AlbumEntity>? _album;
@override List<AlbumEntity>? get album {
  final value = _album;
  if (value == null) return null;
  if (_album is EqualUnmodifiableListView) return _album;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<SongEntity>? _song;
@override List<SongEntity>? get song {
  final value = _song;
  if (value == null) return null;
  if (_song is EqualUnmodifiableListView) return _song;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<ArtistEntity>? _artist;
@override List<ArtistEntity>? get artist {
  final value = _artist;
  if (value == null) return null;
  if (_artist is EqualUnmodifiableListView) return _artist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SearchResult3Entity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResult3EntityCopyWith<_SearchResult3Entity> get copyWith => __$SearchResult3EntityCopyWithImpl<_SearchResult3Entity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchResult3EntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResult3Entity&&const DeepCollectionEquality().equals(other._album, _album)&&const DeepCollectionEquality().equals(other._song, _song)&&const DeepCollectionEquality().equals(other._artist, _artist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_album),const DeepCollectionEquality().hash(_song),const DeepCollectionEquality().hash(_artist));

@override
String toString() {
  return 'SearchResult3Entity(album: $album, song: $song, artist: $artist)';
}


}

/// @nodoc
abstract mixin class _$SearchResult3EntityCopyWith<$Res> implements $SearchResult3EntityCopyWith<$Res> {
  factory _$SearchResult3EntityCopyWith(_SearchResult3Entity value, $Res Function(_SearchResult3Entity) _then) = __$SearchResult3EntityCopyWithImpl;
@override @useResult
$Res call({
 List<AlbumEntity>? album, List<SongEntity>? song, List<ArtistEntity>? artist
});




}
/// @nodoc
class __$SearchResult3EntityCopyWithImpl<$Res>
    implements _$SearchResult3EntityCopyWith<$Res> {
  __$SearchResult3EntityCopyWithImpl(this._self, this._then);

  final _SearchResult3Entity _self;
  final $Res Function(_SearchResult3Entity) _then;

/// Create a copy of SearchResult3Entity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? album = freezed,Object? song = freezed,Object? artist = freezed,}) {
  return _then(_SearchResult3Entity(
album: freezed == album ? _self._album : album // ignore: cast_nullable_to_non_nullable
as List<AlbumEntity>?,song: freezed == song ? _self._song : song // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,artist: freezed == artist ? _self._artist : artist // ignore: cast_nullable_to_non_nullable
as List<ArtistEntity>?,
  ));
}


}

// dart format on
