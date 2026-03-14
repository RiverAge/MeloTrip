import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/index.dart';

void main() {
  group('fileSizeFormatter', () {
    test('returns empty string for null', () {
      expect(fileSizeFormatter(null), '');
    });

    test('formats bytes', () {
      expect(fileSizeFormatter(0), '0 B');
      expect(fileSizeFormatter(512), '512 B');
      expect(fileSizeFormatter(1023), '1023 B');
    });

    test('formats kilobytes', () {
      expect(fileSizeFormatter(1024), '1.0 KB');
      expect(fileSizeFormatter(1536), '1.5 KB');
      expect(fileSizeFormatter(2048), '2.0 KB');
      expect(fileSizeFormatter(10240), '10.0 KB');
    });

    test('formats megabytes', () {
      expect(fileSizeFormatter(1048576), '1.0 MB');
      expect(fileSizeFormatter(2097152), '2.0 MB');
      expect(fileSizeFormatter(5242880), '5.0 MB');
    });

    test('formats gigabytes', () {
      expect(fileSizeFormatter(1073741824), '1.0 GB');
      expect(fileSizeFormatter(2147483648), '2.0 GB');
    });

    test('formats terabytes', () {
      expect(fileSizeFormatter(1099511627776), '1.0 TB');
    });
  });
}
