import 'package:melo_trip/model/response/lyrics/lyrics.dart';

/// 构建按行起始时间（毫秒）索引的逐字 [CueLine] 映射，供逐字渲染查表。
///
/// Navidrome 的逐字结构里，每条 `cueLine` 对应一行歌词，`agentId` 仅标注
/// 该行的演唱者（主唱/和声/合唱），并非"是否显示"。因此逐字渲染应采用每行
/// 对应的那条 cueLine，而非按 agent 过滤掉整行。
///
/// 当同一 `start` 存在多条 cueLine（多音轨叠加）时，优先选 `role == main`
/// 的 agent 对应的条目；若无 main 标记则取首条。这样保证和声/合唱行也能逐字，
/// 而主唱叠加时跟随主唱。
Map<int, CueLine> cueLinesByStart(StructuredLyric? lyric) {
  final all = lyric?.cueLine ?? const <CueLine>[];
  if (all.isEmpty) return const <int, CueLine>{};

  final agents = lyric?.agents ?? const <Agent>[];
  final mainIds = agents
      .where((a) => a.role == 'main')
      .map((a) => a.id)
      .whereType<String>()
      .where((id) => id != '')
      .toSet();

  final map = <int, CueLine>{};
  for (final c in all) {
    final start = c.start;
    if (start == null) continue;
    final existing = map[start];
    // 同 start 多条：已有 main 轨则保留，否则优先 main 轨覆盖、最后回退首条。
    if (existing == null) {
      map[start] = c;
    } else if (mainIds.contains(c.agentId) &&
        !mainIds.contains(existing.agentId)) {
      map[start] = c;
    }
  }
  return map;
}

/// 从一组 [StructuredLyric] 中按 [kind] 选条目，按行起始时间（毫秒）索引其
/// `line`，供译文/注音按行配对查表。译文/注音条目的行 `start` 是原文行
/// `start` 的子集（标题行通常无译文），缺失行查表返回 null，渲染时自然跳过。
///
/// kind 取 OpenSubsonic 规范值：`translation`（译文）、`transliteration`
///（注音/拼音）。条目可能缺失（如这首歌没有注音），此时返回空 map。
Map<int, Line> linesByStartForKind(
  List<StructuredLyric>? all,
  String kind,
) {
  if (all == null || all.isEmpty) return const <int, Line>{};
  final map = <int, Line>{};
  for (final s in all) {
    if (s.kind != kind) continue;
    for (final line in s.line ?? const <Line>[]) {
      final start = line.start;
      if (start == null) continue;
      // 同 start 多条译文条目：保留首条，避免后到者覆盖。
      map.putIfAbsent(start, () => line);
    }
  }
  return map;
}

/// 译文行（kind == 'translation'）按 start 索引。
Map<int, Line> translationLinesByStart(List<StructuredLyric>? all) =>
    linesByStartForKind(all, 'translation');

/// 注音行（kind == 'transliteration'）按 start 索引。
Map<int, Line> transliterationLinesByStart(List<StructuredLyric>? all) =>
    linesByStartForKind(all, 'transliteration');
