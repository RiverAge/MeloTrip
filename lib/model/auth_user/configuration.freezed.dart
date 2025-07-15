// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Configuration {

@JsonKey(name: 'user_id') String? get userId;@JsonKey(name: 'max_rate') String? get maxRate;@JsonKey(name: 'playlist_mode') PlaylistMode? get playlistMode;@JsonKey(name: 'recent_searches') String? get recentSearches; ThemeMode? get theme;@LocaleConvert() Locale? get locale;@JsonKey(name: 'update_at') int? get updateAt;
/// Create a copy of Configuration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConfigurationCopyWith<Configuration> get copyWith => _$ConfigurationCopyWithImpl<Configuration>(this as Configuration, _$identity);

  /// Serializes this Configuration to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Configuration&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.maxRate, maxRate) || other.maxRate == maxRate)&&(identical(other.playlistMode, playlistMode) || other.playlistMode == playlistMode)&&(identical(other.recentSearches, recentSearches) || other.recentSearches == recentSearches)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.updateAt, updateAt) || other.updateAt == updateAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,maxRate,playlistMode,recentSearches,theme,locale,updateAt);

@override
String toString() {
  return 'Configuration(userId: $userId, maxRate: $maxRate, playlistMode: $playlistMode, recentSearches: $recentSearches, theme: $theme, locale: $locale, updateAt: $updateAt)';
}


}

