import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/lyrics_timeline.dart';

void main() {
  group('lyricIndexByStartMs', () {
    test('returns -1 for empty list', () {
      final result = lyricIndexByStartMs(
        sortedStartMs: [],
        positionMs: 0,
      );
      expect(result, equals(-1));
    });

    test('returns 0 when position is before first lyric', () {
      final result = lyricIndexByStartMs(
        sortedStartMs: [5000, 10000, 15000],
        positionMs: 3000,
      );
      expect(result, equals(0));
    });

    test('returns last index when position is after last lyric', () {
      final result = lyricIndexByStartMs(
        sortedStartMs: [5000, 10000, 15000],
        positionMs: 20000,
      );
      expect(result, equals(2));
    });

    test('returns correct index for position between lyrics', () {
      final result = lyricIndexByStartMs(
        sortedStartMs: [5000, 10000, 15000],
        positionMs: 12000,
      );
      expect(result, equals(1));
    });

    test('returns correct index for position exactly on lyric start', () {
      final result = lyricIndexByStartMs(
        sortedStartMs: [5000, 10000, 15000],
        positionMs: 10000,
      );
      expect(result, equals(1));
    });

    test('handles single element list', () {
      final result = lyricIndexByStartMs(
        sortedStartMs: [5000],
        positionMs: 6000,
      );
      expect(result, equals(0));
    });
  });

  group('lyricLineProgressByStartMs', () {
    test('returns 0 for empty list', () {
      final result = lyricLineProgressByStartMs(
        sortedStartMs: [],
        currentIndex: 0,
        positionMs: 0,
      );
      expect(result, equals(0.0));
    });

    test('returns 0 for negative index', () {
      final result = lyricLineProgressByStartMs(
        sortedStartMs: [5000, 10000],
        currentIndex: -1,
        positionMs: 6000,
      );
      expect(result, equals(0.0));
    });

    test('returns 0 for index out of bounds', () {
      final result = lyricLineProgressByStartMs(
        sortedStartMs: [5000, 10000],
        currentIndex: 5,
        positionMs: 6000,
      );
      expect(result, equals(0.0));
    });

    test('calculates progress within line duration', () {
      final result = lyricLineProgressByStartMs(
        sortedStartMs: [0, 5000, 10000],
        currentIndex: 1,
        positionMs: 7500,
      );
      expect(result, equals(0.5));
    });

    test('returns 1.0 when position reaches next line', () {
      final result = lyricLineProgressByStartMs(
        sortedStartMs: [0, 5000, 10000],
        currentIndex: 1,
        positionMs: 10000,
      );
      expect(result, equals(1.0));
    });

    test('uses trailing duration for last line', () {
      final result = lyricLineProgressByStartMs(
        sortedStartMs: [0, 5000, 10000],
        currentIndex: 2,
        positionMs: 12000,
        trailingDurationMs: 4000,
      );
      expect(result, equals(0.5));
    });

    test('clamps progress to 0.0 minimum', () {
      final result = lyricLineProgressByStartMs(
        sortedStartMs: [0, 5000],
        currentIndex: 1,
        positionMs: 4000,
      );
      expect(result, equals(0.0));
    });

    test('clamps progress to 1.0 maximum', () {
      final result = lyricLineProgressByStartMs(
        sortedStartMs: [0, 5000],
        currentIndex: 0,
        positionMs: 6000,
      );
      expect(result, equals(1.0));
    });
  });
}
