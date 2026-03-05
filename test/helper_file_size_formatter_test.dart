import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/index.dart';

void main() {
  group('fileSizeFormatter', () {
    test('returns empty string for null', () {
      expect(fileSizeFormatter(null), '');
    });

    test('formats bytes under 1KB', () {
      expect(fileSizeFormatter(0), '0 B');
      expect(fileSizeFormatter(1023), '1023 B');
    });

    test('formats KB with rounding', () {
      expect(fileSizeFormatter(1024), '1.0 KB');
      expect(fileSizeFormatter(1536), '1.5 KB');
    });

    test('formats MB/GB/TB with rounding', () {
      expect(fileSizeFormatter(1024 * 1024), '1.0 MB');
      expect(fileSizeFormatter(5 * 1024 * 1024), '5.0 MB');
      expect(fileSizeFormatter(1024 * 1024 * 1024), '1.0 GB');
      expect(fileSizeFormatter(1024 * 1024 * 1024 * 1024), '1.0 TB');
    });
  });
}
