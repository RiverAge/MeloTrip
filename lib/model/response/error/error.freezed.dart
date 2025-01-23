// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ErrorEntity _$ErrorEntityFromJson(Map<String, dynamic> json) {
  return _ErrorEntity.fromJson(json);
}

/// @nodoc
mixin _$ErrorEntity {
  int? get code => throw _privateConstructorUsedError;
  String? get message => throw _privateConstructorUsedError;

  /// Serializes this ErrorEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ErrorEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ErrorEntityCopyWith<ErrorEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ErrorEntityCopyWith<$Res> {
  factory $ErrorEntityCopyWith(
          ErrorEntity value, $Res Function(ErrorEntity) then) =
      _$ErrorEntityCopyWithImpl<$Res, ErrorEntity>;
  @useResult
  $Res call({int? code, String? message});
}

/// @nodoc
class _$ErrorEntityCopyWithImpl<$Res, $Val extends ErrorEntity>
    implements $ErrorEntityCopyWith<$Res> {
  _$ErrorEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ErrorEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? message = freezed,
  }) {
    return _then(_value.copyWith(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ErrorEntityImplCopyWith<$Res>
    implements $ErrorEntityCopyWith<$Res> {
  factory _$$ErrorEntityImplCopyWith(
          _$ErrorEntityImpl value, $Res Function(_$ErrorEntityImpl) then) =
      __$$ErrorEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? code, String? message});
}

/// @nodoc
class __$$ErrorEntityImplCopyWithImpl<$Res>
    extends _$ErrorEntityCopyWithImpl<$Res, _$ErrorEntityImpl>
    implements _$$ErrorEntityImplCopyWith<$Res> {
  __$$ErrorEntityImplCopyWithImpl(
      _$ErrorEntityImpl _value, $Res Function(_$ErrorEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of ErrorEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? code = freezed,
    Object? message = freezed,
  }) {
    return _then(_$ErrorEntityImpl(
      code: freezed == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int?,
      message: freezed == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ErrorEntityImpl implements _ErrorEntity {
  const _$ErrorEntityImpl({this.code, this.message});

  factory _$ErrorEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ErrorEntityImplFromJson(json);

  @override
  final int? code;
  @override
  final String? message;

  @override
  String toString() {
    return 'ErrorEntity(code: $code, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorEntityImpl &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, code, message);

  /// Create a copy of ErrorEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorEntityImplCopyWith<_$ErrorEntityImpl> get copyWith =>
      __$$ErrorEntityImplCopyWithImpl<_$ErrorEntityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ErrorEntityImplToJson(
      this,
    );
  }
}

abstract class _ErrorEntity implements ErrorEntity {
  const factory _ErrorEntity({final int? code, final String? message}) =
      _$ErrorEntityImpl;

  factory _ErrorEntity.fromJson(Map<String, dynamic> json) =
      _$ErrorEntityImpl.fromJson;

  @override
  int? get code;
  @override
  String? get message;

  /// Create a copy of ErrorEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorEntityImplCopyWith<_$ErrorEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
