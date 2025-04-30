import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lyrics.g.dart';

@riverpod
Future<SubsonicResponse?> lyrics(Ref ref, String? songId) async {
  if (songId == null) return null;
  final res = await Http.get<Map<String, dynamic>>(
    '/rest/getLyricsBySongId',
    queryParameters: {'id': songId},
  );
  final data = res?.data;
  if (data == null) return null;
  return SubsonicResponse.fromJson(data);
}

@riverpod
String? lyricsOfLine(Ref ref, SubsonicResponse lyrics, Duration position) {
  final structuredLyrics =
      lyrics.subsonicResponse?.lyricsList?.structuredLyrics;
  if (structuredLyrics == null || structuredLyrics.isEmpty) {
    return null;
  }
  final lines = structuredLyrics[0].line;
  if (lines == null || structuredLyrics.isEmpty) {
    return null;
  }

  int currentLineIdx = lines.indexWhere(
    (e) => (e.start ?? -1) > position.inMilliseconds,
  );
  if (currentLineIdx == -1) {
    return '';
  }
  currentLineIdx = currentLineIdx == 0 ? 1 : currentLineIdx;
  return lines[currentLineIdx - 1].value ?? '';
}
