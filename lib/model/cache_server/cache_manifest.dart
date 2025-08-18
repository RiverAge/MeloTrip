import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'cache_manifest.freezed.dart';
part 'cache_manifest.g.dart';

@freezed
abstract class CacheManifest with _$CacheManifest {
  const factory CacheManifest({
    @ContentTypeCovert() ContentType? contentType,
    int? contentLength,
    String? lastModified,
    String? contentRange,
  }) = _CacheManifest;

  factory CacheManifest.fromJson(Map<String, dynamic> json) =>
      _$CacheManifestFromJson(json);
}

class ContentTypeCovert implements JsonConverter<ContentType, String> {
  const ContentTypeCovert();

  @override
  ContentType fromJson(String json) {
    return ContentType.parse(json);
  }

  @override
  String toJson(ContentType object) {
    return object.toString();
  }
}
