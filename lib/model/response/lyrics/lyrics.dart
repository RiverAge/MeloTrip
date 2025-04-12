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
    String? lang,
    @LinesConvert() List<Line>? line,
    int? offset,
    bool? synced,
  }) = _StructuredLyric;

  factory StructuredLyric.fromJson(Map<String, dynamic> json) =>
      _$StructuredLyricFromJson(json);

  // factory StructuredLyric.fromJson(Map<String, dynamic> json) {
  //   // 检查 line 字段是否为 List，并进行类型过滤
  //   final rawLines =
  //       (json['line'] as List<dynamic>? ?? [])
  //           .whereType<Map<String, dynamic>>(); // 确保类型安全
  //   final List<Map> mergedMap = [];

  //   for (var item in rawLines) {
  //     final idx = mergedMap.indexWhere((e) => e['start'] == item['start']);
  //     if (idx == -1) {
  //       mergedMap.add(item);
  //     } else {
  //       mergedMap[idx]['value'] = '${mergedMap[idx]['value']} ${item['value']}';
  //     }
  //   }

  //   return _$StructuredLyricFromJson({...json, 'line': mergedMap});
  // }
}

@freezed
abstract class Line with _$Line {
  const factory Line({int? start, String? value}) = _Line;

  factory Line.fromJson(Map<String, dynamic> json) => _$LineFromJson(json);
}

class LinesConvert implements JsonConverter<List<Line>, List<dynamic>> {
  const LinesConvert();

  @override
  List<Line> fromJson(List<dynamic> json) {
    // 检查 line 字段是否为 List，并进行类型过滤
    final rawLines = json.whereType<Map<String, dynamic>>(); // 确保类型安全
    final List<Line> mergedMap = [];

    for (var item in rawLines) {
      final idx = mergedMap.indexWhere((e) => e.start == item['start']);
      if (idx == -1) {
        mergedMap.add(Line.fromJson(item));
      } else {
        mergedMap[idx] = Line(
          start: mergedMap[idx].start,
          value: '${mergedMap[idx].start} ${item['value']}',
        );
      }
    }
    return mergedMap;
  }

  @override
  List<Map> toJson(List<Line> lines) {
    return lines.map((e) => e.toJson()).toList();
  }
}
