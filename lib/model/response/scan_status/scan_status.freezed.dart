// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
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
