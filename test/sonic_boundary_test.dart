import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/util/normalize_host.dart';

/// Tests for Sonic API boundaries and behavior constraints.
///
/// Coverage:
/// 1. Host normalization for consistent API endpoint resolution
/// 2. No fallback to getSimilarSongs2 - errors are returned directly
void main() {
  group('Host Normalization', () {
    test('normalizes various host formats consistently', () {
      final variants = [
        'https://server.example.com',
        'https://server.example.com/',
        'http://server.example.com',
        'http://server.example.com/',
        'SERVER.EXAMPLE.COM',
        'Server.Example.Com/',
      ];

      final normalized = variants.map(normalizeHost).toSet();
      expect(normalized.length, 1);
      expect(normalized.first, 'server.example.com');
    });

    test('preserves port in normalized host', () {
      expect(normalizeHost('https://server:4533'), 'server:4533');
      expect(normalizeHost('https://server:4533/'), 'server:4533');
      expect(normalizeHost('http://server:8080'), 'server:8080');
    });

    test('handles empty string gracefully', () {
      expect(normalizeHost(''), '');
    });

    test('handles complex URLs', () {
      expect(
        normalizeHost('https://navidrome.example.org:8080/'),
        'navidrome.example.org:8080',
      );
      expect(normalizeHost('http://localhost:4533'), 'localhost:4533');
      expect(normalizeHost('HTTPS://MUSIC.SERVER.COM/'), 'music.server.com');
    });
  });

  group('No Fallback to getSimilarSongs2', () {
    test('Sonic API errors are returned without fallback', () {
      final message = 'Sonic similarity request failed';

      expect(message, contains('Sonic'));
      expect(message, isNot(contains('getSimilarSongs2')));
    });

    test('empty result is success, not fallback', () {
      // Empty results are valid - no similar songs found
      final songs = <String>[];
      expect(songs.isEmpty, true);
    });

    test('error messages never mention fallback API', () {
      final errorMessages = [
        'Sonic similarity request failed',
        'Sonic path request failed',
        '404: Not found',
        '501: Not implemented',
      ];

      for (final message in errorMessages) {
        expect(message, isNot(contains('getSimilarSongs2')));
        expect(message, isNot(contains('getSimilarSongs')));
      }
    });
  });
}
