part of 'index.dart';

int indexOfLyrics({
  required List<Line> sortedLyrics,
  required Duration position,
}) {
  if (sortedLyrics.isEmpty) {
    return -1;
  }
  if ((sortedLyrics.first.start ?? 0) > position.inMilliseconds) {
    return 0;
  }

  if ((sortedLyrics.last.start ?? 0) < position.inMilliseconds) {
    return sortedLyrics.length - 1;
  }

  var ret = -1;
  for (var i = 0; i < sortedLyrics.length - 1; i++) {
    if ((sortedLyrics[i].start ?? 0) <= position.inMilliseconds &&
        (sortedLyrics[i + 1].start ?? 0) > position.inMilliseconds) {
      ret = i;
      break;
    }
  }
  return ret;
}
