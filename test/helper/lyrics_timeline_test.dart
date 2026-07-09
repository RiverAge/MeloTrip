import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/lyrics_timeline.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';

void main() {
  group('lyricIndexByStartMs', () {
    test('returns -1 for empty list', () {
      final result = lyricIndexByStartMs(sortedStartMs: [], positionMs: 0);
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

  group('cueLineSweepFraction', () {
    // 4 个等长字（每字 0-250ms），整行 0-1000ms。
    final cues = const [
      Cue(start: 0, end: 250, value: '你'),
      Cue(start: 250, end: 500, value: '好'),
      Cue(start: 500, end: 750, value: '世'),
      Cue(start: 750, end: 1000, value: '界'),
    ];

    test('returns 0 before line starts', () {
      expect(cueLineSweepFraction(cues: cues, positionMs: -100), 0.0);
    });

    test('returns 0 at line start', () {
      expect(cueLineSweepFraction(cues: cues, positionMs: 0), 0.0);
    });

    test('returns 1.0 after line ends', () {
      expect(cueLineSweepFraction(cues: cues, positionMs: 2000), 1.0);
    });

    test('first word half sung => 0.125 (0.5 of 1/4)', () {
      // 0..250 进度 0.5 → 贡献 0.5 字；其余 0 → 0.5/4 = 0.125。
      expect(cueLineSweepFraction(cues: cues, positionMs: 125), closeTo(0.125, 1e-9));
    });

    test('first word done => 0.25', () {
      expect(cueLineSweepFraction(cues: cues, positionMs: 250), closeTo(0.25, 1e-9));
    });

    test('two words done => 0.5', () {
      expect(cueLineSweepFraction(cues: cues, positionMs: 500), closeTo(0.5, 1e-9));
    });

    test('mid third word => 0.625 (0.5 + 0.5*0.25)', () {
      // 前 2 字全亮=0.5，第 3 字 0..250 进度 0.5 → +0.125 = 0.625。
      expect(cueLineSweepFraction(cues: cues, positionMs: 625), closeTo(0.625, 1e-9));
    });

    test('empty cues => 0', () {
      expect(cueLineSweepFraction(cues: const [], positionMs: 0), 0.0);
    });

    test('null cue values contribute nothing', () {
      final nullCues = const [
        Cue(start: 0, end: 100, value: null),
        Cue(start: 100, end: 200, value: 'x'),
      ];
      // 只有 'x' 算长度；100..200 进度 0.5 → 0.5/1 = 0.5。
      expect(cueLineSweepFraction(cues: nullCues, positionMs: 150), closeTo(0.5, 1e-9));
    });
  });
}
