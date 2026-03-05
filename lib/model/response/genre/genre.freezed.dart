// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'genre.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenresEntity {

 List<GenreEntity>? get genre;
/// Create a copy of GenresEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenresEntityCopyWith<GenresEntity> get copyWith => _$GenresEntityCopyWithImpl<GenresEntity>(this as GenresEntity, _$identity);

  /// Serializes this GenresEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenresEntity&&const DeepCollectionEquality().equals(other.genre, genre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(genre));

@override
String toString() {
  return 'GenresEntity(genre: $genre)';
}


}

/// @nodoc
abstract mixin class $GenresEntityCopyWith<$Res>  {
  factory $GenresEntityCopyWith(GenresEntity value, $Res Function(GenresEntity) _then) = _$GenresEntityCopyWithImpl;
@useResult
$Res call({
 List<GenreEntity>? genre
});




}
/// @nodoc
class _$GenresEntityCopyWithImpl<$Res>
    implements $GenresEntityCopyWith<$Res> {
  _$GenresEntityCopyWithImpl(this._self, this._then);

  final GenresEntity _self;
  final $Res Function(GenresEntity) _then;

/// Create a copy of GenresEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? genre = freezed,}) {
  return _then(_self.copyWith(
genre: freezed == genre ? _self.genre : genre // ignore: cast_nullable_to_non_nullable
as List<GenreEntity>?,
  ));
}

}


/// Adds pattern-matching-related methods to [GenresEntity].
extension GenresEntityPatterns on GenresEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenresEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenresEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenresEntity value)  $default,){
final _that = this;
switch (_that) {
case _GenresEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenresEntity value)?  $default,){
final _that = this;
switch (_that) {
case _GenresEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GenreEntity>? genre)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenresEntity() when $default != null:
return $default(_that.genre);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GenreEntity>? genre)  $default,) {final _that = this;
switch (_that) {
case _GenresEntity():
return $default(_that.genre);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GenreEntity>? genre)?  $default,) {final _that = this;
switch (_that) {
case _GenresEntity() when $default != null:
return $default(_that.genre);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenresEntity implements GenresEntity {
  const _GenresEntity({final  List<GenreEntity>? genre}): _genre = genre;
  factory _GenresEntity.fromJson(Map<String, dynamic> json) => _$GenresEntityFromJson(json);

 final  List<GenreEntity>? _genre;
@override List<GenreEntity>? get genre {
  final value = _genre;
  if (value == null) return null;
  if (_genre is EqualUnmodifiableListView) return _genre;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of GenresEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenresEntityCopyWith<_GenresEntity> get copyWith => __$GenresEntityCopyWithImpl<_GenresEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenresEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenresEntity&&const DeepCollectionEquality().equals(other._genre, _genre));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_genre));

@override
String toString() {
  return 'GenresEntity(genre: $genre)';
}


}

/// @nodoc
abstract mixin class _$GenresEntityCopyWith<$Res> implements $GenresEntityCopyWith<$Res> {
  factory _$GenresEntityCopyWith(_GenresEntity value, $Res Function(_GenresEntity) _then) = __$GenresEntityCopyWithImpl;
@override @useResult
$Res call({
 List<GenreEntity>? genre
});




}
/// @nodoc
class __$GenresEntityCopyWithImpl<$Res>
    implements _$GenresEntityCopyWith<$Res> {
  __$GenresEntityCopyWithImpl(this._self, this._then);

  final _GenresEntity _self;
  final $Res Function(_GenresEntity) _then;

/// Create a copy of GenresEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? genre = freezed,}) {
  return _then(_GenresEntity(
genre: freezed == genre ? _self._genre : genre // ignore: cast_nullable_to_non_nullable
as List<GenreEntity>?,
  ));
}


}


