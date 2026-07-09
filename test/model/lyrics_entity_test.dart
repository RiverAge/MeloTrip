import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';

void main() {
  group('Line', () {
    test('parses line with value', () {
      final json = {'start': 1000, 'value': 'Test lyric line'};

      final line = Line.fromJson(json);

      expect(line.start, 1000);
      expect(line.value, 'Test lyric line');
    });

    test('parses line with empty value', () {
      final json = {'start': 2000, 'value': ''};

      final line = Line.fromJson(json);

      expect(line.start, 2000);
      expect(line.value, '');
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

    test('parses enhanced fields (cueLine/agents/kind)', () {
      final json = {
        'kind': 'main',
        'lang': 'zh-hans',
        'synced': true,
        'line': [
          {'start': 12802, 'value': '你若离去 后会无期'},
        ],
        'agents': [
          {'id': 'v1', 'role': 'main', 'name': '徐良'},
          {'id': 'v2', 'role': 'voice'},
        ],
        'cueLine': [
          {
            'index': 0,
            'start': 12802,
            'end': 15654,
            'value': '你若离去 后会无期',
            'agentId': 'v1',
            'cue': [
              {'start': 12802, 'end': 13266, 'byteStart': 0, 'byteEnd': 2, 'value': '你'},
              {'start': 13266, 'end': 13443, 'byteStart': 3, 'byteEnd': 5, 'value': '若'},
            ],
          },
        ],
      };

      final lyric = StructuredLyric.fromJson(json);

      expect(lyric.kind, 'main');
      expect(lyric.agents, isNotNull);
      expect(lyric.agents!.first.id, 'v1');
      expect(lyric.agents!.first.role, 'main');
      expect(lyric.cueLine, isNotNull);
      expect(lyric.cueLine!.first.start, 12802);
      expect(lyric.cueLine!.first.end, 15654);
      expect(lyric.cueLine!.first.agentId, 'v1');
      expect(lyric.cueLine!.first.cue!.first.value, '你');
      expect(lyric.cueLine!.first.cue!.last.value, '若');
    });

    test('parses lyric with null optional fields', () {
      final json = <String, dynamic>{'line': []};

      final lyric = StructuredLyric.fromJson(json);

      expect(lyric.displayArtist, isNull);
      expect(lyric.displayTitle, isNull);
      expect(lyric.lang, isNull);
      expect(lyric.offset, isNull);
      expect(lyric.synced, isNull);
      expect(lyric.cueLine, isNull);
      expect(lyric.agents, isNull);
      expect(lyric.kind, isNull);
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
}
