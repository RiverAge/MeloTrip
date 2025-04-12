// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ErrorEntity {

 int? get code; String? get message;
/// Create a copy of ErrorEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ErrorEntityCopyWith<ErrorEntity> get copyWith => _$ErrorEntityCopyWithImpl<ErrorEntity>(this as ErrorEntity, _$identity);

  /// Serializes this ErrorEntity to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ErrorEntity&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message);

@override
String toString() {
  return 'ErrorEntity(code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class $ErrorEntityCopyWith<$Res>  {
  factory $ErrorEntityCopyWith(ErrorEntity value, $Res Function(ErrorEntity) _then) = _$ErrorEntityCopyWithImpl;
@useResult
$Res call({
 int? code, String? message
});




}
/// @nodoc
class _$ErrorEntityCopyWithImpl<$Res>
    implements $ErrorEntityCopyWith<$Res> {
  _$ErrorEntityCopyWithImpl(this._self, this._then);

  final ErrorEntity _self;
  final $Res Function(ErrorEntity) _then;

/// Create a copy of ErrorEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? code = freezed,Object? message = freezed,}) {
  return _then(_self.copyWith(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _ErrorEntity implements ErrorEntity {
  const _ErrorEntity({this.code, this.message});
  factory _ErrorEntity.fromJson(Map<String, dynamic> json) => _$ErrorEntityFromJson(json);

@override final  int? code;
@override final  String? message;

/// Create a copy of ErrorEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorEntityCopyWith<_ErrorEntity> get copyWith => __$ErrorEntityCopyWithImpl<_ErrorEntity>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ErrorEntityToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ErrorEntity&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,code,message);

@override
String toString() {
  return 'ErrorEntity(code: $code, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorEntityCopyWith<$Res> implements $ErrorEntityCopyWith<$Res> {
  factory _$ErrorEntityCopyWith(_ErrorEntity value, $Res Function(_ErrorEntity) _then) = __$ErrorEntityCopyWithImpl;
@override @useResult
$Res call({
 int? code, String? message
});




}
/// @nodoc
class __$ErrorEntityCopyWithImpl<$Res>
    implements _$ErrorEntityCopyWith<$Res> {
  __$ErrorEntityCopyWithImpl(this._self, this._then);

  final _ErrorEntity _self;
  final $Res Function(_ErrorEntity) _then;

/// Create a copy of ErrorEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? code = freezed,Object? message = freezed,}) {
  return _then(_ErrorEntity(
code: freezed == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as int?,message: freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
