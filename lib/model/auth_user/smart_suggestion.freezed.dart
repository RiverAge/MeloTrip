// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_suggestion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SmartSuggestion {

@JsonKey(name: 'song_id') String? get songId;@JsonKey(name: 'meta') String? get meta;@JsonKey(name: 'user_id') String? get userId;
/// Create a copy of SmartSuggestion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartSuggestionCopyWith<SmartSuggestion> get copyWith => _$SmartSuggestionCopyWithImpl<SmartSuggestion>(this as SmartSuggestion, _$identity);

  /// Serializes this SmartSuggestion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartSuggestion&&(identical(other.songId, songId) || other.songId == songId)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,songId,meta,userId);

@override
String toString() {
  return 'SmartSuggestion(songId: $songId, meta: $meta, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $SmartSuggestionCopyWith<$Res>  {
  factory $SmartSuggestionCopyWith(SmartSuggestion value, $Res Function(SmartSuggestion) _then) = _$SmartSuggestionCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'song_id') String? songId,@JsonKey(name: 'meta') String? meta,@JsonKey(name: 'user_id') String? userId
});




}
/// @nodoc
class _$SmartSuggestionCopyWithImpl<$Res>
    implements $SmartSuggestionCopyWith<$Res> {
  _$SmartSuggestionCopyWithImpl(this._self, this._then);

  final SmartSuggestion _self;
  final $Res Function(SmartSuggestion) _then;

/// Create a copy of SmartSuggestion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? songId = freezed,Object? meta = freezed,Object? userId = freezed,}) {
  return _then(_self.copyWith(
songId: freezed == songId ? _self.songId : songId // ignore: cast_nullable_to_non_nullable
as String?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SmartSuggestion].
extension SmartSuggestionPatterns on SmartSuggestion {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartSuggestion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartSuggestion() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartSuggestion value)  $default,){
final _that = this;
switch (_that) {
case _SmartSuggestion():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartSuggestion value)?  $default,){
final _that = this;
switch (_that) {
case _SmartSuggestion() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'song_id')  String? songId, @JsonKey(name: 'meta')  String? meta, @JsonKey(name: 'user_id')  String? userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartSuggestion() when $default != null:
return $default(_that.songId,_that.meta,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'song_id')  String? songId, @JsonKey(name: 'meta')  String? meta, @JsonKey(name: 'user_id')  String? userId)  $default,) {final _that = this;
switch (_that) {
case _SmartSuggestion():
return $default(_that.songId,_that.meta,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'song_id')  String? songId, @JsonKey(name: 'meta')  String? meta, @JsonKey(name: 'user_id')  String? userId)?  $default,) {final _that = this;
switch (_that) {
case _SmartSuggestion() when $default != null:
return $default(_that.songId,_that.meta,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartSuggestion implements SmartSuggestion {
  const _SmartSuggestion({@JsonKey(name: 'song_id') this.songId, @JsonKey(name: 'meta') this.meta, @JsonKey(name: 'user_id') this.userId});
  factory _SmartSuggestion.fromJson(Map<String, dynamic> json) => _$SmartSuggestionFromJson(json);

@override@JsonKey(name: 'song_id') final  String? songId;
@override@JsonKey(name: 'meta') final  String? meta;
@override@JsonKey(name: 'user_id') final  String? userId;

/// Create a copy of SmartSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartSuggestionCopyWith<_SmartSuggestion> get copyWith => __$SmartSuggestionCopyWithImpl<_SmartSuggestion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartSuggestionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartSuggestion&&(identical(other.songId, songId) || other.songId == songId)&&(identical(other.meta, meta) || other.meta == meta)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,songId,meta,userId);

@override
String toString() {
  return 'SmartSuggestion(songId: $songId, meta: $meta, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$SmartSuggestionCopyWith<$Res> implements $SmartSuggestionCopyWith<$Res> {
  factory _$SmartSuggestionCopyWith(_SmartSuggestion value, $Res Function(_SmartSuggestion) _then) = __$SmartSuggestionCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'song_id') String? songId,@JsonKey(name: 'meta') String? meta,@JsonKey(name: 'user_id') String? userId
});




}
/// @nodoc
class __$SmartSuggestionCopyWithImpl<$Res>
    implements _$SmartSuggestionCopyWith<$Res> {
  __$SmartSuggestionCopyWithImpl(this._self, this._then);

  final _SmartSuggestion _self;
  final $Res Function(_SmartSuggestion) _then;

/// Create a copy of SmartSuggestion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? songId = freezed,Object? meta = freezed,Object? userId = freezed,}) {
  return _then(_SmartSuggestion(
songId: freezed == songId ? _self.songId : songId // ignore: cast_nullable_to_non_nullable
as String?,meta: freezed == meta ? _self.meta : meta // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
