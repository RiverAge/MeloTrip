import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyrics.freezed.dart';
part 'lyrics.g.dart';

@freezed
class LyricsListEntity with _$LyricsListEntity {
  const factory LyricsListEntity({
    List<StructuredLyric>? structuredLyrics,
  }) = _LyricsListEntity;

  factory LyricsListEntity.fromJson(Map<String, dynamic> json) =>
      _$LyricsListEntityFromJson(json);
}

@freezed
class StructuredLyric with _$StructuredLyric {
  const factory StructuredLyric({
    String? displayArtist,
    String? displayTitle,
    String? lang,
    List<Line>? line,
    int? offset,
    bool? synced,
  }) = _StructuredLyric;

  factory StructuredLyric.fromJson(Map<String, dynamic> json) =>
      _$StructuredLyricFromJson(json);
}

@freezed
class Line with _$Line {
  const factory Line({
    int? start,
    String? value,
  }) = _Line;

  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);
}
