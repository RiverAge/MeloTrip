// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ErrorEntity _$ErrorEntityFromJson(Map<String, dynamic> json) => _ErrorEntity(
  code: (json['code'] as num?)?.toInt(),
  message: json['message'] as String?,
);

Map<String, dynamic> _$ErrorEntityToJson(_ErrorEntity instance) =>
    <String, dynamic>{'code': instance.code, 'message': instance.message};
