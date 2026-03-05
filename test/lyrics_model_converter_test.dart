import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';

void main() {
  group('lyrics model converters', () {
    test('LinesConvert merges same start and skips empty values', () {
      final lyric = StructuredLyric.fromJson({
        'lang': 'ori-Test',
        'line': [
          {'start': 1000, 'value': 'A'},
          {'start': 1000, 'value': 'B'},
          {'start': 2000, 'value': ''},
          {'start': 3000, 'value': 'C'},
          {'start': 4000, 'value': null},
          'invalid-item',
        ],
      });

      expect(lyric.line, isNotNull);
      expect(lyric.line, hasLength(2));
      expect(lyric.line![0].start, 1000);
      expect(lyric.line![0].value, ['A', 'B']);
      expect(lyric.line![1].start, 3000);
      expect(lyric.line![1].value, ['C']);
    });

    test('LineValueConvert joins values with newline in toJson', () {
      const line = Line(start: 10, value: ['L1', 'L2']);
      final json = line.toJson();

      expect(json['start'], 10);
      expect(json['value'], 'L1\nL2');
    });
  });
}
