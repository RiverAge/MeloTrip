// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'artist_info2.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ArtistInfo2Entity {

/// List of similar artists recommended by Navidrome.
@JsonKey(name: 'similarArtist') List<ArtistEntity>? get similarArtist;
/// Create a copy of ArtistInfo2Entity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArtistInfo2EntityCopyWith<ArtistInfo2Entity> get copyWith => _$ArtistInfo2EntityCopyWithImpl<ArtistInfo2Entity>(this as ArtistInfo2Entity, _$identity);

  /// Serializes this ArtistInfo2Entity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArtistInfo2Entity&&const DeepCollectionEquality().equals(other.similarArtist, similarArtist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(similarArtist));

@override
String toString() {
  return 'ArtistInfo2Entity(similarArtist: $similarArtist)';
}


}

/// @nodoc
abstract mixin class $ArtistInfo2EntityCopyWith<$Res>  {
  factory $ArtistInfo2EntityCopyWith(ArtistInfo2Entity value, $Res Function(ArtistInfo2Entity) _then) = _$ArtistInfo2EntityCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'similarArtist') List<ArtistEntity>? similarArtist
});




}
/// @nodoc
class _$ArtistInfo2EntityCopyWithImpl<$Res>
    implements $ArtistInfo2EntityCopyWith<$Res> {
  _$ArtistInfo2EntityCopyWithImpl(this._self, this._then);

  final ArtistInfo2Entity _self;
  final $Res Function(ArtistInfo2Entity) _then;

/// Create a copy of ArtistInfo2Entity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? similarArtist = freezed,}) {
  return _then(_self.copyWith(
similarArtist: freezed == similarArtist ? _self.similarArtist : similarArtist // ignore: cast_nullable_to_non_nullable
as List<ArtistEntity>?,
  ));
}

}


/// Adds pattern-matching-related methods to [ArtistInfo2Entity].
extension ArtistInfo2EntityPatterns on ArtistInfo2Entity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArtistInfo2Entity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArtistInfo2Entity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArtistInfo2Entity value)  $default,){
final _that = this;
switch (_that) {
case _ArtistInfo2Entity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArtistInfo2Entity value)?  $default,){
final _that = this;
switch (_that) {
case _ArtistInfo2Entity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'similarArtist')  List<ArtistEntity>? similarArtist)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArtistInfo2Entity() when $default != null:
return $default(_that.similarArtist);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'similarArtist')  List<ArtistEntity>? similarArtist)  $default,) {final _that = this;
switch (_that) {
case _ArtistInfo2Entity():
return $default(_that.similarArtist);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'similarArtist')  List<ArtistEntity>? similarArtist)?  $default,) {final _that = this;
switch (_that) {
case _ArtistInfo2Entity() when $default != null:
return $default(_that.similarArtist);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ArtistInfo2Entity implements ArtistInfo2Entity {
  const _ArtistInfo2Entity({@JsonKey(name: 'similarArtist') final  List<ArtistEntity>? similarArtist}): _similarArtist = similarArtist;
  factory _ArtistInfo2Entity.fromJson(Map<String, dynamic> json) => _$ArtistInfo2EntityFromJson(json);

/// List of similar artists recommended by Navidrome.
 final  List<ArtistEntity>? _similarArtist;
/// List of similar artists recommended by Navidrome.
@override@JsonKey(name: 'similarArtist') List<ArtistEntity>? get similarArtist {
  final value = _similarArtist;
  if (value == null) return null;
  if (_similarArtist is EqualUnmodifiableListView) return _similarArtist;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of ArtistInfo2Entity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArtistInfo2EntityCopyWith<_ArtistInfo2Entity> get copyWith => __$ArtistInfo2EntityCopyWithImpl<_ArtistInfo2Entity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ArtistInfo2EntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArtistInfo2Entity&&const DeepCollectionEquality().equals(other._similarArtist, _similarArtist));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_similarArtist));

@override
String toString() {
  return 'ArtistInfo2Entity(similarArtist: $similarArtist)';
}


}

/// @nodoc
abstract mixin class _$ArtistInfo2EntityCopyWith<$Res> implements $ArtistInfo2EntityCopyWith<$Res> {
  factory _$ArtistInfo2EntityCopyWith(_ArtistInfo2Entity value, $Res Function(_ArtistInfo2Entity) _then) = __$ArtistInfo2EntityCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'similarArtist') List<ArtistEntity>? similarArtist
});




}
/// @nodoc
class __$ArtistInfo2EntityCopyWithImpl<$Res>
    implements _$ArtistInfo2EntityCopyWith<$Res> {
  __$ArtistInfo2EntityCopyWithImpl(this._self, this._then);

  final _ArtistInfo2Entity _self;
  final $Res Function(_ArtistInfo2Entity) _then;

/// Create a copy of ArtistInfo2Entity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? similarArtist = freezed,}) {
  return _then(_ArtistInfo2Entity(
similarArtist: freezed == similarArtist ? _self._similarArtist : similarArtist // ignore: cast_nullable_to_non_nullable
as List<ArtistEntity>?,
  ));
}


}

// dart format on
