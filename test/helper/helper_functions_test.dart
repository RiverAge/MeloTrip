import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/index.dart';

void main() {
  group('durationFormatter', () {
    test('formats seconds to mm:ss format', () {
      expect(durationFormatter(0), equals('00:00'));
      expect(durationFormatter(5), equals('00:05'));
      expect(durationFormatter(60), equals('01:00'));
      expect(durationFormatter(125), equals('02:05'));
      expect(durationFormatter(3661), equals('01:01:01'));
    });

    test('handles null input', () {
      expect(durationFormatter(null), equals(''));
    });

    test('handles hours format', () {
      expect(durationFormatter(3600), equals('01:00:00'));
      expect(durationFormatter(7265), equals('02:01:05'));
    });
  });

  group('fileSizeFormatter', () {
    test('formats bytes to human readable format', () {
      expect(fileSizeFormatter(0), equals('0 B'));
      expect(fileSizeFormatter(512), equals('512 B'));
      expect(fileSizeFormatter(1024), equals('1.0 KB'));
      expect(fileSizeFormatter(1536), equals('1.5 KB'));
      expect(fileSizeFormatter(1048576), equals('1.0 MB'));
      expect(fileSizeFormatter(1073741824), equals('1.0 GB'));
    });

    test('handles null input', () {
      expect(fileSizeFormatter(null), equals(''));
    });
  });
}
