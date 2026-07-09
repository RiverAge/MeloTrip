import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';

void main() {
  group('lyrics model (standard OpenSubsonic)', () {
    test('line.value is a plain string, no merging', () {
      final lyric = StructuredLyric.fromJson({
        'lang': 'zh-hans',
        'line': [
          {'start': 1000, 'value': 'A'},
          {'start': 1000, 'value': 'B'},
          {'start': 3000, 'value': 'C'},
        ],
      });

      expect(lyric.line, isNotNull);
      // 标准 OpenSubsonic：每个 line 独立，不按 start 合并。
      expect(lyric.line, hasLength(3));
      expect(lyric.line![0].start, 1000);
      expect(lyric.line![0].value, 'A');
      expect(lyric.line![1].start, 1000);
      expect(lyric.line![1].value, 'B');
      expect(lyric.line![2].start, 3000);
      expect(lyric.line![2].value, 'C');
    });

    test('line.toJson round-trips value as string', () {
      const line = Line(start: 10, value: 'L1');
      final json = line.toJson();

      expect(json['start'], 10);
      expect(json['value'], 'L1');
    });
  });
}
