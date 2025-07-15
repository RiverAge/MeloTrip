// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'play_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayHistory {

@JsonKey(name: 'song_id') String? get songId;@JsonKey(name: 'play_count') int? get playCount;@JsonKey(name: 'last_played') int? get lastPlayed;@JsonKey(name: 'is_completed') String? get isCompleted;@JsonKey(name: 'is_skipped') String? get isSkipped;@JsonKey(name: 'user_id') String? get userId;
/// Create a copy of PlayHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayHistoryCopyWith<PlayHistory> get copyWith => _$PlayHistoryCopyWithImpl<PlayHistory>(this as PlayHistory, _$identity);

  /// Serializes this PlayHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayHistory&&(identical(other.songId, songId) || other.songId == songId)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.lastPlayed, lastPlayed) || other.lastPlayed == lastPlayed)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isSkipped, isSkipped) || other.isSkipped == isSkipped)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,songId,playCount,lastPlayed,isCompleted,isSkipped,userId);

@override
String toString() {
  return 'PlayHistory(songId: $songId, playCount: $playCount, lastPlayed: $lastPlayed, isCompleted: $isCompleted, isSkipped: $isSkipped, userId: $userId)';
}


}

/// @nodoc
abstract mixin class $PlayHistoryCopyWith<$Res>  {
  factory $PlayHistoryCopyWith(PlayHistory value, $Res Function(PlayHistory) _then) = _$PlayHistoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'song_id') String? songId,@JsonKey(name: 'play_count') int? playCount,@JsonKey(name: 'last_played') int? lastPlayed,@JsonKey(name: 'is_completed') String? isCompleted,@JsonKey(name: 'is_skipped') String? isSkipped,@JsonKey(name: 'user_id') String? userId
});




}
/// @nodoc
class _$PlayHistoryCopyWithImpl<$Res>
    implements $PlayHistoryCopyWith<$Res> {
  _$PlayHistoryCopyWithImpl(this._self, this._then);

  final PlayHistory _self;
  final $Res Function(PlayHistory) _then;

/// Create a copy of PlayHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? songId = freezed,Object? playCount = freezed,Object? lastPlayed = freezed,Object? isCompleted = freezed,Object? isSkipped = freezed,Object? userId = freezed,}) {
  return _then(_self.copyWith(
songId: freezed == songId ? _self.songId : songId // ignore: cast_nullable_to_non_nullable
as String?,playCount: freezed == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int?,lastPlayed: freezed == lastPlayed ? _self.lastPlayed : lastPlayed // ignore: cast_nullable_to_non_nullable
as int?,isCompleted: freezed == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as String?,isSkipped: freezed == isSkipped ? _self.isSkipped : isSkipped // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayHistory].
extension PlayHistoryPatterns on PlayHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayHistory value)  $default,){
final _that = this;
switch (_that) {
case _PlayHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayHistory value)?  $default,){
final _that = this;
switch (_that) {
case _PlayHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'song_id')  String? songId, @JsonKey(name: 'play_count')  int? playCount, @JsonKey(name: 'last_played')  int? lastPlayed, @JsonKey(name: 'is_completed')  String? isCompleted, @JsonKey(name: 'is_skipped')  String? isSkipped, @JsonKey(name: 'user_id')  String? userId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayHistory() when $default != null:
return $default(_that.songId,_that.playCount,_that.lastPlayed,_that.isCompleted,_that.isSkipped,_that.userId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'song_id')  String? songId, @JsonKey(name: 'play_count')  int? playCount, @JsonKey(name: 'last_played')  int? lastPlayed, @JsonKey(name: 'is_completed')  String? isCompleted, @JsonKey(name: 'is_skipped')  String? isSkipped, @JsonKey(name: 'user_id')  String? userId)  $default,) {final _that = this;
switch (_that) {
case _PlayHistory():
return $default(_that.songId,_that.playCount,_that.lastPlayed,_that.isCompleted,_that.isSkipped,_that.userId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'song_id')  String? songId, @JsonKey(name: 'play_count')  int? playCount, @JsonKey(name: 'last_played')  int? lastPlayed, @JsonKey(name: 'is_completed')  String? isCompleted, @JsonKey(name: 'is_skipped')  String? isSkipped, @JsonKey(name: 'user_id')  String? userId)?  $default,) {final _that = this;
switch (_that) {
case _PlayHistory() when $default != null:
return $default(_that.songId,_that.playCount,_that.lastPlayed,_that.isCompleted,_that.isSkipped,_that.userId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayHistory implements PlayHistory {
  const _PlayHistory({@JsonKey(name: 'song_id') this.songId, @JsonKey(name: 'play_count') this.playCount, @JsonKey(name: 'last_played') this.lastPlayed, @JsonKey(name: 'is_completed') this.isCompleted, @JsonKey(name: 'is_skipped') this.isSkipped, @JsonKey(name: 'user_id') this.userId});
  factory _PlayHistory.fromJson(Map<String, dynamic> json) => _$PlayHistoryFromJson(json);

@override@JsonKey(name: 'song_id') final  String? songId;
@override@JsonKey(name: 'play_count') final  int? playCount;
@override@JsonKey(name: 'last_played') final  int? lastPlayed;
@override@JsonKey(name: 'is_completed') final  String? isCompleted;
@override@JsonKey(name: 'is_skipped') final  String? isSkipped;
@override@JsonKey(name: 'user_id') final  String? userId;

/// Create a copy of PlayHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayHistoryCopyWith<_PlayHistory> get copyWith => __$PlayHistoryCopyWithImpl<_PlayHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayHistory&&(identical(other.songId, songId) || other.songId == songId)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&(identical(other.lastPlayed, lastPlayed) || other.lastPlayed == lastPlayed)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.isSkipped, isSkipped) || other.isSkipped == isSkipped)&&(identical(other.userId, userId) || other.userId == userId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,songId,playCount,lastPlayed,isCompleted,isSkipped,userId);

@override
String toString() {
  return 'PlayHistory(songId: $songId, playCount: $playCount, lastPlayed: $lastPlayed, isCompleted: $isCompleted, isSkipped: $isSkipped, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$PlayHistoryCopyWith<$Res> implements $PlayHistoryCopyWith<$Res> {
  factory _$PlayHistoryCopyWith(_PlayHistory value, $Res Function(_PlayHistory) _then) = __$PlayHistoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'song_id') String? songId,@JsonKey(name: 'play_count') int? playCount,@JsonKey(name: 'last_played') int? lastPlayed,@JsonKey(name: 'is_completed') String? isCompleted,@JsonKey(name: 'is_skipped') String? isSkipped,@JsonKey(name: 'user_id') String? userId
});




}
/// @nodoc
class __$PlayHistoryCopyWithImpl<$Res>
    implements _$PlayHistoryCopyWith<$Res> {
  __$PlayHistoryCopyWithImpl(this._self, this._then);

  final _PlayHistory _self;
  final $Res Function(_PlayHistory) _then;

/// Create a copy of PlayHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? songId = freezed,Object? playCount = freezed,Object? lastPlayed = freezed,Object? isCompleted = freezed,Object? isSkipped = freezed,Object? userId = freezed,}) {
  return _then(_PlayHistory(
songId: freezed == songId ? _self.songId : songId // ignore: cast_nullable_to_non_nullable
as String?,playCount: freezed == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int?,lastPlayed: freezed == lastPlayed ? _self.lastPlayed : lastPlayed // ignore: cast_nullable_to_non_nullable
as int?,isCompleted: freezed == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as String?,isSkipped: freezed == isSkipped ? _self.isSkipped : isSkipped // ignore: cast_nullable_to_non_nullable
as String?,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
