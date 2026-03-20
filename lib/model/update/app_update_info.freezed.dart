// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_update_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AppUpdateInfo {

 String get versionName; int get versionCode; String get sha256; int get fileSize; String get downloadUrl; String get changelog;
/// Create a copy of AppUpdateInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUpdateInfoCopyWith<AppUpdateInfo> get copyWith => _$AppUpdateInfoCopyWithImpl<AppUpdateInfo>(this as AppUpdateInfo, _$identity);

  /// Serializes this AppUpdateInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdateInfo&&(identical(other.versionName, versionName) || other.versionName == versionName)&&(identical(other.versionCode, versionCode) || other.versionCode == versionCode)&&(identical(other.sha256, sha256) || other.sha256 == sha256)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.changelog, changelog) || other.changelog == changelog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,versionName,versionCode,sha256,fileSize,downloadUrl,changelog);

@override
String toString() {
  return 'AppUpdateInfo(versionName: $versionName, versionCode: $versionCode, sha256: $sha256, fileSize: $fileSize, downloadUrl: $downloadUrl, changelog: $changelog)';
}


}

/// @nodoc
abstract mixin class $AppUpdateInfoCopyWith<$Res>  {
  factory $AppUpdateInfoCopyWith(AppUpdateInfo value, $Res Function(AppUpdateInfo) _then) = _$AppUpdateInfoCopyWithImpl;
@useResult
$Res call({
 String versionName, int versionCode, String sha256, int fileSize, String downloadUrl, String changelog
});




}
/// @nodoc
class _$AppUpdateInfoCopyWithImpl<$Res>
    implements $AppUpdateInfoCopyWith<$Res> {
  _$AppUpdateInfoCopyWithImpl(this._self, this._then);

  final AppUpdateInfo _self;
  final $Res Function(AppUpdateInfo) _then;

/// Create a copy of AppUpdateInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? versionName = null,Object? versionCode = null,Object? sha256 = null,Object? fileSize = null,Object? downloadUrl = null,Object? changelog = null,}) {
  return _then(_self.copyWith(
versionName: null == versionName ? _self.versionName : versionName // ignore: cast_nullable_to_non_nullable
as String,versionCode: null == versionCode ? _self.versionCode : versionCode // ignore: cast_nullable_to_non_nullable
as int,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,changelog: null == changelog ? _self.changelog : changelog // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppUpdateInfo].
extension AppUpdateInfoPatterns on AppUpdateInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUpdateInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUpdateInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUpdateInfo value)  $default,){
final _that = this;
switch (_that) {
case _AppUpdateInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUpdateInfo value)?  $default,){
final _that = this;
switch (_that) {
case _AppUpdateInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String versionName,  int versionCode,  String sha256,  int fileSize,  String downloadUrl,  String changelog)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUpdateInfo() when $default != null:
return $default(_that.versionName,_that.versionCode,_that.sha256,_that.fileSize,_that.downloadUrl,_that.changelog);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String versionName,  int versionCode,  String sha256,  int fileSize,  String downloadUrl,  String changelog)  $default,) {final _that = this;
switch (_that) {
case _AppUpdateInfo():
return $default(_that.versionName,_that.versionCode,_that.sha256,_that.fileSize,_that.downloadUrl,_that.changelog);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String versionName,  int versionCode,  String sha256,  int fileSize,  String downloadUrl,  String changelog)?  $default,) {final _that = this;
switch (_that) {
case _AppUpdateInfo() when $default != null:
return $default(_that.versionName,_that.versionCode,_that.sha256,_that.fileSize,_that.downloadUrl,_that.changelog);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AppUpdateInfo implements AppUpdateInfo {
  const _AppUpdateInfo({required this.versionName, required this.versionCode, required this.sha256, required this.fileSize, required this.downloadUrl, required this.changelog});
  factory _AppUpdateInfo.fromJson(Map<String, dynamic> json) => _$AppUpdateInfoFromJson(json);

@override final  String versionName;
@override final  int versionCode;
@override final  String sha256;
@override final  int fileSize;
@override final  String downloadUrl;
@override final  String changelog;

/// Create a copy of AppUpdateInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUpdateInfoCopyWith<_AppUpdateInfo> get copyWith => __$AppUpdateInfoCopyWithImpl<_AppUpdateInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppUpdateInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUpdateInfo&&(identical(other.versionName, versionName) || other.versionName == versionName)&&(identical(other.versionCode, versionCode) || other.versionCode == versionCode)&&(identical(other.sha256, sha256) || other.sha256 == sha256)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl)&&(identical(other.changelog, changelog) || other.changelog == changelog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,versionName,versionCode,sha256,fileSize,downloadUrl,changelog);

@override
String toString() {
  return 'AppUpdateInfo(versionName: $versionName, versionCode: $versionCode, sha256: $sha256, fileSize: $fileSize, downloadUrl: $downloadUrl, changelog: $changelog)';
}


}

/// @nodoc
abstract mixin class _$AppUpdateInfoCopyWith<$Res> implements $AppUpdateInfoCopyWith<$Res> {
  factory _$AppUpdateInfoCopyWith(_AppUpdateInfo value, $Res Function(_AppUpdateInfo) _then) = __$AppUpdateInfoCopyWithImpl;
@override @useResult
$Res call({
 String versionName, int versionCode, String sha256, int fileSize, String downloadUrl, String changelog
});




}
/// @nodoc
class __$AppUpdateInfoCopyWithImpl<$Res>
    implements _$AppUpdateInfoCopyWith<$Res> {
  __$AppUpdateInfoCopyWithImpl(this._self, this._then);

  final _AppUpdateInfo _self;
  final $Res Function(_AppUpdateInfo) _then;

/// Create a copy of AppUpdateInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? versionName = null,Object? versionCode = null,Object? sha256 = null,Object? fileSize = null,Object? downloadUrl = null,Object? changelog = null,}) {
  return _then(_AppUpdateInfo(
versionName: null == versionName ? _self.versionName : versionName // ignore: cast_nullable_to_non_nullable
as String,versionCode: null == versionCode ? _self.versionCode : versionCode // ignore: cast_nullable_to_non_nullable
as int,sha256: null == sha256 ? _self.sha256 : sha256 // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,downloadUrl: null == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String,changelog: null == changelog ? _self.changelog : changelog // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AppUpdateCheckResult {

 String get currentVersionName; int get currentVersionCode; AppUpdateInfo? get remote; bool get hasUpdate;
/// Create a copy of AppUpdateCheckResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppUpdateCheckResultCopyWith<AppUpdateCheckResult> get copyWith => _$AppUpdateCheckResultCopyWithImpl<AppUpdateCheckResult>(this as AppUpdateCheckResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppUpdateCheckResult&&(identical(other.currentVersionName, currentVersionName) || other.currentVersionName == currentVersionName)&&(identical(other.currentVersionCode, currentVersionCode) || other.currentVersionCode == currentVersionCode)&&(identical(other.remote, remote) || other.remote == remote)&&(identical(other.hasUpdate, hasUpdate) || other.hasUpdate == hasUpdate));
}


@override
int get hashCode => Object.hash(runtimeType,currentVersionName,currentVersionCode,remote,hasUpdate);

@override
String toString() {
  return 'AppUpdateCheckResult(currentVersionName: $currentVersionName, currentVersionCode: $currentVersionCode, remote: $remote, hasUpdate: $hasUpdate)';
}


}

/// @nodoc
abstract mixin class $AppUpdateCheckResultCopyWith<$Res>  {
  factory $AppUpdateCheckResultCopyWith(AppUpdateCheckResult value, $Res Function(AppUpdateCheckResult) _then) = _$AppUpdateCheckResultCopyWithImpl;
@useResult
$Res call({
 String currentVersionName, int currentVersionCode, AppUpdateInfo? remote, bool hasUpdate
});


$AppUpdateInfoCopyWith<$Res>? get remote;

}
/// @nodoc
class _$AppUpdateCheckResultCopyWithImpl<$Res>
    implements $AppUpdateCheckResultCopyWith<$Res> {
  _$AppUpdateCheckResultCopyWithImpl(this._self, this._then);

  final AppUpdateCheckResult _self;
  final $Res Function(AppUpdateCheckResult) _then;

/// Create a copy of AppUpdateCheckResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentVersionName = null,Object? currentVersionCode = null,Object? remote = freezed,Object? hasUpdate = null,}) {
  return _then(_self.copyWith(
currentVersionName: null == currentVersionName ? _self.currentVersionName : currentVersionName // ignore: cast_nullable_to_non_nullable
as String,currentVersionCode: null == currentVersionCode ? _self.currentVersionCode : currentVersionCode // ignore: cast_nullable_to_non_nullable
as int,remote: freezed == remote ? _self.remote : remote // ignore: cast_nullable_to_non_nullable
as AppUpdateInfo?,hasUpdate: null == hasUpdate ? _self.hasUpdate : hasUpdate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of AppUpdateCheckResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUpdateInfoCopyWith<$Res>? get remote {
    if (_self.remote == null) {
    return null;
  }

  return $AppUpdateInfoCopyWith<$Res>(_self.remote!, (value) {
    return _then(_self.copyWith(remote: value));
  });
}
}


/// Adds pattern-matching-related methods to [AppUpdateCheckResult].
extension AppUpdateCheckResultPatterns on AppUpdateCheckResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppUpdateCheckResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppUpdateCheckResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppUpdateCheckResult value)  $default,){
final _that = this;
switch (_that) {
case _AppUpdateCheckResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppUpdateCheckResult value)?  $default,){
final _that = this;
switch (_that) {
case _AppUpdateCheckResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String currentVersionName,  int currentVersionCode,  AppUpdateInfo? remote,  bool hasUpdate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppUpdateCheckResult() when $default != null:
return $default(_that.currentVersionName,_that.currentVersionCode,_that.remote,_that.hasUpdate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String currentVersionName,  int currentVersionCode,  AppUpdateInfo? remote,  bool hasUpdate)  $default,) {final _that = this;
switch (_that) {
case _AppUpdateCheckResult():
return $default(_that.currentVersionName,_that.currentVersionCode,_that.remote,_that.hasUpdate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String currentVersionName,  int currentVersionCode,  AppUpdateInfo? remote,  bool hasUpdate)?  $default,) {final _that = this;
switch (_that) {
case _AppUpdateCheckResult() when $default != null:
return $default(_that.currentVersionName,_that.currentVersionCode,_that.remote,_that.hasUpdate);case _:
  return null;

}
}

}

/// @nodoc


class _AppUpdateCheckResult implements AppUpdateCheckResult {
  const _AppUpdateCheckResult({required this.currentVersionName, required this.currentVersionCode, required this.remote, required this.hasUpdate});
  

@override final  String currentVersionName;
@override final  int currentVersionCode;
@override final  AppUpdateInfo? remote;
@override final  bool hasUpdate;

/// Create a copy of AppUpdateCheckResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppUpdateCheckResultCopyWith<_AppUpdateCheckResult> get copyWith => __$AppUpdateCheckResultCopyWithImpl<_AppUpdateCheckResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppUpdateCheckResult&&(identical(other.currentVersionName, currentVersionName) || other.currentVersionName == currentVersionName)&&(identical(other.currentVersionCode, currentVersionCode) || other.currentVersionCode == currentVersionCode)&&(identical(other.remote, remote) || other.remote == remote)&&(identical(other.hasUpdate, hasUpdate) || other.hasUpdate == hasUpdate));
}


@override
int get hashCode => Object.hash(runtimeType,currentVersionName,currentVersionCode,remote,hasUpdate);

@override
String toString() {
  return 'AppUpdateCheckResult(currentVersionName: $currentVersionName, currentVersionCode: $currentVersionCode, remote: $remote, hasUpdate: $hasUpdate)';
}


}

/// @nodoc
abstract mixin class _$AppUpdateCheckResultCopyWith<$Res> implements $AppUpdateCheckResultCopyWith<$Res> {
  factory _$AppUpdateCheckResultCopyWith(_AppUpdateCheckResult value, $Res Function(_AppUpdateCheckResult) _then) = __$AppUpdateCheckResultCopyWithImpl;
@override @useResult
$Res call({
 String currentVersionName, int currentVersionCode, AppUpdateInfo? remote, bool hasUpdate
});


@override $AppUpdateInfoCopyWith<$Res>? get remote;

}
/// @nodoc
class __$AppUpdateCheckResultCopyWithImpl<$Res>
    implements _$AppUpdateCheckResultCopyWith<$Res> {
  __$AppUpdateCheckResultCopyWithImpl(this._self, this._then);

  final _AppUpdateCheckResult _self;
  final $Res Function(_AppUpdateCheckResult) _then;

/// Create a copy of AppUpdateCheckResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentVersionName = null,Object? currentVersionCode = null,Object? remote = freezed,Object? hasUpdate = null,}) {
  return _then(_AppUpdateCheckResult(
currentVersionName: null == currentVersionName ? _self.currentVersionName : currentVersionName // ignore: cast_nullable_to_non_nullable
as String,currentVersionCode: null == currentVersionCode ? _self.currentVersionCode : currentVersionCode // ignore: cast_nullable_to_non_nullable
as int,remote: freezed == remote ? _self.remote : remote // ignore: cast_nullable_to_non_nullable
as AppUpdateInfo?,hasUpdate: null == hasUpdate ? _self.hasUpdate : hasUpdate // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of AppUpdateCheckResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppUpdateInfoCopyWith<$Res>? get remote {
    if (_self.remote == null) {
    return null;
  }

  return $AppUpdateInfoCopyWith<$Res>(_self.remote!, (value) {
    return _then(_self.copyWith(remote: value));
  });
}
}

// dart format on
