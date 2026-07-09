import 'package:melo_trip/model/response/lyrics/lyrics.dart';

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
  if (sortedStartMs.isEmpty ||
      currentIndex < 0 ||
      currentIndex >= sortedStartMs.length) {
    return 0.0;
  }
  final currentStart = sortedStartMs[currentIndex];
  final isLast = currentIndex == sortedStartMs.length - 1;
  final nextStart = isLast
      ? currentStart + trailingDurationMs
      : sortedStartMs[currentIndex + 1];
  final span = (nextStart - currentStart).clamp(1, 1 << 30);
  return ((positionMs - currentStart) / span).clamp(0.0, 1.0);
}

/// 返回每个 [Cue] 在 [positionMs] 时刻的 0.0–1.0 进度。
///
/// 单个 cue 的进度 = `(positionMs - start) / (end - start)`，clamp 到 [0,1]。
/// 已唱完的 cue 进度为 1.0，未开始的为 0.0。
List<double> cueProgressByStartMs({
  required List<Cue> cues,
  required int positionMs,
}) {
  if (cues.isEmpty) return const [];
  return [
    for (final c in cues)
      ((positionMs - (c.start ?? 0)) /
              (((c.end ?? (c.start ?? 0)) - (c.start ?? 0)).clamp(1, 1 << 30)))
          .clamp(0.0, 1.0),
  ];
}

/// 返回整行在 [positionMs] 时刻的已唱宽度比例（0.0–1.0），用于驱动逐字
/// "从左到右扫过"的渲染分界。
///
/// 按每个 cue 的 [Cue.value] 字符长度加权累加其进度：已唱完的 cue 贡献其
/// 全部字符长度，当前 cue 贡献 `进度 × 字符长度`，未开始的 cue 贡献 0。
/// 这样分界线会沿整行宽度从左推进到右，且当前正在唱的字内部仍能亚像素
/// 过渡，呈现主流逐字歌的左→右扫动效果。比纯按 cue 计数更贴合实际排版宽度
/// （CJK 每字等宽近似成立；Latin 按字符数近似亦可接受）。
double cueLineSweepFraction({
  required List<Cue> cues,
  required int positionMs,
}) {
  if (cues.isEmpty) return 0.0;
  final progress = cueProgressByStartMs(cues: cues, positionMs: positionMs);
  var totalChars = 0;
  var sungChars = 0.0;
  for (var i = 0; i < cues.length; i++) {
    final len = (cues[i].value ?? '').length;
    totalChars += len;
    sungChars += len * progress[i];
  }
  if (totalChars == 0) return 0.0;
  return (sungChars / totalChars).clamp(0.0, 1.0);
}
