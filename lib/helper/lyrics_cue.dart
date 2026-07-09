import 'package:melo_trip/model/response/lyrics/lyrics.dart';

/// 返回主唱（`role == main`）对应的 [CueLine] 列表。
///
/// 多音轨歌词里，`agents` 标注了每条 `cueLine` 的演唱者。逐字渲染默认只跟随主唱。
/// 当没有任何 agent 被标记为 `main`（例如无 enhanced 或服务器未标注）时，
/// 回退为返回全部 `cueLine`，保证功能仍可用。
List<CueLine> leadCueLines(StructuredLyric? lyric) {
  final all = lyric?.cueLine ?? const <CueLine>[];
  if (all.isEmpty) return const <CueLine>[];

  final agents = lyric?.agents ?? const <Agent>[];
  final leadIds = agents
      .where((a) => a.role == 'main')
      .map((a) => a.id)
      .whereType<String>()
      .where((id) => id != '')
      .toSet();

  if (leadIds.isEmpty) return all;
  return all
      .where((c) => c.agentId == null || c.agentId == '' || leadIds.contains(c.agentId))
      .toList();
}
