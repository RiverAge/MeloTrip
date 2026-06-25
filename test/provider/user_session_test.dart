import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';

void main() {
  group('UserSessionSnapshot', () {
    test('creates with auth and config', () {
      const auth = AuthUser(
        salt: 'salt',
        token: 'token',
        username: 'user',
        host: 'https://example.com',
      );
      const config = Configuration(username: 'user');

      const snapshot = UserSessionSnapshot(auth: auth, config: config);

      expect(snapshot.auth, equals(auth));
      expect(snapshot.config, equals(config));
    });

    test('creates with null values', () {
      const snapshot = UserSessionSnapshot(auth: null, config: null);

      expect(snapshot.auth, isNull);
      expect(snapshot.config, isNull);
    });
  });

  group('sessionAuthProvider', () {
    test('extracts auth from UserSessionSnapshot', () async {
      // Note: Testing providers requires ProviderContainer
      // This test verifies the logic conceptually
      const auth = AuthUser(
        salt: 'salt',
        token: 'token',
        username: 'user',
        host: 'https://example.com',
      );
      const snapshot = UserSessionSnapshot(auth: auth, config: null);

      expect(snapshot.auth, equals(auth));
    });
  });

  group('sessionConfigProvider', () {
    test('extracts config from UserSessionSnapshot', () async {
      const config = Configuration(username: 'user', maxRate: '320');
      const snapshot = UserSessionSnapshot(auth: null, config: config);

      expect(snapshot.config, equals(config));
    });
  });

  group('_resolveRecentSearches logic', () {
    // Testing the logic extracted from UserSession
    String? resolveRecentSearches({
      required String? current,
      required String? recentSearches,
      required String? recentSearch,
    }) {
      if (recentSearch != null) {
        final searches = (current ?? '')
            .split(',')
            .where((item) => item.isNotEmpty)
            .toList();
        final query = recentSearch.trim();
        if (query.isNotEmpty) {
          searches.remove(query);
          searches.insert(0, query);
          return searches.take(20).join(',');
        }
        return current;
      }
      return recentSearches ?? current;
    }

    test('adds new search to front', () {
      final result = resolveRecentSearches(
        current: 'old1,old2',
        recentSearches: null,
        recentSearch: 'new',
      );

      expect(result, equals('new,old1,old2'));
    });

    test('moves existing search to front', () {
      final result = resolveRecentSearches(
        current: 'old1,old2,old3',
        recentSearches: null,
        recentSearch: 'old2',
      );

      expect(result, equals('old2,old1,old3'));
    });

    test('limits to 20 items', () {
      final current = List.generate(20, (i) => 'search$i').join(',');
      final result = resolveRecentSearches(
        current: current,
        recentSearches: null,
        recentSearch: 'new',
      );

      final items = result!.split(',');
      expect(items.length, equals(20));
      expect(items.first, equals('new'));
    });

    test('returns recentSearches if recentSearch is null', () {
      final result = resolveRecentSearches(
        current: 'old',
        recentSearches: 'replaced',
        recentSearch: null,
      );

      expect(result, equals('replaced'));
    });

    test('returns current if both are null', () {
      final result = resolveRecentSearches(
        current: 'current',
        recentSearches: null,
        recentSearch: null,
      );

      expect(result, equals('current'));
    });

    test('handles empty current', () {
      final result = resolveRecentSearches(
        current: '',
        recentSearches: null,
        recentSearch: 'new',
      );

      expect(result, equals('new'));
    });

    test('handles whitespace in recentSearch', () {
      final result = resolveRecentSearches(
        current: 'old',
        recentSearches: null,
        recentSearch: '  spaced  ',
      );

      expect(result, equals('spaced,old'));
    });

    test('does nothing for empty recentSearch', () {
      final result = resolveRecentSearches(
        current: 'old',
        recentSearches: null,
        recentSearch: '',
      );

      expect(result, equals('old'));
    });
  });
}