/// @nodoc
mixin _$GenreEntity {

@JsonKey(name: 'value') String? get value; int? get songCount; int? get albumCount;
/// Create a copy of GenreEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenreEntityCopyWith<GenreEntity> get copyWith => _$GenreEntityCopyWithImpl<GenreEntity>(this as GenreEntity, _$identity);

  /// Serializes this GenreEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenreEntity&&(identical(other.value, value) || other.value == value)&&(identical(other.songCount, songCount) || other.songCount == songCount)&&(identical(other.albumCount, albumCount) || other.albumCount == albumCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,songCount,albumCount);

@override
String toString() {
  return 'GenreEntity(value: $value, songCount: $songCount, albumCount: $albumCount)';
}


}

/// @nodoc
abstract mixin class $GenreEntityCopyWith<$Res>  {
  factory $GenreEntityCopyWith(GenreEntity value, $Res Function(GenreEntity) _then) = _$GenreEntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'value') String? value, int? songCount, int? albumCount
});




}
/// @nodoc
class _$GenreEntityCopyWithImpl<$Res>
    implements $GenreEntityCopyWith<$Res> {
  _$GenreEntityCopyWithImpl(this._self, this._then);

  final GenreEntity _self;
  final $Res Function(GenreEntity) _then;

/// Create a copy of GenreEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = freezed,Object? songCount = freezed,Object? albumCount = freezed,}) {
  return _then(_self.copyWith(
value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,songCount: freezed == songCount ? _self.songCount : songCount // ignore: cast_nullable_to_non_nullable
as int?,albumCount: freezed == albumCount ? _self.albumCount : albumCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [GenreEntity].
extension GenreEntityPatterns on GenreEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenreEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenreEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenreEntity value)  $default,){
final _that = this;
switch (_that) {
case _GenreEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenreEntity value)?  $default,){
final _that = this;
switch (_that) {
case _GenreEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'value')  String? value,  int? songCount,  int? albumCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenreEntity() when $default != null:
return $default(_that.value,_that.songCount,_that.albumCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'value')  String? value,  int? songCount,  int? albumCount)  $default,) {final _that = this;
switch (_that) {
case _GenreEntity():
return $default(_that.value,_that.songCount,_that.albumCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'value')  String? value,  int? songCount,  int? albumCount)?  $default,) {final _that = this;
switch (_that) {
case _GenreEntity() when $default != null:
return $default(_that.value,_that.songCount,_that.albumCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenreEntity implements GenreEntity {
  const _GenreEntity({@JsonKey(name: 'value') this.value, this.songCount, this.albumCount});
  factory _GenreEntity.fromJson(Map<String, dynamic> json) => _$GenreEntityFromJson(json);

@override@JsonKey(name: 'value') final  String? value;
@override final  int? songCount;
@override final  int? albumCount;

/// Create a copy of GenreEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenreEntityCopyWith<_GenreEntity> get copyWith => __$GenreEntityCopyWithImpl<_GenreEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenreEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenreEntity&&(identical(other.value, value) || other.value == value)&&(identical(other.songCount, songCount) || other.songCount == songCount)&&(identical(other.albumCount, albumCount) || other.albumCount == albumCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value,songCount,albumCount);

@override
String toString() {
  return 'GenreEntity(value: $value, songCount: $songCount, albumCount: $albumCount)';
}


}

/// @nodoc
abstract mixin class _$GenreEntityCopyWith<$Res> implements $GenreEntityCopyWith<$Res> {
  factory _$GenreEntityCopyWith(_GenreEntity value, $Res Function(_GenreEntity) _then) = __$GenreEntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'value') String? value, int? songCount, int? albumCount
});




}
/// @nodoc
class __$GenreEntityCopyWithImpl<$Res>
    implements _$GenreEntityCopyWith<$Res> {
  __$GenreEntityCopyWithImpl(this._self, this._then);

  final _GenreEntity _self;
  final $Res Function(_GenreEntity) _then;

/// Create a copy of GenreEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = freezed,Object? songCount = freezed,Object? albumCount = freezed,}) {
  return _then(_GenreEntity(
value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,songCount: freezed == songCount ? _self.songCount : songCount // ignore: cast_nullable_to_non_nullable
as int?,albumCount: freezed == albumCount ? _self.albumCount : albumCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
