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
