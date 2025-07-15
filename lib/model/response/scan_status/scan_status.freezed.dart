// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScanStatusEntity {

 bool? get scanning; int? get count; int? get folderCount; DateTime? get lastScan;
/// Create a copy of ScanStatusEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanStatusEntityCopyWith<ScanStatusEntity> get copyWith => _$ScanStatusEntityCopyWithImpl<ScanStatusEntity>(this as ScanStatusEntity, _$identity);

  /// Serializes this ScanStatusEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanStatusEntity&&(identical(other.scanning, scanning) || other.scanning == scanning)&&(identical(other.count, count) || other.count == count)&&(identical(other.folderCount, folderCount) || other.folderCount == folderCount)&&(identical(other.lastScan, lastScan) || other.lastScan == lastScan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scanning,count,folderCount,lastScan);

@override
String toString() {
  return 'ScanStatusEntity(scanning: $scanning, count: $count, folderCount: $folderCount, lastScan: $lastScan)';
}


}

/// @nodoc
abstract mixin class $ScanStatusEntityCopyWith<$Res>  {
  factory $ScanStatusEntityCopyWith(ScanStatusEntity value, $Res Function(ScanStatusEntity) _then) = _$ScanStatusEntityCopyWithImpl;
@useResult
$Res call({
 bool? scanning, int? count, int? folderCount, DateTime? lastScan
});




}
/// @nodoc
class _$ScanStatusEntityCopyWithImpl<$Res>
    implements $ScanStatusEntityCopyWith<$Res> {
  _$ScanStatusEntityCopyWithImpl(this._self, this._then);

  final ScanStatusEntity _self;
  final $Res Function(ScanStatusEntity) _then;

/// Create a copy of ScanStatusEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? scanning = freezed,Object? count = freezed,Object? folderCount = freezed,Object? lastScan = freezed,}) {
  return _then(_self.copyWith(
scanning: freezed == scanning ? _self.scanning : scanning // ignore: cast_nullable_to_non_nullable
as bool?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,folderCount: freezed == folderCount ? _self.folderCount : folderCount // ignore: cast_nullable_to_non_nullable
as int?,lastScan: freezed == lastScan ? _self.lastScan : lastScan // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ScanStatusEntity].
extension ScanStatusEntityPatterns on ScanStatusEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScanStatusEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScanStatusEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScanStatusEntity value)  $default,){
final _that = this;
switch (_that) {
case _ScanStatusEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScanStatusEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ScanStatusEntity() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool? scanning,  int? count,  int? folderCount,  DateTime? lastScan)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScanStatusEntity() when $default != null:
return $default(_that.scanning,_that.count,_that.folderCount,_that.lastScan);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool? scanning,  int? count,  int? folderCount,  DateTime? lastScan)  $default,) {final _that = this;
switch (_that) {
case _ScanStatusEntity():
return $default(_that.scanning,_that.count,_that.folderCount,_that.lastScan);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool? scanning,  int? count,  int? folderCount,  DateTime? lastScan)?  $default,) {final _that = this;
switch (_that) {
case _ScanStatusEntity() when $default != null:
return $default(_that.scanning,_that.count,_that.folderCount,_that.lastScan);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScanStatusEntity implements ScanStatusEntity {
  const _ScanStatusEntity({this.scanning, this.count, this.folderCount, this.lastScan});
  factory _ScanStatusEntity.fromJson(Map<String, dynamic> json) => _$ScanStatusEntityFromJson(json);

@override final  bool? scanning;
@override final  int? count;
@override final  int? folderCount;
@override final  DateTime? lastScan;

/// Create a copy of ScanStatusEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScanStatusEntityCopyWith<_ScanStatusEntity> get copyWith => __$ScanStatusEntityCopyWithImpl<_ScanStatusEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScanStatusEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScanStatusEntity&&(identical(other.scanning, scanning) || other.scanning == scanning)&&(identical(other.count, count) || other.count == count)&&(identical(other.folderCount, folderCount) || other.folderCount == folderCount)&&(identical(other.lastScan, lastScan) || other.lastScan == lastScan));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,scanning,count,folderCount,lastScan);

@override
String toString() {
  return 'ScanStatusEntity(scanning: $scanning, count: $count, folderCount: $folderCount, lastScan: $lastScan)';
}


}

/// @nodoc
abstract mixin class _$ScanStatusEntityCopyWith<$Res> implements $ScanStatusEntityCopyWith<$Res> {
  factory _$ScanStatusEntityCopyWith(_ScanStatusEntity value, $Res Function(_ScanStatusEntity) _then) = __$ScanStatusEntityCopyWithImpl;
@override @useResult
$Res call({
 bool? scanning, int? count, int? folderCount, DateTime? lastScan
});




}
/// @nodoc
class __$ScanStatusEntityCopyWithImpl<$Res>
    implements _$ScanStatusEntityCopyWith<$Res> {
  __$ScanStatusEntityCopyWithImpl(this._self, this._then);

  final _ScanStatusEntity _self;
  final $Res Function(_ScanStatusEntity) _then;

/// Create a copy of ScanStatusEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? scanning = freezed,Object? count = freezed,Object? folderCount = freezed,Object? lastScan = freezed,}) {
  return _then(_ScanStatusEntity(
scanning: freezed == scanning ? _self.scanning : scanning // ignore: cast_nullable_to_non_nullable
as bool?,count: freezed == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int?,folderCount: freezed == folderCount ? _self.folderCount : folderCount // ignore: cast_nullable_to_non_nullable
as int?,lastScan: freezed == lastScan ? _self.lastScan : lastScan // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
