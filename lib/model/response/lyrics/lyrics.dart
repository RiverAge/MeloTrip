import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyrics.freezed.dart';
part 'lyrics.g.dart';

@freezed
abstract class LyricsListEntity with _$LyricsListEntity {
  const factory LyricsListEntity({List<StructuredLyric>? structuredLyrics}) =
      _LyricsListEntity;

  factory LyricsListEntity.fromJson(Map<String, dynamic> json) =>
      _$LyricsListEntityFromJson(json);
}

@freezed
abstract class StructuredLyric with _$StructuredLyric {
  const factory StructuredLyric({
    String? displayArtist,
    String? displayTitle,
    String? kind,
    String? lang,
    List<Line>? line,
    List<Agent>? agents,
    List<CueLine>? cueLine,
    int? offset,
    bool? synced,
  }) = _StructuredLyric;

  factory StructuredLyric.fromJson(Map<String, dynamic> json) =>
      _$StructuredLyricFromJson(json);
}

@freezed
abstract class Line with _$Line {
  const factory Line({int? start, String? value}) = _Line;

  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);
}

@freezed
abstract class Cue with _$Cue {
  const factory Cue({
    int? start,
    int? end,
    int? byteStart,
    int? byteEnd,
    String? value,
  }) = _Cue;

  factory Cue.fromJson(Map<String, dynamic> json) => _$CueFromJson(json);
}

@freezed
abstract class CueLine with _$CueLine {
  const factory CueLine({
    int? index,
    int? start,
    int? end,
    String? value,
    String? agentId,
    List<Cue>? cue,
  }) = _CueLine;

  factory CueLine.fromJson(Map<String, dynamic> json) =>
      _$CueLineFromJson(json);
}

@freezed
abstract class Agent with _$Agent {
  const factory Agent({String? id, String? role, String? name}) = _Agent;

  factory Agent.fromJson(Map<String, dynamic> json) => _$AgentFromJson(json);
}
