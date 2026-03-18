import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:media_kit/media_kit.dart';

void main() {
  group('SqliteBoolConvert', () {
    const converter = SqliteBoolConvert();

    test('fromJson returns null for null', () {
      expect(converter.fromJson(null), isNull);
    });

    test('fromJson handles boolean true', () {
      expect(converter.fromJson(true), isTrue);
    });

    test('fromJson handles boolean false', () {
      expect(converter.fromJson(false), isFalse);
    });

    test('fromJson handles numeric zero as false', () {
      expect(converter.fromJson(0), isFalse);
      expect(converter.fromJson(0.0), isFalse);
    });

    test('fromJson handles non-zero numeric as true', () {
      expect(converter.fromJson(1), isTrue);
      expect(converter.fromJson(42), isTrue);
      expect(converter.fromJson(-1), isTrue);
      expect(converter.fromJson(3.14), isTrue);
    });

    test('fromJson handles string "1" as true', () {
      expect(converter.fromJson('1'), isTrue);
    });

    test('fromJson handles string "true" as true', () {
      expect(converter.fromJson('true'), isTrue);
      expect(converter.fromJson('TRUE'), isTrue);
      expect(converter.fromJson('True'), isTrue);
    });

    test('fromJson handles other strings', () {
      expect(converter.fromJson('false'), isFalse);
      expect(converter.fromJson('0'), isFalse);
      expect(converter.fromJson('yes'), isFalse);
    });

    test('fromJson handles other types as null', () {
      expect(converter.fromJson(<String>[]), isNull);
      expect(converter.fromJson(<String, dynamic>{}), isNull);
    });

    test('toJson returns null for null', () {
      expect(converter.toJson(null), isNull);
    });

    test('toJson returns 1 for true', () {
      expect(converter.toJson(true), equals(1));
    });

    test('toJson returns 0 for false', () {
      expect(converter.toJson(false), equals(0));
    });
  });

  group('LocaleConvert', () {
    const converter = LocaleConvert();

    test('fromJson returns null for null', () {
      expect(converter.fromJson(null), isNull);
    });

    test('fromJson returns null for invalid format', () {
      expect(converter.fromJson('en'), isNull);
      expect(converter.fromJson('invalid'), isNull);
    });

    test('fromJson parses locale with country code', () {
      final result = converter.fromJson('en_US');
      expect(result, isNotNull);
      expect(result?.languageCode, equals('en'));
      expect(result?.countryCode, equals('US'));
    });

    test('fromJson parses locale with different country code', () {
      final result = converter.fromJson('zh_CN');
      expect(result, isNotNull);
      expect(result?.languageCode, equals('zh'));
      expect(result?.countryCode, equals('CN'));
    });

    test('toJson returns null for null locale', () {
      expect(converter.toJson(null), isNull);
    });

    test('toJson formats locale with country code', () {
      final locale = Locale('en', 'US');
      expect(converter.toJson(locale), equals('US_en'));
    });

    test('toJson handles locale without country code', () {
      final locale = Locale('en');
      expect(converter.toJson(locale), equals('null_en'));
    });
  });

  group('Configuration', () {
    test('fromJson parses basic configuration', () {
      final json = {
        'username': 'testuser',
        'max_rate': '320',
        'playlist_mode': 'none',
        'shuffle': 1,
        'update_at': 1234567890,
      };

      final config = Configuration.fromJson(json);

      expect(config.username, equals('testuser'));
      expect(config.maxRate, equals('320'));
      expect(config.playlistMode, equals(PlaylistMode.none));
      expect(config.shuffle, isTrue);
      expect(config.updateAt, equals(1234567890));
    });

    test('fromJson handles null optional fields', () {
      final json = <String, dynamic>{};

      final config = Configuration.fromJson(json);

      expect(config.username, isNull);
      expect(config.maxRate, isNull);
      expect(config.shuffle, isNull);
    });

    test('toJson serializes shuffle as integer', () {
      const config = Configuration(
        username: 'testuser',
        shuffle: true,
      );

      final json = config.toJson();

      expect(json['shuffle'], equals(1));
    });

    test('toJson serializes false shuffle as 0', () {
      const config = Configuration(
        username: 'testuser',
        shuffle: false,
      );

      final json = config.toJson();

      expect(json['shuffle'], equals(0));
    });

    test('copyWith preserves unchanged fields', () {
      const original = Configuration(
        username: 'testuser',
        maxRate: '320',
        shuffle: true,
      );

      final updated = original.copyWith(maxRate: '128');

      expect(updated.username, equals('testuser'));
      expect(updated.maxRate, equals('128'));
      expect(updated.shuffle, isTrue);
    });
  });
}
