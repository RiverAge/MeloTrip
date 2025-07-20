// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'songs_by_gener.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SongsByGenreEntity {

 List<SongEntity>? get song;
/// Create a copy of SongsByGenreEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SongsByGenreEntityCopyWith<SongsByGenreEntity> get copyWith => _$SongsByGenreEntityCopyWithImpl<SongsByGenreEntity>(this as SongsByGenreEntity, _$identity);

  /// Serializes this SongsByGenreEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SongsByGenreEntity&&const DeepCollectionEquality().equals(other.song, song));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(song));

@override
String toString() {
  return 'SongsByGenreEntity(song: $song)';
}


}

/// @nodoc
abstract mixin class $SongsByGenreEntityCopyWith<$Res>  {
  factory $SongsByGenreEntityCopyWith(SongsByGenreEntity value, $Res Function(SongsByGenreEntity) _then) = _$SongsByGenreEntityCopyWithImpl;
@useResult
$Res call({
 List<SongEntity>? song
});




}
/// @nodoc
class _$SongsByGenreEntityCopyWithImpl<$Res>
    implements $SongsByGenreEntityCopyWith<$Res> {
  _$SongsByGenreEntityCopyWithImpl(this._self, this._then);

  final SongsByGenreEntity _self;
  final $Res Function(SongsByGenreEntity) _then;

/// Create a copy of SongsByGenreEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? song = freezed,}) {
  return _then(_self.copyWith(
song: freezed == song ? _self.song : song // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,
  ));
}

}


/// Adds pattern-matching-related methods to [SongsByGenreEntity].
extension SongsByGenreEntityPatterns on SongsByGenreEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SongsByGenreEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SongsByGenreEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SongsByGenreEntity value)  $default,){
final _that = this;
switch (_that) {
case _SongsByGenreEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SongsByGenreEntity value)?  $default,){
final _that = this;
switch (_that) {
case _SongsByGenreEntity() when $default != null:
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
case _SongsByGenreEntity() when $default != null:
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
case _SongsByGenreEntity():
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
case _SongsByGenreEntity() when $default != null:
return $default(_that.song);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SongsByGenreEntity implements SongsByGenreEntity {
  const _SongsByGenreEntity({final  List<SongEntity>? song}): _song = song;
  factory _SongsByGenreEntity.fromJson(Map<String, dynamic> json) => _$SongsByGenreEntityFromJson(json);

 final  List<SongEntity>? _song;
@override List<SongEntity>? get song {
  final value = _song;
  if (value == null) return null;
  if (_song is EqualUnmodifiableListView) return _song;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of SongsByGenreEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SongsByGenreEntityCopyWith<_SongsByGenreEntity> get copyWith => __$SongsByGenreEntityCopyWithImpl<_SongsByGenreEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SongsByGenreEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SongsByGenreEntity&&const DeepCollectionEquality().equals(other._song, _song));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_song));

@override
String toString() {
  return 'SongsByGenreEntity(song: $song)';
}


}

/// @nodoc
abstract mixin class _$SongsByGenreEntityCopyWith<$Res> implements $SongsByGenreEntityCopyWith<$Res> {
  factory _$SongsByGenreEntityCopyWith(_SongsByGenreEntity value, $Res Function(_SongsByGenreEntity) _then) = __$SongsByGenreEntityCopyWithImpl;
@override @useResult
$Res call({
 List<SongEntity>? song
});




}
/// @nodoc
class __$SongsByGenreEntityCopyWithImpl<$Res>
    implements _$SongsByGenreEntityCopyWith<$Res> {
  __$SongsByGenreEntityCopyWithImpl(this._self, this._then);

  final _SongsByGenreEntity _self;
  final $Res Function(_SongsByGenreEntity) _then;

/// Create a copy of SongsByGenreEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? song = freezed,}) {
  return _then(_SongsByGenreEntity(
song: freezed == song ? _self._song : song // ignore: cast_nullable_to_non_nullable
as List<SongEntity>?,
  ));
}


}

// dart format on
