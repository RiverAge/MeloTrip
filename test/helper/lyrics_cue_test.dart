import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/lyrics_cue.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';

void main() {
  StructuredLyric lyric({
    List<Agent>? agents,
    List<CueLine>? cueLine,
  }) =>
      StructuredLyric(
        lang: 'test',
        agents: agents,
        cueLine: cueLine,
      );

  group('cueLinesByStart', () {
    test('returns empty map when no cueLine', () {
      expect(cueLinesByStart(lyric()), const <int, CueLine>{});
      expect(cueLinesByStart(null), const <int, CueLine>{});
    });

    test('indexes every cueLine by start, regardless of agentId', () {
      // 模拟后会无期：每行一条 cueLine，agentId 可能是 main/voice/group。
      final s = lyric(
        agents: const [
          Agent(id: 'v1', role: 'main'),
          Agent(id: 'v2', role: 'voice'),
          Agent(id: 'v1000', role: 'group'),
        ],
        cueLine: const [
          CueLine(index: 0, start: 0, value: 'lead', agentId: 'v1'),
          CueLine(index: 1, start: 100, value: 'harm', agentId: 'v2'),
          CueLine(index: 2, start: 200, value: 'group', agentId: 'v1000'),
        ],
      );
      final map = cueLinesByStart(s);
      // 关键：和声/合唱行不被过滤，逐字渲染对每行都可用。
      expect(map.length, 3);
      expect(map[0]?.agentId, 'v1');
      expect(map[100]?.agentId, 'v2');
      expect(map[200]?.agentId, 'v1000');
    });

    test('same start with multiple cues prefers main-role agent', () {
      final s = lyric(
        agents: const [
          Agent(id: 'v1', role: 'main'),
          Agent(id: 'v2', role: 'voice'),
        ],
        cueLine: const [
          CueLine(index: 0, start: 0, value: 'harm', agentId: 'v2'),
          CueLine(index: 0, start: 0, value: 'lead', agentId: 'v1'),
        ],
      );
      final map = cueLinesByStart(s);
      expect(map.length, 1);
      expect(map[0]?.agentId, 'v1');
    });

    test('same start without main marker keeps first', () {
      final s = lyric(
        agents: const [Agent(id: 'v1', role: 'voice')],
        cueLine: const [
          CueLine(index: 0, start: 0, value: 'first', agentId: 'v1'),
          CueLine(index: 0, start: 0, value: 'second', agentId: 'v2'),
        ],
      );
      final map = cueLinesByStart(s);
      expect(map.length, 1);
      expect(map[0]?.value, 'first');
    });

    test('skips cueLine with null start', () {
      final s = lyric(
        cueLine: const [
          CueLine(index: 0, start: null, value: 'no-start'),
          CueLine(index: 1, start: 100, value: 'has-start'),
        ],
      );
      expect(cueLinesByStart(s), {100: isA<CueLine>()});
    });
  });
}
