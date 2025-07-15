// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'similar_songs2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SimilarSongs2Entity {

 List<SongEntity>? get song;
/// Create a copy of SimilarSongs2Entity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SimilarSongs2EntityCopyWith<SimilarSongs2Entity> get copyWith => _$SimilarSongs2EntityCopyWithImpl<SimilarSongs2Entity>(this as SimilarSongs2Entity, _$identity);

  /// Serializes this SimilarSongs2Entity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SimilarSongs2Entity&&const DeepCollectionEquality().equals(other.song, song));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(song));

@override
String toString() {
  return 'SimilarSongs2Entity(song: $song)';
}


}

/// @nodoc
abstract mixin class $SimilarSongs2EntityCopyWith<$Res>  {
  factory $SimilarSongs2EntityCopyWith(SimilarSongs2Entity value, $Res Function(SimilarSongs2Entity) _then) = _$SimilarSongs2EntityCopyWithImpl;
@useResult
$Res call({
 List<SongEntity>? song
});




}
/// @nodoc
class _$SimilarSongs2EntityCopyWithImpl<$Res>
    implements $SimilarSongs2EntityCopyWith<$Res> {
  _$SimilarSongs2EntityCopyWithImpl(this._self, this._then);

  final SimilarSongs2Entity _self;
  final $Res Function(SimilarSongs2Entity) _then;

/// Create a copy of SimilarSongs2Entity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? song = freezed,}) {
  return _then(_self.copyWith(
song: freezed == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SimilarSongs2Entity].
extension SimilarSongs2EntityPatterns on SimilarSongs2Entity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SimilarSongs2Entity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SimilarSongs2Entity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SimilarSongs2Entity value)  $default,){
final _that = this;
switch (_that) {
case _SimilarSongs2Entity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SimilarSongs2Entity value)?  $default,){
final _that = this;
switch (_that) {
case _SimilarSongs2Entity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SongEntity>? song)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SimilarSongs2Entity() when $default != null:
return $default(_that.song);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SongEntity>? song)  $default,) {final _that = this;
switch (_that) {
case _SimilarSongs2Entity():
return $default(_that.song);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SongEntity>? song)?  $default,) {final _that = this;
switch (_that) {
case _SimilarSongs2Entity() when $default != null:
return $default(_that.song);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SimilarSongs2Entity implements SimilarSongs2Entity {
  const _SimilarSongs2Entity({final  List<SongEntity>? song}): _song = song;
  factory _SimilarSongs2Entity.fromJson(Map<String, dynamic> json) => _$SimilarSongs2EntityFromJson(json);

 final  List<SongEntity>? _song;
@override List<SongEntity>? get song {
  final value = _song;
  if (value == null) return null;
  if (_song is EqualUnmodifiableListView) return _song;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SimilarSongs2Entity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SimilarSongs2EntityCopyWith<_SimilarSongs2Entity> get copyWith => __$SimilarSongs2EntityCopyWithImpl<_SimilarSongs2Entity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SimilarSongs2EntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SimilarSongs2Entity&&const DeepCollectionEquality().equals(other._song, _song));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_song));

@override
String toString() {
  return 'SimilarSongs2Entity(song: $song)';
}


}

/// @nodoc
abstract mixin class _$SimilarSongs2EntityCopyWith<$Res> implements $SimilarSongs2EntityCopyWith<$Res> {
  factory _$SimilarSongs2EntityCopyWith(_SimilarSongs2Entity value, $Res Function(_SimilarSongs2Entity) _then) = __$SimilarSongs2EntityCopyWithImpl;
@override @useResult
$Res call({
 List<SongEntity>? song
});




}
/// @nodoc
class __$SimilarSongs2EntityCopyWithImpl<$Res>
    implements _$SimilarSongs2EntityCopyWith<$Res> {
  __$SimilarSongs2EntityCopyWithImpl(this._self, this._then);

  final _SimilarSongs2Entity _self;
  final $Res Function(_SimilarSongs2Entity) _then;

/// Create a copy of SimilarSongs2Entity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? song = freezed,}) {
  return _then(_SimilarSongs2Entity(
song: freezed == song ? _self._song : song // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,
  ));
}


}

// dart format on
