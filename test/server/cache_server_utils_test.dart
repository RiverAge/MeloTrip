import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/server/cache_server.dart';

void main() {
  group('getContentLengthFromHeader', () {
    test('extracts content length from Content-Range header', () {
      final length = getContentLengthFromHeader('bytes 0-100/1000', 500);

      expect(length, equals(1000));
    });

    test('returns 0 for asterisk total size', () {
      // Asterisk means unknown total size, int.tryParse('*') returns null → 0
      final length = getContentLengthFromHeader('bytes 0-100/*', 500);

      expect(length, equals(0));
    });

    test('returns fallback when Content-Range is null', () {
      final length = getContentLengthFromHeader(null, 500);

      expect(length, equals(500));
    });

    test('returns fallback when Content-Range has no slash', () {
      final length = getContentLengthFromHeader('bytes 0-100', 500);

      expect(length, equals(500));
    });

    test('returns 0 when total size is not a number', () {
      final length = getContentLengthFromHeader('bytes 0-100/abc', 500);

      expect(length, equals(0));
    });

    test('handles large content length', () {
      final length = getContentLengthFromHeader(
        'bytes 0-100/999999999999',
        500,
      );

      expect(length, equals(999999999999));
    });

    test('returns fallback for empty string', () {
      final length = getContentLengthFromHeader('', 500);

      expect(length, equals(500));
    });
  });

  group('getStartBytesFromContentRange', () {
    test('extracts start byte from Content-Range header', () {
      final start = getStartBytesFromContentRange('bytes 100-200/1000');

      expect(start, equals(100));
    });

    test('extracts start byte with "bytes " prefix', () {
      final start = getStartBytesFromContentRange('bytes 0-100/1000');

      expect(start, equals(0));
    });

    test('returns 0 when Content-Range is null', () {
      final start = getStartBytesFromContentRange(null);

      expect(start, equals(0));
    });

    test('returns 0 when Content-Range has no dash', () {
      final start = getStartBytesFromContentRange('bytes 100');

      expect(start, equals(0));
    });

    test('returns 0 when start byte is not a number', () {
      final start = getStartBytesFromContentRange('bytes abc-200/1000');

      expect(start, equals(0));
    });

    test('handles large start byte', () {
      final start = getStartBytesFromContentRange(
        'bytes 999999999999-1000000000000/1000000000001',
      );

      expect(start, equals(999999999999));
    });

    test('returns 0 for empty string', () {
      final start = getStartBytesFromContentRange('');

      expect(start, equals(0));
    });

    test('handles Content-Range without "bytes " prefix', () {
      // Note: The implementation removes 'bytes ' prefix, so this would work
      // only if the format is exactly "100-200"
      final start = getStartBytesFromContentRange('100-200');

      expect(start, equals(100));
    });
  });
}
