// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lyrics.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LyricsListEntity _$LyricsListEntityFromJson(Map<String, dynamic> json) =>
    _LyricsListEntity(
      structuredLyrics: (json['structuredLyrics'] as List<dynamic>?)
          ?.map((e) => StructuredLyric.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LyricsListEntityToJson(_LyricsListEntity instance) =>
    <String, dynamic>{'structuredLyrics': instance.structuredLyrics};

_StructuredLyric _$StructuredLyricFromJson(Map<String, dynamic> json) =>
    _StructuredLyric(
      displayArtist: json['displayArtist'] as String?,
      displayTitle: json['displayTitle'] as String?,
      kind: json['kind'] as String?,
      lang: json['lang'] as String?,
      line: (json['line'] as List<dynamic>?)
          ?.map((e) => Line.fromJson(e as Map<String, dynamic>))
          .toList(),
      agents: (json['agents'] as List<dynamic>?)
          ?.map((e) => Agent.fromJson(e as Map<String, dynamic>))
          .toList(),
      cueLine: (json['cueLine'] as List<dynamic>?)
          ?.map((e) => CueLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      offset: (json['offset'] as num?)?.toInt(),
      synced: json['synced'] as bool?,
    );

Map<String, dynamic> _$StructuredLyricToJson(_StructuredLyric instance) =>
    <String, dynamic>{
      'displayArtist': instance.displayArtist,
      'displayTitle': instance.displayTitle,
      'kind': instance.kind,
      'lang': instance.lang,
      'line': instance.line,
      'agents': instance.agents,
      'cueLine': instance.cueLine,
      'offset': instance.offset,
      'synced': instance.synced,
    };

_Line _$LineFromJson(Map<String, dynamic> json) => _Line(
  start: (json['start'] as num?)?.toInt(),
  value: json['value'] as String?,
);

Map<String, dynamic> _$LineToJson(_Line instance) => <String, dynamic>{
  'start': instance.start,
  'value': instance.value,
};

_Cue _$CueFromJson(Map<String, dynamic> json) => _Cue(
  start: (json['start'] as num?)?.toInt(),
  end: (json['end'] as num?)?.toInt(),
  byteStart: (json['byteStart'] as num?)?.toInt(),
  byteEnd: (json['byteEnd'] as num?)?.toInt(),
  value: json['value'] as String?,
);

Map<String, dynamic> _$CueToJson(_Cue instance) => <String, dynamic>{
  'start': instance.start,
  'end': instance.end,
  'byteStart': instance.byteStart,
  'byteEnd': instance.byteEnd,
  'value': instance.value,
};

_CueLine _$CueLineFromJson(Map<String, dynamic> json) => _CueLine(
  index: (json['index'] as num?)?.toInt(),
  start: (json['start'] as num?)?.toInt(),
  end: (json['end'] as num?)?.toInt(),
  value: json['value'] as String?,
  agentId: json['agentId'] as String?,
  cue: (json['cue'] as List<dynamic>?)
      ?.map((e) => Cue.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CueLineToJson(_CueLine instance) => <String, dynamic>{
  'index': instance.index,
  'start': instance.start,
  'end': instance.end,
  'value': instance.value,
  'agentId': instance.agentId,
  'cue': instance.cue,
};

_Agent _$AgentFromJson(Map<String, dynamic> json) => _Agent(
  id: json['id'] as String?,
  role: json['role'] as String?,
  name: json['name'] as String?,
);

Map<String, dynamic> _$AgentToJson(_Agent instance) => <String, dynamic>{
  'id': instance.id,
  'role': instance.role,
  'name': instance.name,
};
