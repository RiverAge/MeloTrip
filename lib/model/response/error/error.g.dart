// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ErrorEntityImpl _$$ErrorEntityImplFromJson(Map<String, dynamic> json) =>
    _$ErrorEntityImpl(
      code: (json['code'] as num?)?.toInt(),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$$ErrorEntityImplToJson(_$ErrorEntityImpl instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
    };
