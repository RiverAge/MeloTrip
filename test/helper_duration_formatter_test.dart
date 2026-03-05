import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/index.dart';

void main() {
  group('durationFormatter', () {
    test('returns empty string for null', () {
      expect(durationFormatter(null), '');
    });

    test('formats mm:ss for values below one hour', () {
      expect(durationFormatter(0), '00:00');
      expect(durationFormatter(9), '00:09');
      expect(durationFormatter(65), '01:05');
      expect(durationFormatter(3599), '59:59');
    });

    test('formats hh:mm:ss for one hour or more', () {
      expect(durationFormatter(3600), '01:00:00');
      expect(durationFormatter(3723), '01:02:03');
      expect(durationFormatter(86399), '23:59:59');
    });
  });
}
