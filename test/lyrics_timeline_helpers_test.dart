import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/index_of_lyrics.dart';
import 'package:melo_trip/helper/lyrics_timeline.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';

void main() {
  group('lyricIndexByStartMs', () {
    test('returns -1 for empty list', () {
      expect(
        lyricIndexByStartMs(sortedStartMs: const [], positionMs: 1000),
        -1,
      );
    });

    test('returns 0 when position is before first line', () {
      expect(
        lyricIndexByStartMs(
          sortedStartMs: const [1000, 2000, 3000],
          positionMs: 500,
        ),
        0,
      );
    });

    test('returns last index when position is after last line', () {
      expect(
        lyricIndexByStartMs(
          sortedStartMs: const [1000, 2000, 3000],
          positionMs: 5000,
        ),
        2,
      );
    });

    test('returns in-range index between two lyric starts', () {
      expect(
        lyricIndexByStartMs(
          sortedStartMs: const [1000, 2000, 3000],
          positionMs: 2500,
        ),
        1,
      );
    });
  });

  group('lyricLineProgressByStartMs', () {
    test('returns 0 for invalid input/index', () {
      expect(
        lyricLineProgressByStartMs(
          sortedStartMs: const [],
          currentIndex: 0,
          positionMs: 1000,
        ),
        0.0,
      );
      expect(
        lyricLineProgressByStartMs(
          sortedStartMs: const [1000, 2000],
          currentIndex: -1,
          positionMs: 1500,
        ),
        0.0,
      );
      expect(
        lyricLineProgressByStartMs(
          sortedStartMs: const [1000, 2000],
          currentIndex: 2,
          positionMs: 1500,
        ),
        0.0,
      );
    });

    test('computes progress using next start for non-last line', () {
      expect(
        lyricLineProgressByStartMs(
          sortedStartMs: const [1000, 2000, 3000],
          currentIndex: 1,
          positionMs: 2500,
        ),
        closeTo(0.5, 0.0001),
      );
    });

    test('computes progress for last line using trailing duration', () {
      expect(
        lyricLineProgressByStartMs(
          sortedStartMs: const [1000, 2000],
          currentIndex: 1,
          positionMs: 4000,
          trailingDurationMs: 4000,
        ),
        closeTo(0.5, 0.0001),
      );
    });

    test('clamps progress into 0..1 range', () {
      expect(
        lyricLineProgressByStartMs(
          sortedStartMs: const [1000, 2000],
          currentIndex: 0,
          positionMs: 0,
        ),
        0.0,
      );
      expect(
        lyricLineProgressByStartMs(
          sortedStartMs: const [1000, 2000],
          currentIndex: 0,
          positionMs: 5000,
        ),
        1.0,
      );
    });
  });

  group('indexOfLyrics wrapper', () {
    test('maps Line.start list and delegates index lookup', () {
      final lyrics = const [
        Line(start: 1000, value: ['a']),
        Line(start: 2000, value: ['b']),
        Line(start: 3000, value: ['c']),
      ];

      expect(
        indexOfLyrics(
          sortedLyrics: lyrics,
          position: const Duration(milliseconds: 2400),
        ),
        1,
      );
    });
  });
}
