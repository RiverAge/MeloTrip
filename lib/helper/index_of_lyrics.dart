import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/helper/lyrics_timeline.dart';

int indexOfLyrics({
  required List<Line> sortedLyrics,
  required Duration position,
}) {
  final starts = sortedLyrics.map((e) => e.start ?? 0).toList(growable: false);
  return lyricIndexByStartMs(
    sortedStartMs: starts,
    positionMs: position.inMilliseconds,
  );
}
