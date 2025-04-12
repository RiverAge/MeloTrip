// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'random_song.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RandomSongsEntity {

 List<SongEntity>? get song;
/// Create a copy of RandomSongsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RandomSongsEntityCopyWith<RandomSongsEntity> get copyWith => _$RandomSongsEntityCopyWithImpl<RandomSongsEntity>(this as RandomSongsEntity, _$identity);

  /// Serializes this RandomSongsEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RandomSongsEntity&&const DeepCollectionEquality().equals(other.song, song));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(song));

@override
String toString() {
  return 'RandomSongsEntity(song: $song)';
}


}

/// @nodoc
abstract mixin class $RandomSongsEntityCopyWith<$Res>  {
  factory $RandomSongsEntityCopyWith(RandomSongsEntity value, $Res Function(RandomSongsEntity) _then) = _$RandomSongsEntityCopyWithImpl;
@useResult
$Res call({
 List<SongEntity>? song
});




}
/// @nodoc
class _$RandomSongsEntityCopyWithImpl<$Res>
    implements $RandomSongsEntityCopyWith<$Res> {
  _$RandomSongsEntityCopyWithImpl(this._self, this._then);

  final RandomSongsEntity _self;
  final $Res Function(RandomSongsEntity) _then;

/// Create a copy of RandomSongsEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? song = freezed,}) {
  return _then(_self.copyWith(
song: freezed == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _RandomSongsEntity implements RandomSongsEntity {
  const _RandomSongsEntity({final  List<SongEntity>? song}): _song = song;
  factory _RandomSongsEntity.fromJson(Map<String, dynamic> json) => _$RandomSongsEntityFromJson(json);

 final  List<SongEntity>? _song;
@override List<SongEntity>? get song {
  final value = _song;
  if (value == null) return null;
  if (_song is EqualUnmodifiableListView) return _song;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of RandomSongsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RandomSongsEntityCopyWith<_RandomSongsEntity> get copyWith => __$RandomSongsEntityCopyWithImpl<_RandomSongsEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RandomSongsEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RandomSongsEntity&&const DeepCollectionEquality().equals(other._song, _song));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_song));

@override
String toString() {
  return 'RandomSongsEntity(song: $song)';
}


}

/// @nodoc
abstract mixin class _$RandomSongsEntityCopyWith<$Res> implements $RandomSongsEntityCopyWith<$Res> {
  factory _$RandomSongsEntityCopyWith(_RandomSongsEntity value, $Res Function(_RandomSongsEntity) _then) = __$RandomSongsEntityCopyWithImpl;
@override @useResult
$Res call({
 List<SongEntity>? song
});




}
/// @nodoc
class __$RandomSongsEntityCopyWithImpl<$Res>
    implements _$RandomSongsEntityCopyWith<$Res> {
  __$RandomSongsEntityCopyWithImpl(this._self, this._then);

  final _RandomSongsEntity _self;
  final $Res Function(_RandomSongsEntity) _then;

/// Create a copy of RandomSongsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? song = freezed,}) {
  return _then(_RandomSongsEntity(
song: freezed == song ? _self._song : song // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,
  ));
}


}

// dart format on
