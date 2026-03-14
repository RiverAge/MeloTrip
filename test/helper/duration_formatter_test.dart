import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/index.dart';

void main() {
  group('durationFormatter', () {
    test('returns empty string for null', () {
      expect(durationFormatter(null), '');
    });

    test('formats seconds only', () {
      expect(durationFormatter(0), '00:00');
      expect(durationFormatter(30), '00:30');
      expect(durationFormatter(59), '00:59');
    });

    test('formats minutes and seconds', () {
      expect(durationFormatter(60), '01:00');
      expect(durationFormatter(90), '01:30');
      expect(durationFormatter(120), '02:00');
      expect(durationFormatter(150), '02:30');
    });

    test('formats hours correctly', () {
      expect(durationFormatter(3600), '01:00:00');
      expect(durationFormatter(3661), '01:01:01');
      expect(durationFormatter(7320), '02:02:00');
    });

    test('formats large durations', () {
      expect(durationFormatter(86400), '24:00:00');
      expect(durationFormatter(90061), '25:01:01');
    });
  });
}
