import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/index_of_lyrics.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';

void main() {
  group('indexOfLyrics', () {
    Line createLine(int startMs) {
      return Line(
        start: startMs,
        value: ['Lyric $startMs'],
      );
    }

    test('returns correct index for position in middle of lyrics', () {
      final lyrics = [
        createLine(0),
        createLine(5000),
        createLine(10000),
        createLine(15000),
      ];

      final result = indexOfLyrics(
        sortedLyrics: lyrics,
        position: const Duration(milliseconds: 7000),
      );

      expect(result, equals(1));
    });

    test('returns 0 for position at start', () {
      final lyrics = [
        createLine(0),
        createLine(5000),
      ];

      final result = indexOfLyrics(
        sortedLyrics: lyrics,
        position: const Duration(milliseconds: 0),
      );

      expect(result, equals(0));
    });

    test('returns last index for position after all lyrics', () {
      final lyrics = [
        createLine(0),
        createLine(5000),
        createLine(10000),
      ];

      final result = indexOfLyrics(
        sortedLyrics: lyrics,
        position: const Duration(milliseconds: 15000),
      );

      expect(result, equals(2));
    });

    test('handles empty lyrics list', () {
      final result = indexOfLyrics(
        sortedLyrics: [],
        position: const Duration(milliseconds: 5000),
      );

      expect(result, equals(-1));
    });

    test('works with Duration converted to milliseconds', () {
      final lyrics = [
        createLine(1000),
        createLine(2000),
        createLine(3000),
      ];

      final result1 = indexOfLyrics(
        sortedLyrics: lyrics,
        position: const Duration(milliseconds: 1500),
      );

      final result2 = indexOfLyrics(
        sortedLyrics: lyrics,
        position: const Duration(milliseconds: 2500),
      );

      expect(result1, equals(0));
      expect(result2, equals(1));
    });
  });
}
