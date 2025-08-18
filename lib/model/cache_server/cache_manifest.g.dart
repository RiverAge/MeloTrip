// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_manifest.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CacheManifest _$CacheManifestFromJson(Map<String, dynamic> json) =>
    _CacheManifest(
      contentType: _$JsonConverterFromJson<String, ContentType>(
        json['contentType'],
        const ContentTypeCovert().fromJson,
      ),
      contentLength: (json['contentLength'] as num?)?.toInt(),
      lastModified: json['lastModified'] as String?,
      contentRange: json['contentRange'] as String?,
    );

Map<String, dynamic> _$CacheManifestToJson(_CacheManifest instance) =>
    <String, dynamic>{
      'contentType': _$JsonConverterToJson<String, ContentType>(
        instance.contentType,
        const ContentTypeCovert().toJson,
      ),
      'contentLength': instance.contentLength,
      'lastModified': instance.lastModified,
      'contentRange': instance.contentRange,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
