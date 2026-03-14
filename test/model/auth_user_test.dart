import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';

void main() {
  group('AuthUser', () {
    test('fromJson parses all fields', () {
      final json = {
        'username': 'testuser',
        'token': 'abc123',
        'salt': 'xyz789',
        'host': 'https://example.com',
      };

      final authUser = AuthUser.fromJson(json);

      expect(authUser.username, equals('testuser'));
      expect(authUser.token, equals('abc123'));
      expect(authUser.salt, equals('xyz789'));
      expect(authUser.host, equals('https://example.com'));
    });

    test('fromJson handles null values', () {
      final json = <String, dynamic>{};

      final authUser = AuthUser.fromJson(json);

      expect(authUser.username, isNull);
      expect(authUser.token, isNull);
      expect(authUser.salt, isNull);
      expect(authUser.host, isNull);
    });

    test('fromJson handles partial data', () {
      final json = {
        'username': 'testuser',
        'token': 'abc123',
      };

      final authUser = AuthUser.fromJson(json);

      expect(authUser.username, equals('testuser'));
      expect(authUser.token, equals('abc123'));
      expect(authUser.salt, isNull);
      expect(authUser.host, isNull);
    });

    test('toJson serializes all fields', () {
      final authUser = const AuthUser(
        username: 'testuser',
        token: 'abc123',
        salt: 'xyz789',
        host: 'https://example.com',
      );

      final json = authUser.toJson();

      expect(json['username'], equals('testuser'));
      expect(json['token'], equals('abc123'));
      expect(json['salt'], equals('xyz789'));
      expect(json['host'], equals('https://example.com'));
    });

    test('copyWith creates modified copy', () {
      final original = const AuthUser(
        username: 'original',
        token: 'original_token',
      );

      final modified = original.copyWith(username: 'modified');

      expect(modified.username, equals('modified'));
      expect(modified.token, equals('original_token'));
    });

    test('equality works correctly', () {
      final user1 = const AuthUser(
        username: 'testuser',
        token: 'abc123',
      );

      final user2 = const AuthUser(
        username: 'testuser',
        token: 'abc123',
      );

      final user3 = const AuthUser(
        username: 'different',
        token: 'abc123',
      );

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });

    test('toString includes username', () {
      final authUser = const AuthUser(username: 'testuser');
      expect(authUser.toString(), contains('testuser'));
    });
  });
}
