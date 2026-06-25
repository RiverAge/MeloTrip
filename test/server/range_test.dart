import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/server/cache_server.dart';

void main() {
  group('Range', () {
    group('Range.fromString', () {
      test('parses normal format correctly', () {
        final range = Range.fromString('100-200');

        expect(range.start, equals(100));
        expect(range.end, equals(200));
      });

      test('parses zero-based range', () {
        final range = Range.fromString('0-100');

        expect(range.start, equals(0));
        expect(range.end, equals(100));
      });

      test('swaps reversed range automatically', () {
        final range = Range.fromString('200-100');

        expect(range.start, equals(100));
        expect(range.end, equals(200));
      });

      test('returns (0, 0) for invalid format without dash', () {
        final range = Range.fromString('invalid');

        expect(range.start, equals(0));
        expect(range.end, equals(0));
      });

      test('returns (0, 0) for empty string', () {
        final range = Range.fromString('');

        expect(range.start, equals(0));
        expect(range.end, equals(0));
      });

      test('returns (0, 0) for format with single number', () {
        final range = Range.fromString('100');

        expect(range.start, equals(0));
        expect(range.end, equals(0));
      });

      test('handles non-numeric values gracefully', () {
        final range = Range.fromString('abc-def');

        expect(range.start, equals(0));
        expect(range.end, equals(0));
      });

      test('handles mixed numeric and non-numeric', () {
        final range = Range.fromString('100-abc');

        expect(range.start, equals(0));
        expect(range.end, equals(100));
      });

      test('handles large numbers', () {
        final range = Range.fromString('1000000-2000000');

        expect(range.start, equals(1000000));
        expect(range.end, equals(2000000));
      });
    });

    group('Range.toString', () {
      test('converts back to "start-end" format', () {
        final range = Range(100, 200);

        expect(range.toString(), equals('100-200'));
      });

      test('handles zero-based range', () {
        final range = Range(0, 100);

        expect(range.toString(), equals('0-100'));
      });
    });

    group('Range.constructor', () {
      test('creates range with specified values', () {
        final range = Range(50, 150);

        expect(range.start, equals(50));
        expect(range.end, equals(150));
      });
    });
  });

  group('mergeRanges', () {
    test('merges single existing range with new range', () {
      final result = mergeRanges(['100-200'], '150-250');

      expect(result.length, equals(1));
      expect(result.first.start, equals(100));
      expect(result.first.end, equals(250));
    });

    test('keeps non-overlapping ranges separate', () {
      final result = mergeRanges(['0-100'], '200-300');

      expect(result.length, equals(2));
      expect(result[0].start, equals(0));
      expect(result[0].end, equals(100));
      expect(result[1].start, equals(200));
      expect(result[1].end, equals(300));
    });

    test('merges adjacent ranges (gap of 1)', () {
      final result = mergeRanges(['0-100'], '101-200');

      expect(result.length, equals(1));
      expect(result.first.start, equals(0));
      expect(result.first.end, equals(200));
    });

    test('does not merge ranges with gap > 1', () {
      final result = mergeRanges(['0-100'], '102-200');

      expect(result.length, equals(2));
    });

    test('merges multiple overlapping ranges', () {
      final result = mergeRanges(['0-100', '50-150', '120-200'], '180-250');

      expect(result.length, equals(1));
      expect(result.first.start, equals(0));
      expect(result.first.end, equals(250));
    });

    test('handles empty existing ranges', () {
      final result = mergeRanges([], '100-200');

      expect(result.length, equals(1));
      expect(result.first.start, equals(100));
      expect(result.first.end, equals(200));
    });

    test('merges ranges in unsorted order', () {
      final result = mergeRanges(['200-300', '0-100'], '150-250');

      // Should be merged into one large range
      expect(result.length, equals(2));
      // First range: 0-100
      // Second range: 150-300 (merged)
    });

    test('handles identical ranges', () {
      final result = mergeRanges(['100-200'], '100-200');

      expect(result.length, equals(1));
      expect(result.first.start, equals(100));
      expect(result.first.end, equals(200));
    });

    test('handles new range completely inside existing', () {
      final result = mergeRanges(['0-200'], '50-100');

      expect(result.length, equals(1));
      expect(result.first.start, equals(0));
      expect(result.first.end, equals(200));
    });

    test('handles existing range completely inside new', () {
      final result = mergeRanges(['50-100'], '0-200');

      expect(result.length, equals(1));
      expect(result.first.start, equals(0));
      expect(result.first.end, equals(200));
    });

    test('creates multiple merged groups', () {
      final result = mergeRanges(['0-50', '100-150'], '200-250');

      expect(result.length, equals(3));
      expect(result[0].start, equals(0));
      expect(result[0].end, equals(50));
      expect(result[1].start, equals(100));
      expect(result[1].end, equals(150));
      expect(result[2].start, equals(200));
      expect(result[2].end, equals(250));
    });

    test('handles reversed input ranges', () {
      final result = mergeRanges(['200-100'], '150-250');

      // Reversed range should be auto-corrected to 100-200
      expect(result.length, equals(1));
      expect(result.first.start, equals(100));
      expect(result.first.end, equals(250));
    });
  });
}