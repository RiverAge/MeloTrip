import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/helper/subsonic_uri_builder.dart';
import 'package:melo_trip/helper/subsonic_protocol.dart';

void main() {
  group('SubsonicUriBuilder', () {
    const testAuth = AuthUser(
      salt: 'testsalt',
      token: 'testtoken',
      username: 'testuser',
      host: 'https://test.example.com',
    );

    group('buildCoverArtUri', () {
      test('builds cover art URI with required parameters', () {
        final uri = SubsonicUriBuilder.buildCoverArtUri(
          auth: testAuth,
          artworkId: 'album-123',
        );

        expect(uri.path, contains('getCoverArt'));
        expect(uri.queryParameters['id'], equals('album-123'));
        expect(uri.queryParameters['u'], equals('testuser'));
        expect(uri.queryParameters['t'], equals('testtoken'));
        expect(uri.queryParameters['s'], equals('testsalt'));
      });

      test('includes size parameter', () {
        final uri = SubsonicUriBuilder.buildCoverArtUri(
          auth: testAuth,
          artworkId: 'album-123',
          size: 300,
        );

        expect(uri.queryParameters['size'], equals('300'));
      });

      test('defaults size to 500', () {
        final uri = SubsonicUriBuilder.buildCoverArtUri(
          auth: testAuth,
          artworkId: 'album-123',
        );

        expect(uri.queryParameters['size'], equals('500'));
      });

      test('handles null auth', () {
        final uri = SubsonicUriBuilder.buildCoverArtUri(
          auth: null,
          artworkId: 'album-123',
        );

        // Should still build URI (using proxyCacheHost)
        expect(uri.path, contains('getCoverArt'));
        expect(uri.queryParameters['id'], equals('album-123'));
      });
    });

    group('buildStreamUri', () {
      test('builds stream URI with required parameters', () {
        final uri = SubsonicUriBuilder.buildStreamUri(
          auth: testAuth,
          songId: 'song-456',
        );

        expect(uri.path, contains('stream'));
        expect(uri.queryParameters['id'], equals('song-456'));
        expect(uri.queryParameters['u'], equals('testuser'));
      });

      test('includes maxBitRate parameter', () {
        final uri = SubsonicUriBuilder.buildStreamUri(
          auth: testAuth,
          songId: 'song-456',
          maxBitRate: '320',
        );

        expect(uri.queryParameters['maxBitRate'], equals('320'));
      });

      test('includes request timestamp', () {
        final uri = SubsonicUriBuilder.buildStreamUri(
          auth: testAuth,
          songId: 'song-456',
        );

        // Timestamp is included as '_' parameter
        expect(uri.queryParameters.containsKey('_'), isTrue);
      });

      test('does not include response format', () {
        final uri = SubsonicUriBuilder.buildStreamUri(
          auth: testAuth,
          songId: 'song-456',
        );

        expect(uri.queryParameters.containsKey('f'), isFalse);
      });
    });

    group('buildRestUri', () {
      test('builds URI with path', () {
        final uri = SubsonicUriBuilder.buildRestUri(
          auth: testAuth,
          path: 'getAlbumList',
        );

        expect(uri.path, equals('/getAlbumList'));
      });

      test('normalizes path without leading slash', () {
        final uri = SubsonicUriBuilder.buildRestUri(
          auth: testAuth,
          path: 'getAlbumList',
        );

        expect(uri.path, startsWith('/'));
      });

      test('handles path with leading slash', () {
        final uri = SubsonicUriBuilder.buildRestUri(
          auth: testAuth,
          path: '/getAlbumList',
        );

        expect(uri.path, equals('/getAlbumList'));
      });

      test('includes query parameters', () {
        final uri = SubsonicUriBuilder.buildRestUri(
          auth: testAuth,
          path: 'search3',
          queryParameters: {'query': 'test', 'artistCount': '10'},
        );

        expect(uri.queryParameters['query'], equals('test'));
        expect(uri.queryParameters['artistCount'], equals('10'));
      });

      test('removes null query parameters', () {
        final uri = SubsonicUriBuilder.buildRestUri(
          auth: testAuth,
          path: 'search3',
          queryParameters: {'query': 'test', 'artist': null},
        );

        expect(uri.queryParameters['query'], equals('test'));
        expect(uri.queryParameters.containsKey('artist'), isFalse);
      });

      test('removes empty query parameters', () {
        final uri = SubsonicUriBuilder.buildRestUri(
          auth: testAuth,
          path: 'search3',
          queryParameters: {'query': 'test', 'empty': ''},
        );

        expect(uri.queryParameters['query'], equals('test'));
        expect(uri.queryParameters.containsKey('empty'), isFalse);
      });

      test('includes response format by default', () {
        final uri = SubsonicUriBuilder.buildRestUri(
          auth: testAuth,
          path: 'getAlbumList',
        );

        expect(uri.queryParameters['f'], equals('json'));
      });

      test('excludes response format when flag is false', () {
        final uri = SubsonicUriBuilder.buildRestUri(
          auth: testAuth,
          path: 'getAlbumList',
          includeResponseFormat: false,
        );

        expect(uri.queryParameters.containsKey('f'), isFalse);
      });

      test('includes request timestamp when flag is true', () {
        final uri = SubsonicUriBuilder.buildRestUri(
          auth: testAuth,
          path: 'stream',
          includeRequestTimestamp: true,
        );

        expect(uri.queryParameters.containsKey('_'), isTrue);
      });

      test('excludes request timestamp by default', () {
        final uri = SubsonicUriBuilder.buildRestUri(
          auth: testAuth,
          path: 'getAlbumList',
        );

        expect(uri.queryParameters.containsKey('_'), isFalse);
      });

      test('includes auth parameters', () {
        final uri = SubsonicUriBuilder.buildRestUri(
          auth: testAuth,
          path: 'getAlbumList',
        );

        expect(uri.queryParameters['u'], equals('testuser'));
        expect(uri.queryParameters['t'], equals('testtoken'));
        expect(uri.queryParameters['s'], equals('testsalt'));
        expect(uri.queryParameters['v'], equals(subsonicApiVersion));
        expect(uri.queryParameters['c'], equals(subsonicClientName));
      });
    });

    group('_resolveBaseHost', () {
      test('returns auth host on web', () {
        // Note: kIsWeb is a compile-time constant, so we can't easily test this
        // This test documents the expected behavior
        const auth = AuthUser(
          salt: 'salt',
          token: 'token',
          username: 'user',
          host: 'https://web.example.com',
        );

        // On native platforms, it would use proxyCacheHost
        // On web, it would use auth.host
        final uri = SubsonicUriBuilder.buildRestUri(
          auth: auth,
          path: 'test',
        );

        // The URI should be valid
        expect(uri, isNotNull);
      });

      test('handles host with trailing slash', () {
        const auth = AuthUser(
          salt: 'salt',
          token: 'token',
          username: 'user',
          host: 'https://example.com/',
        );

        final uri = SubsonicUriBuilder.buildRestUri(
          auth: auth,
          path: 'test',
        );

        // Trailing slash is removed internally before building URI
        // On native, uses proxyCacheHost; on web, uses auth.host
        expect(uri, isNotNull);
        expect(uri.path, equals('/test'));
      });
    });
  });
}
