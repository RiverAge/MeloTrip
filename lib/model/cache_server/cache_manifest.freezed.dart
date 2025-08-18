// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cache_manifest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CacheManifest {

@ContentTypeCovert() ContentType? get contentType; int? get contentLength; String? get lastModified; String? get contentRange;
/// Create a copy of CacheManifest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CacheManifestCopyWith<CacheManifest> get copyWith => _$CacheManifestCopyWithImpl<CacheManifest>(this as CacheManifest, _$identity);

  /// Serializes this CacheManifest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CacheManifest&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.contentLength, contentLength) || other.contentLength == contentLength)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified)&&(identical(other.contentRange, contentRange) || other.contentRange == contentRange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentType,contentLength,lastModified,contentRange);

@override
String toString() {
  return 'CacheManifest(contentType: $contentType, contentLength: $contentLength, lastModified: $lastModified, contentRange: $contentRange)';
}


}

/// @nodoc
abstract mixin class $CacheManifestCopyWith<$Res>  {
  factory $CacheManifestCopyWith(CacheManifest value, $Res Function(CacheManifest) _then) = _$CacheManifestCopyWithImpl;
@useResult
$Res call({
@ContentTypeCovert() ContentType? contentType, int? contentLength, String? lastModified, String? contentRange
});




}
/// @nodoc
class _$CacheManifestCopyWithImpl<$Res>
    implements $CacheManifestCopyWith<$Res> {
  _$CacheManifestCopyWithImpl(this._self, this._then);

  final CacheManifest _self;
  final $Res Function(CacheManifest) _then;

/// Create a copy of CacheManifest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contentType = freezed,Object? contentLength = freezed,Object? lastModified = freezed,Object? contentRange = freezed,}) {
  return _then(_self.copyWith(
contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType?,contentLength: freezed == contentLength ? _self.contentLength : contentLength // ignore: cast_nullable_to_non_nullable
as int?,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as String?,contentRange: freezed == contentRange ? _self.contentRange : contentRange // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CacheManifest].
extension CacheManifestPatterns on CacheManifest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CacheManifest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CacheManifest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CacheManifest value)  $default,){
final _that = this;
switch (_that) {
case _CacheManifest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CacheManifest value)?  $default,){
final _that = this;
switch (_that) {
case _CacheManifest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ContentTypeCovert()  ContentType? contentType,  int? contentLength,  String? lastModified,  String? contentRange)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CacheManifest() when $default != null:
return $default(_that.contentType,_that.contentLength,_that.lastModified,_that.contentRange);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ContentTypeCovert()  ContentType? contentType,  int? contentLength,  String? lastModified,  String? contentRange)  $default,) {final _that = this;
switch (_that) {
case _CacheManifest():
return $default(_that.contentType,_that.contentLength,_that.lastModified,_that.contentRange);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ContentTypeCovert()  ContentType? contentType,  int? contentLength,  String? lastModified,  String? contentRange)?  $default,) {final _that = this;
switch (_that) {
case _CacheManifest() when $default != null:
return $default(_that.contentType,_that.contentLength,_that.lastModified,_that.contentRange);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CacheManifest implements CacheManifest {
  const _CacheManifest({@ContentTypeCovert() this.contentType, this.contentLength, this.lastModified, this.contentRange});
  factory _CacheManifest.fromJson(Map<String, dynamic> json) => _$CacheManifestFromJson(json);

@override@ContentTypeCovert() final  ContentType? contentType;
@override final  int? contentLength;
@override final  String? lastModified;
@override final  String? contentRange;

/// Create a copy of CacheManifest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CacheManifestCopyWith<_CacheManifest> get copyWith => __$CacheManifestCopyWithImpl<_CacheManifest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CacheManifestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CacheManifest&&(identical(other.contentType, contentType) || other.contentType == contentType)&&(identical(other.contentLength, contentLength) || other.contentLength == contentLength)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified)&&(identical(other.contentRange, contentRange) || other.contentRange == contentRange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contentType,contentLength,lastModified,contentRange);

@override
String toString() {
  return 'CacheManifest(contentType: $contentType, contentLength: $contentLength, lastModified: $lastModified, contentRange: $contentRange)';
}


}

/// @nodoc
abstract mixin class _$CacheManifestCopyWith<$Res> implements $CacheManifestCopyWith<$Res> {
  factory _$CacheManifestCopyWith(_CacheManifest value, $Res Function(_CacheManifest) _then) = __$CacheManifestCopyWithImpl;
@override @useResult
$Res call({
@ContentTypeCovert() ContentType? contentType, int? contentLength, String? lastModified, String? contentRange
});




}
/// @nodoc
class __$CacheManifestCopyWithImpl<$Res>
    implements _$CacheManifestCopyWith<$Res> {
  __$CacheManifestCopyWithImpl(this._self, this._then);

  final _CacheManifest _self;
  final $Res Function(_CacheManifest) _then;

/// Create a copy of CacheManifest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contentType = freezed,Object? contentLength = freezed,Object? lastModified = freezed,Object? contentRange = freezed,}) {
  return _then(_CacheManifest(
contentType: freezed == contentType ? _self.contentType : contentType // ignore: cast_nullable_to_non_nullable
as ContentType?,contentLength: freezed == contentLength ? _self.contentLength : contentLength // ignore: cast_nullable_to_non_nullable
as int?,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as String?,contentRange: freezed == contentRange ? _self.contentRange : contentRange // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
