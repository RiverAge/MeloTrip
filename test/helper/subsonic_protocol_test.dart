import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/subsonic_protocol.dart';

void main() {
  group('subsonicProtocol constants', () {
    test('subsonicApiVersion is defined', () {
      expect(subsonicApiVersion, isA<String>());
      expect(subsonicApiVersion, isNotEmpty);
    });

    test('subsonicClientName is defined', () {
      expect(subsonicClientName, equals('melo_trip'));
    });

    test('subsonicStreamPath is defined', () {
      expect(subsonicStreamPath, equals('/rest/stream'));
    });

    test('subsonicCoverArtPath is defined', () {
      expect(subsonicCoverArtPath, equals('/rest/getCoverArt'));
    });

    test('subsonicCacheableMediaPaths contains stream and cover art', () {
      expect(subsonicCacheableMediaPaths.contains(subsonicStreamPath), isTrue);
      expect(subsonicCacheableMediaPaths.contains(subsonicCoverArtPath), isTrue);
    });

    test('subsonicRequiredMediaQueryParameterNames contains required params', () {
      expect(subsonicRequiredMediaQueryParameterNames.contains('u'), isTrue);
      expect(subsonicRequiredMediaQueryParameterNames.contains('t'), isTrue);
      expect(subsonicRequiredMediaQueryParameterNames.contains('s'), isTrue);
      expect(subsonicRequiredMediaQueryParameterNames.contains('v'), isTrue);
      expect(subsonicRequiredMediaQueryParameterNames.contains('c'), isTrue);
      expect(subsonicRequiredMediaQueryParameterNames.contains('id'), isTrue);
    });

    test('subsonicDigestExcludedQueryParameterNames contains excluded params', () {
      expect(subsonicDigestExcludedQueryParameterNames.contains('u'), isTrue);
      expect(subsonicDigestExcludedQueryParameterNames.contains('t'), isTrue);
      expect(subsonicDigestExcludedQueryParameterNames.contains('s'), isTrue);
      expect(subsonicDigestExcludedQueryParameterNames.contains('c'), isTrue);
      expect(subsonicDigestExcludedQueryParameterNames.contains('v'), isTrue);
    });
  });

  group('isCacheableSubsonicMediaUri', () {
    test('returns false for non-subsonic path', () {
      final uri = Uri.parse('https://example.com/other/path');
      expect(isCacheableSubsonicMediaUri(uri), isFalse);
    });

    test('returns false for stream path without required parameters', () {
      final uri = Uri.parse('https://example.com/rest/stream');
      expect(isCacheableSubsonicMediaUri(uri), isFalse);
    });

    test('returns false for cover art path without required parameters', () {
      final uri = Uri.parse('https://example.com/rest/getCoverArt');
      expect(isCacheableSubsonicMediaUri(uri), isFalse);
    });

    test('returns true for stream path with all required parameters', () {
      final uri = Uri.parse(
        'https://example.com/rest/stream?u=user&t=123&s=salt&v=1.16.1&c=client&id=1',
      );
      expect(isCacheableSubsonicMediaUri(uri), isTrue);
    });

    test('returns true for cover art path with all required parameters', () {
      final uri = Uri.parse(
        'https://example.com/rest/getCoverArt?u=user&t=123&s=salt&v=1.16.1&c=client&id=1',
      );
      expect(isCacheableSubsonicMediaUri(uri), isTrue);
    });
  });

  group('buildCacheableSubsonicMediaDigest', () {
    test('removes excluded query parameters', () {
      final uri = Uri.parse(
        'https://example.com/rest/stream?u=user&t=123&s=salt&v=1.16.1&c=client&id=1&extra=value',
      );
      final digest = buildCacheableSubsonicMediaDigest(uri);

      expect(digest, isA<String>());
      expect(digest.contains('id=1'), isTrue);
      expect(digest.contains('extra=value'), isTrue);
      expect(digest.contains('u='), isFalse);
      expect(digest.contains('t='), isFalse);
      expect(digest.contains('s='), isFalse);
      expect(digest.contains('v='), isFalse);
      expect(digest.contains('c='), isFalse);
    });

    test('handles URI without excluded parameters', () {
      final uri = Uri.parse('https://example.com/rest/stream?id=1&extra=value');
      final digest = buildCacheableSubsonicMediaDigest(uri);

      expect(digest, equals('https://example.com/rest/stream?id=1&extra=value'));
    });
  });
}
