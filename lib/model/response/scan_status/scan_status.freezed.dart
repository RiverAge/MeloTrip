// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScanStatusEntity _$ScanStatusEntityFromJson(Map<String, dynamic> json) {
  return _ScanStatusEntity.fromJson(json);
}

/// @nodoc
mixin _$ScanStatusEntity {
  bool? get scanning => throw _privateConstructorUsedError;
  int? get count => throw _privateConstructorUsedError;
  int? get folderCount => throw _privateConstructorUsedError;
  DateTime? get lastScan => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ScanStatusEntityCopyWith<ScanStatusEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanStatusEntityCopyWith<$Res> {
  factory $ScanStatusEntityCopyWith(
          ScanStatusEntity value, $Res Function(ScanStatusEntity) then) =
      _$ScanStatusEntityCopyWithImpl<$Res, ScanStatusEntity>;
  @useResult
  $Res call({bool? scanning, int? count, int? folderCount, DateTime? lastScan});
}

/// @nodoc
class _$ScanStatusEntityCopyWithImpl<$Res, $Val extends ScanStatusEntity>
    implements $ScanStatusEntityCopyWith<$Res> {
  _$ScanStatusEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scanning = freezed,
    Object? count = freezed,
    Object? folderCount = freezed,
    Object? lastScan = freezed,
  }) {
    return _then(_value.copyWith(
      scanning: freezed == scanning
          ? _value.scanning
          : scanning // ignore: cast_nullable_to_non_nullable
              as bool?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      folderCount: freezed == folderCount
          ? _value.folderCount
          : folderCount // ignore: cast_nullable_to_non_nullable
              as int?,
      lastScan: freezed == lastScan
          ? _value.lastScan
          : lastScan // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScanStatusEntityImplCopyWith<$Res>
    implements $ScanStatusEntityCopyWith<$Res> {
  factory _$$ScanStatusEntityImplCopyWith(_$ScanStatusEntityImpl value,
          $Res Function(_$ScanStatusEntityImpl) then) =
      __$$ScanStatusEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool? scanning, int? count, int? folderCount, DateTime? lastScan});
}

/// @nodoc
class __$$ScanStatusEntityImplCopyWithImpl<$Res>
    extends _$ScanStatusEntityCopyWithImpl<$Res, _$ScanStatusEntityImpl>
    implements _$$ScanStatusEntityImplCopyWith<$Res> {
  __$$ScanStatusEntityImplCopyWithImpl(_$ScanStatusEntityImpl _value,
      $Res Function(_$ScanStatusEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? scanning = freezed,
    Object? count = freezed,
    Object? folderCount = freezed,
    Object? lastScan = freezed,
  }) {
    return _then(_$ScanStatusEntityImpl(
      scanning: freezed == scanning
          ? _value.scanning
          : scanning // ignore: cast_nullable_to_non_nullable
              as bool?,
      count: freezed == count
          ? _value.count
          : count // ignore: cast_nullable_to_non_nullable
              as int?,
      folderCount: freezed == folderCount
          ? _value.folderCount
          : folderCount // ignore: cast_nullable_to_non_nullable
              as int?,
      lastScan: freezed == lastScan
          ? _value.lastScan
          : lastScan // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanStatusEntityImpl implements _ScanStatusEntity {
  const _$ScanStatusEntityImpl(
      {this.scanning, this.count, this.folderCount, this.lastScan});

  factory _$ScanStatusEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanStatusEntityImplFromJson(json);

  @override
  final bool? scanning;
  @override
  final int? count;
  @override
  final int? folderCount;
  @override
  final DateTime? lastScan;

  @override
  String toString() {
    return 'ScanStatusEntity(scanning: $scanning, count: $count, folderCount: $folderCount, lastScan: $lastScan)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanStatusEntityImpl &&
            (identical(other.scanning, scanning) ||
                other.scanning == scanning) &&
            (identical(other.count, count) || other.count == count) &&
            (identical(other.folderCount, folderCount) ||
                other.folderCount == folderCount) &&
            (identical(other.lastScan, lastScan) ||
                other.lastScan == lastScan));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, scanning, count, folderCount, lastScan);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanStatusEntityImplCopyWith<_$ScanStatusEntityImpl> get copyWith =>
      __$$ScanStatusEntityImplCopyWithImpl<_$ScanStatusEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanStatusEntityImplToJson(
      this,
    );
  }
}

abstract class _ScanStatusEntity implements ScanStatusEntity {
  const factory _ScanStatusEntity(
      {final bool? scanning,
      final int? count,
      final int? folderCount,
      final DateTime? lastScan}) = _$ScanStatusEntityImpl;

  factory _ScanStatusEntity.fromJson(Map<String, dynamic> json) =
      _$ScanStatusEntityImpl.fromJson;

  @override
  bool? get scanning;
  @override
  int? get count;
  @override
  int? get folderCount;
  @override
  DateTime? get lastScan;
  @override
  @JsonKey(ignore: true)
  _$$ScanStatusEntityImplCopyWith<_$ScanStatusEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
