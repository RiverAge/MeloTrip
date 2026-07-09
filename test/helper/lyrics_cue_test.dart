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

  group('leadCueLines', () {
    test('returns empty when no cueLine', () {
      expect(leadCueLines(lyric()), const <CueLine>[]);
      expect(leadCueLines(null), const <CueLine>[]);
    });

    test('returns all when no agent is marked main', () {
      final s = lyric(
        agents: const [Agent(id: 'v1', role: 'voice')],
        cueLine: const [
          CueLine(index: 0, start: 0, value: 'a', agentId: 'v1'),
          CueLine(index: 1, start: 100, value: 'b', agentId: 'v2'),
        ],
      );
      expect(leadCueLines(s).length, 2);
    });

    test('filters to main-agent cueLines', () {
      final s = lyric(
        agents: const [
          Agent(id: 'v1', role: 'main'),
          Agent(id: 'v2', role: 'voice'),
        ],
        cueLine: const [
          CueLine(index: 0, start: 0, value: 'lead', agentId: 'v1'),
          CueLine(index: 0, start: 0, value: 'harm', agentId: 'v2'),
          CueLine(index: 1, start: 100, value: 'lead2', agentId: 'v1'),
        ],
      );
      final lead = leadCueLines(s);
      expect(lead.length, 2);
      expect(lead.every((c) => c.agentId == 'v1'), isTrue);
    });

    test('keeps cueLines with null/empty agentId', () {
      final s = lyric(
        agents: const [Agent(id: 'v1', role: 'main')],
        cueLine: const [
          CueLine(index: 0, start: 0, value: 'lead', agentId: 'v1'),
          CueLine(index: 0, start: 0, value: 'unspecified', agentId: null),
          CueLine(index: 0, start: 0, value: 'blank', agentId: ''),
        ],
      );
      // v1 + null + blank 都保留；只过滤掉非 main 的明确 agentId
      expect(leadCueLines(s).length, 3);
    });
  });
}
