// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'starred.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StarredEntity {

 List<SongEntity>? get song; List<AlbumEntity>? get album;
/// Create a copy of StarredEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StarredEntityCopyWith<StarredEntity> get copyWith => _$StarredEntityCopyWithImpl<StarredEntity>(this as StarredEntity, _$identity);

  /// Serializes this StarredEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StarredEntity&&const DeepCollectionEquality().equals(other.song, song)&&const DeepCollectionEquality().equals(other.album, album));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(song),const DeepCollectionEquality().hash(album));

@override
String toString() {
  return 'StarredEntity(song: $song, album: $album)';
}


}

/// @nodoc
abstract mixin class $StarredEntityCopyWith<$Res>  {
  factory $StarredEntityCopyWith(StarredEntity value, $Res Function(StarredEntity) _then) = _$StarredEntityCopyWithImpl;
@useResult
$Res call({
 List<SongEntity>? song, List<AlbumEntity>? album
});




}
/// @nodoc
class _$StarredEntityCopyWithImpl<$Res>
    implements $StarredEntityCopyWith<$Res> {
  _$StarredEntityCopyWithImpl(this._self, this._then);

  final StarredEntity _self;
  final $Res Function(StarredEntity) _then;

/// Create a copy of StarredEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? song = freezed,Object? album = freezed,}) {
  return _then(_self.copyWith(
song: freezed == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,album: freezed == album ? _self.album : album // ignore: cast_nullable_to_non_nullable
as List<AlbumEntity>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _StarredEntity implements StarredEntity {
  const _StarredEntity({final  List<SongEntity>? song, final  List<AlbumEntity>? album}): _song = song,_album = album;
  factory _StarredEntity.fromJson(Map<String, dynamic> json) => _$StarredEntityFromJson(json);

 final  List<SongEntity>? _song;
@override List<SongEntity>? get song {
  final value = _song;
  if (value == null) return null;
  if (_song is EqualUnmodifiableListView) return _song;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<AlbumEntity>? _album;
@override List<AlbumEntity>? get album {
  final value = _album;
  if (value == null) return null;
  if (_album is EqualUnmodifiableListView) return _album;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of StarredEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StarredEntityCopyWith<_StarredEntity> get copyWith => __$StarredEntityCopyWithImpl<_StarredEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StarredEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StarredEntity&&const DeepCollectionEquality().equals(other._song, _song)&&const DeepCollectionEquality().equals(other._album, _album));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_song),const DeepCollectionEquality().hash(_album));

@override
String toString() {
  return 'StarredEntity(song: $song, album: $album)';
}


}

/// @nodoc
abstract mixin class _$StarredEntityCopyWith<$Res> implements $StarredEntityCopyWith<$Res> {
  factory _$StarredEntityCopyWith(_StarredEntity value, $Res Function(_StarredEntity) _then) = __$StarredEntityCopyWithImpl;
@override @useResult
$Res call({
 List<SongEntity>? song, List<AlbumEntity>? album
});




}
/// @nodoc
class __$StarredEntityCopyWithImpl<$Res>
    implements _$StarredEntityCopyWith<$Res> {
  __$StarredEntityCopyWithImpl(this._self, this._then);

  final _StarredEntity _self;
  final $Res Function(_StarredEntity) _then;

/// Create a copy of StarredEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? song = freezed,Object? album = freezed,}) {
  return _then(_StarredEntity(
song: freezed == song ? _self._song : song // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,album: freezed == album ? _self._album : album // ignore: cast_nullable_to_non_nullable
as List<AlbumEntity>?,
  ));
}


}

// dart format on
