import 'dart:collection';

import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';

SubsonicResponse mergePreferredStructuredLyrics(SubsonicResponse response) {
  final structuredLyrics =
      response.subsonicResponse?.lyricsList?.structuredLyrics;

  if (structuredLyrics == null || structuredLyrics.isEmpty) {
    return response;
  }

  final groups = <String, List<StructuredLyric>>{};
  for (final lyric in structuredLyrics) {
    final lang = lyric.lang ?? '';
    final source = lang.split('-').last;
    groups.putIfAbsent(source, () => <StructuredLyric>[]).add(lyric);
  }

  String? bestSource;
  var maxScore = -1;

  for (final entry in groups.entries) {
    var score = 0;
    final seenTypes = <String>{};
    for (final item in entry.value) {
      final type = _lyricType(item.lang);
      if (!seenTypes.add(type)) continue;
      if (type.contains('ori')) {
        score += 10;
      } else if (type.contains('zho')) {
        score += 5;
      } else if (type.contains('latn')) {
        score += 2;
      }
    }
    if (score > maxScore) {
      maxScore = score;
      bestSource = entry.key;
    }
  }

  final bestLyricsList = groups[bestSource] ?? const <StructuredLyric>[];
  if (bestLyricsList.isEmpty) return response;

  final sortedLyrics = <StructuredLyric>[...bestLyricsList]
    ..sort(
      (left, right) =>
          _lyricPriority(left.lang).compareTo(_lyricPriority(right.lang)),
    );

  final mergedMap = <int, List<String>>{};
  for (final structuredLyric in sortedLyrics) {
    final langType = _lyricType(structuredLyric.lang);
    if (langType.startsWith('latn')) continue;

    for (final line in structuredLyric.line ?? const <Line>[]) {
      final start = line.start ?? 0;
      mergedMap.putIfAbsent(start, () => <String>[]);
      mergedMap[start]!.addAll(line.value ?? const <String>[]);
    }
  }

  final finalLines = mergedMap.entries
      .map((entry) => Line(start: entry.key, value: entry.value))
      .toList()
    ..sort((left, right) => (left.start ?? 0).compareTo(right.start ?? 0));

  final template = sortedLyrics.first;
  final finalStructuredLyric = template.copyWith(
    lang: bestSource,
    line: finalLines,
  );

  return response.copyWith(
    subsonicResponse: response.subsonicResponse?.copyWith(
      lyricsList: response.subsonicResponse?.lyricsList?.copyWith(
        structuredLyrics: <StructuredLyric>[finalStructuredLyric],
      ),
    ),
  );
}

String _lyricType(String? lang) {
  return lang?.split('-').firstOrNull?.toLowerCase() ?? '';
}

int _lyricPriority(String? lang) {
  final type = _lyricType(lang);
  if (type.startsWith('ori')) return 0;
  if (type.startsWith('zho') || type.startsWith('trans')) return 1;
  if (type.startsWith('latn')) return 2;
  return 3;
}