/// @nodoc
abstract mixin class $ConfigurationCopyWith<$Res>  {
  factory $ConfigurationCopyWith(Configuration value, $Res Function(Configuration) _then) = _$ConfigurationCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'max_rate') String? maxRate,@JsonKey(name: 'playlist_mode') PlaylistMode? playlistMode,@JsonKey(name: 'recent_searches') String? recentSearches, ThemeMode? theme,@LocaleConvert() Locale? locale,@JsonKey(name: 'update_at') int? updateAt
});




}
/// @nodoc
class _$ConfigurationCopyWithImpl<$Res>
    implements $ConfigurationCopyWith<$Res> {
  _$ConfigurationCopyWithImpl(this._self, this._then);

  final Configuration _self;
  final $Res Function(Configuration) _then;

/// Create a copy of Configuration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = freezed,Object? maxRate = freezed,Object? playlistMode = freezed,Object? recentSearches = freezed,Object? theme = freezed,Object? locale = freezed,Object? updateAt = freezed,}) {
  return _then(_self.copyWith(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,maxRate: freezed == maxRate ? _self.maxRate : maxRate // ignore: cast_nullable_to_non_nullable
as String?,playlistMode: freezed == playlistMode ? _self.playlistMode : playlistMode // ignore: cast_nullable_to_non_nullable
as PlaylistMode?,recentSearches: freezed == recentSearches ? _self.recentSearches : recentSearches // ignore: cast_nullable_to_non_nullable
as String?,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeMode?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale?,updateAt: freezed == updateAt ? _self.updateAt : updateAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [Configuration].
extension ConfigurationPatterns on Configuration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Configuration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Configuration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Configuration value)  $default,){
final _that = this;
switch (_that) {
case _Configuration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Configuration value)?  $default,){
final _that = this;
switch (_that) {
case _Configuration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'max_rate')  String? maxRate, @JsonKey(name: 'playlist_mode')  PlaylistMode? playlistMode, @JsonKey(name: 'recent_searches')  String? recentSearches,  ThemeMode? theme, @LocaleConvert()  Locale? locale, @JsonKey(name: 'update_at')  int? updateAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Configuration() when $default != null:
return $default(_that.userId,_that.maxRate,_that.playlistMode,_that.recentSearches,_that.theme,_that.locale,_that.updateAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'max_rate')  String? maxRate, @JsonKey(name: 'playlist_mode')  PlaylistMode? playlistMode, @JsonKey(name: 'recent_searches')  String? recentSearches,  ThemeMode? theme, @LocaleConvert()  Locale? locale, @JsonKey(name: 'update_at')  int? updateAt)  $default,) {final _that = this;
switch (_that) {
case _Configuration():
return $default(_that.userId,_that.maxRate,_that.playlistMode,_that.recentSearches,_that.theme,_that.locale,_that.updateAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'user_id')  String? userId, @JsonKey(name: 'max_rate')  String? maxRate, @JsonKey(name: 'playlist_mode')  PlaylistMode? playlistMode, @JsonKey(name: 'recent_searches')  String? recentSearches,  ThemeMode? theme, @LocaleConvert()  Locale? locale, @JsonKey(name: 'update_at')  int? updateAt)?  $default,) {final _that = this;
switch (_that) {
case _Configuration() when $default != null:
return $default(_that.userId,_that.maxRate,_that.playlistMode,_that.recentSearches,_that.theme,_that.locale,_that.updateAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Configuration implements Configuration {
  const _Configuration({@JsonKey(name: 'user_id') this.userId, @JsonKey(name: 'max_rate') this.maxRate, @JsonKey(name: 'playlist_mode') this.playlistMode, @JsonKey(name: 'recent_searches') this.recentSearches, this.theme, @LocaleConvert() this.locale, @JsonKey(name: 'update_at') this.updateAt});
  factory _Configuration.fromJson(Map<String, dynamic> json) => _$ConfigurationFromJson(json);

@override@JsonKey(name: 'user_id') final  String? userId;
@override@JsonKey(name: 'max_rate') final  String? maxRate;
@override@JsonKey(name: 'playlist_mode') final  PlaylistMode? playlistMode;
@override@JsonKey(name: 'recent_searches') final  String? recentSearches;
@override final  ThemeMode? theme;
@override@LocaleConvert() final  Locale? locale;
@override@JsonKey(name: 'update_at') final  int? updateAt;

/// Create a copy of Configuration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConfigurationCopyWith<_Configuration> get copyWith => __$ConfigurationCopyWithImpl<_Configuration>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConfigurationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Configuration&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.maxRate, maxRate) || other.maxRate == maxRate)&&(identical(other.playlistMode, playlistMode) || other.playlistMode == playlistMode)&&(identical(other.recentSearches, recentSearches) || other.recentSearches == recentSearches)&&(identical(other.theme, theme) || other.theme == theme)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.updateAt, updateAt) || other.updateAt == updateAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,maxRate,playlistMode,recentSearches,theme,locale,updateAt);

@override
String toString() {
  return 'Configuration(userId: $userId, maxRate: $maxRate, playlistMode: $playlistMode, recentSearches: $recentSearches, theme: $theme, locale: $locale, updateAt: $updateAt)';
}


}

/// @nodoc
abstract mixin class _$ConfigurationCopyWith<$Res> implements $ConfigurationCopyWith<$Res> {
  factory _$ConfigurationCopyWith(_Configuration value, $Res Function(_Configuration) _then) = __$ConfigurationCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'user_id') String? userId,@JsonKey(name: 'max_rate') String? maxRate,@JsonKey(name: 'playlist_mode') PlaylistMode? playlistMode,@JsonKey(name: 'recent_searches') String? recentSearches, ThemeMode? theme,@LocaleConvert() Locale? locale,@JsonKey(name: 'update_at') int? updateAt
});




}
/// @nodoc
class __$ConfigurationCopyWithImpl<$Res>
    implements _$ConfigurationCopyWith<$Res> {
  __$ConfigurationCopyWithImpl(this._self, this._then);

  final _Configuration _self;
  final $Res Function(_Configuration) _then;

/// Create a copy of Configuration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? maxRate = freezed,Object? playlistMode = freezed,Object? recentSearches = freezed,Object? theme = freezed,Object? locale = freezed,Object? updateAt = freezed,}) {
  return _then(_Configuration(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,maxRate: freezed == maxRate ? _self.maxRate : maxRate // ignore: cast_nullable_to_non_nullable
as String?,playlistMode: freezed == playlistMode ? _self.playlistMode : playlistMode // ignore: cast_nullable_to_non_nullable
as PlaylistMode?,recentSearches: freezed == recentSearches ? _self.recentSearches : recentSearches // ignore: cast_nullable_to_non_nullable
as String?,theme: freezed == theme ? _self.theme : theme // ignore: cast_nullable_to_non_nullable
as ThemeMode?,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as Locale?,updateAt: freezed == updateAt ? _self.updateAt : updateAt // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
