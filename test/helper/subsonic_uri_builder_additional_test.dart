import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/subsonic_uri_builder.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';

void main() {
  group('SubsonicUriBuilder.buildRestUri', () {
    test('builds URI with auth parameters', () {
      final auth = AuthUser(
        username: 'testuser',
        token: 'testtoken',
        salt: 'testsalt',
        host: 'http://localhost:4000',
      );

      final uri = SubsonicUriBuilder.buildRestUri(
        auth: auth,
        path: 'rest/ping.view',
      );

      expect(uri.path, contains('ping.view'));
      expect(uri.queryParameters['u'], equals('testuser'));
      expect(uri.queryParameters['t'], equals('testtoken'));
      expect(uri.queryParameters['s'], equals('testsalt'));
      expect(uri.queryParameters['v'], isNotNull);
      expect(uri.queryParameters['c'], isNotNull);
      expect(uri.queryParameters['f'], equals('json'));
    });

    test('builds URI without auth when auth is null', () {
      final uri = SubsonicUriBuilder.buildRestUri(
        auth: null,
        path: 'rest/ping.view',
      );

      expect(uri.path, contains('ping.view'));
    });

    test('includes custom query parameters', () {
      final uri = SubsonicUriBuilder.buildRestUri(
        auth: null,
        path: 'rest/test',
        queryParameters: {'custom': 'value', 'page': '1'},
      );

      expect(uri.queryParameters['custom'], equals('value'));
      expect(uri.queryParameters['page'], equals('1'));
    });

    test('removes null and empty query parameters', () {
      final uri = SubsonicUriBuilder.buildRestUri(
        auth: null,
        path: 'rest/test',
        queryParameters: {'valid': 'ok', 'empty': '', 'null': null as String?},
      );

      expect(uri.queryParameters['valid'], equals('ok'));
      expect(uri.queryParameters.containsKey('empty'), isFalse);
      expect(uri.queryParameters.containsKey('null'), isFalse);
    });

    test('normalizes path with leading slash', () {
      final uri1 = SubsonicUriBuilder.buildRestUri(
        auth: null,
        path: 'rest/test',
      );
      final uri2 = SubsonicUriBuilder.buildRestUri(
        auth: null,
        path: '/rest/test',
      );

      expect(uri1.path, equals(uri2.path));
    });

    test('includes request timestamp when flag is true', () {
      final uri = SubsonicUriBuilder.buildRestUri(
        auth: null,
        path: 'rest/test',
        includeRequestTimestamp: true,
      );

      expect(uri.queryParameters.containsKey('_'), isTrue);
    });

    test('excludes response format when flag is false', () {
      final uri = SubsonicUriBuilder.buildRestUri(
        auth: null,
        path: 'rest/test',
        includeResponseFormat: false,
      );

      expect(uri.queryParameters.containsKey('f'), isFalse);
    });
  });
}
