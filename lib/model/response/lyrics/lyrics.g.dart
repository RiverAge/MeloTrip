// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LyricsListEntityImpl _$$LyricsListEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$LyricsListEntityImpl(
      structuredLyrics: (json['structuredLyrics'] as List<dynamic>?)
          ?.map((e) => StructuredLyric.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LyricsListEntityImplToJson(
        _$LyricsListEntityImpl instance) =>
    <String, dynamic>{
      'structuredLyrics': instance.structuredLyrics,
    };

_$StructuredLyricImpl _$$StructuredLyricImplFromJson(
        Map<String, dynamic> json) =>
    _$StructuredLyricImpl(
      displayArtist: json['displayArtist'] as String?,
      displayTitle: json['displayTitle'] as String?,
      lang: json['lang'] as String?,
      line: (json['line'] as List<dynamic>?)
          ?.map((e) => Line.fromJson(e as Map<String, dynamic>))
          .toList(),
      offset: (json['offset'] as num?)?.toInt(),
      synced: json['synced'] as bool?,
    );

Map<String, dynamic> _$$StructuredLyricImplToJson(
        _$StructuredLyricImpl instance) =>
    <String, dynamic>{
      'displayArtist': instance.displayArtist,
      'displayTitle': instance.displayTitle,
      'lang': instance.lang,
      'line': instance.line,
      'offset': instance.offset,
      'synced': instance.synced,
    };

_$LineImpl _$$LineImplFromJson(Map<String, dynamic> json) => _$LineImpl(
      start: (json['start'] as num?)?.toInt(),
      value: json['value'] as String?,
    );

Map<String, dynamic> _$$LineImplToJson(_$LineImpl instance) =>
    <String, dynamic>{
      'start': instance.start,
      'value': instance.value,
    };
