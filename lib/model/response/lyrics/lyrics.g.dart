// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LyricsListEntity _$LyricsListEntityFromJson(Map<String, dynamic> json) =>
    _LyricsListEntity(
      structuredLyrics:
          (json['structuredLyrics'] as List<dynamic>?)
              ?.map((e) => StructuredLyric.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$LyricsListEntityToJson(_LyricsListEntity instance) =>
    <String, dynamic>{'structuredLyrics': instance.structuredLyrics};

_StructuredLyric _$StructuredLyricFromJson(Map<String, dynamic> json) =>
    _StructuredLyric(
      displayArtist: json['displayArtist'] as String?,
      displayTitle: json['displayTitle'] as String?,
      lang: json['lang'] as String?,
      line: _$JsonConverterFromJson<List<dynamic>, List<Line>>(
        json['line'],
        const LinesConvert().fromJson,
      ),
      offset: (json['offset'] as num?)?.toInt(),
      synced: json['synced'] as bool?,
    );

Map<String, dynamic> _$StructuredLyricToJson(_StructuredLyric instance) =>
    <String, dynamic>{
      'displayArtist': instance.displayArtist,
      'displayTitle': instance.displayTitle,
      'lang': instance.lang,
      'line': _$JsonConverterToJson<List<dynamic>, List<Line>>(
        instance.line,
        const LinesConvert().toJson,
      ),
      'offset': instance.offset,
      'synced': instance.synced,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_Line _$LineFromJson(Map<String, dynamic> json) => _Line(
  start: (json['start'] as num?)?.toInt(),
  value: json['value'] as String?,
);

Map<String, dynamic> _$LineToJson(_Line instance) => <String, dynamic>{
  'start': instance.start,
  'value': instance.value,
};
