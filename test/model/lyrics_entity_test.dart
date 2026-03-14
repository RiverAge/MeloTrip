import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';

void main() {
  group('Line', () {
    test('parses line with value', () {
      final json = {
        'start': 1000,
        'value': 'Test lyric line',
      };

      final line = Line.fromJson(json);

      expect(line.start, 1000);
      expect(line.value, ['Test lyric line']);
    });

    test('parses line with empty value', () {
      final json = {
        'start': 2000,
        'value': '',
      };

      final line = Line.fromJson(json);

      expect(line.start, 2000);
      expect(line.value, ['']);
    });
  });

  group('StructuredLyric', () {
    test('parses structured lyric with lines', () {
      final json = {
        'displayArtist': 'Test Artist',
        'displayTitle': 'Test Song',
        'lang': 'en',
        'offset': 0,
        'synced': true,
        'line': [
          {'start': 1000, 'value': 'Line 1'},
          {'start': 2000, 'value': 'Line 2'},
        ],
      };

      final lyric = StructuredLyric.fromJson(json);

      expect(lyric.displayArtist, 'Test Artist');
      expect(lyric.displayTitle, 'Test Song');
      expect(lyric.lang, 'en');
      expect(lyric.offset, 0);
      expect(lyric.synced, true);
      expect(lyric.line, isNotNull);
      expect(lyric.line?.length, 2);
      expect(lyric.line?.first.start, 1000);
      expect(lyric.line?.last.start, 2000);
    });

    test('parses lyric with null optional fields', () {
      final json = <String, dynamic>{
        'line': [],
      };

      final lyric = StructuredLyric.fromJson(json);

      expect(lyric.displayArtist, isNull);
      expect(lyric.displayTitle, isNull);
      expect(lyric.lang, isNull);
      expect(lyric.offset, isNull);
      expect(lyric.synced, isNull);
    });
  });

  group('LyricsListEntity', () {
    test('parses lyrics list', () {
      final json = {
        'structuredLyrics': [
          {
            'displayArtist': 'Artist 1',
            'displayTitle': 'Song 1',
            'lang': 'en',
            'line': [],
          },
          {
            'displayArtist': 'Artist 2',
            'displayTitle': 'Song 2',
            'lang': 'zh',
            'line': [],
          },
        ],
      };

      final entity = LyricsListEntity.fromJson(json);

      expect(entity.structuredLyrics, isNotNull);
      expect(entity.structuredLyrics?.length, 2);
      expect(entity.structuredLyrics?.first.displayArtist, 'Artist 1');
      expect(entity.structuredLyrics?.last.displayArtist, 'Artist 2');
    });

    test('handles empty lyrics list', () {
      final json = <String, dynamic>{};
      final entity = LyricsListEntity.fromJson(json);

      expect(entity.structuredLyrics, isNull);
    });
  });

  group('LinesConvert', () {
    test('converts lines and merges duplicates', () {
      final converter = const LinesConvert();
      final json = [
        {'start': 1000, 'value': 'Line 1'},
        {'start': 2000, 'value': 'Line 2'},
        {'start': 1000, 'value': 'Line 1 continued'},
      ];

      final lines = converter.fromJson(json);

      expect(lines.length, 2);
      expect(lines.first.start, 1000);
      expect(lines.first.value, ['Line 1', 'Line 1 continued']);
      expect(lines.last.start, 2000);
      expect(lines.last.value, ['Line 2']);
    });

    test('skips lines with null or empty value', () {
      final converter = const LinesConvert();
      final json = [
        {'start': 1000, 'value': 'Valid line'},
        {'start': 2000, 'value': null},
        {'start': 3000, 'value': ''},
      ];

      final lines = converter.fromJson(json);

      expect(lines.length, 1);
      expect(lines.first.start, 1000);
    });

    test('converts lines back to JSON', () {
      final converter = const LinesConvert();
      final lines = [
        const Line(start: 1000, value: ['Line 1']),
        const Line(start: 2000, value: ['Line 2']),
      ];

      final json = converter.toJson(lines);

      expect(json.length, 2);
      expect(json.first['start'], 1000);
      expect(json.last['start'], 2000);
    });
  });

  group('LineValueConvert', () {
    test('converts string to list', () {
      final converter = const LineValueConvert();
      final result = converter.fromJson('Test value');
      expect(result, ['Test value']);
    });

    test('converts list back to string', () {
      final converter = const LineValueConvert();
      final result = converter.toJson(['Line 1', 'Line 2']);
      expect(result, 'Line 1\nLine 2');
    });
  });
}
