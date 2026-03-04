int lyricIndexByStartMs({
  required List<int> sortedStartMs,
  required int positionMs,
}) {
  if (sortedStartMs.isEmpty) return -1;
  if (sortedStartMs.first > positionMs) return 0;
  if (sortedStartMs.last < positionMs) return sortedStartMs.length - 1;

  for (var i = 0; i < sortedStartMs.length - 1; i++) {
    if (sortedStartMs[i] <= positionMs && sortedStartMs[i + 1] > positionMs) {
      return i;
    }
  }
  return 0;
}

double lyricLineProgressByStartMs({
  required List<int> sortedStartMs,
  required int currentIndex,
  required int positionMs,
  int trailingDurationMs = 4000,
}) {
  if (sortedStartMs.isEmpty || currentIndex < 0 || currentIndex >= sortedStartMs.length) {
    return 0.0;
  }
  final currentStart = sortedStartMs[currentIndex];
  final isLast = currentIndex == sortedStartMs.length - 1;
  final nextStart = isLast ? currentStart + trailingDurationMs : sortedStartMs[currentIndex + 1];
  final span = (nextStart - currentStart).clamp(1, 1 << 30);
  return ((positionMs - currentStart) / span).clamp(0.0, 1.0);
}
