import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';

void main() {
  group('ValueUpdater', () {
    test('wraps value correctly', () {
      const updater = ValueUpdater<int>(42);
      expect(updater.value, 42);
    });

    test('works with nullable types', () {
      const updater = ValueUpdater<String?>(null);
      expect(updater.value, isNull);
    });
  });

  group('SqliteBoolConvert', () {
    final converter = const SqliteBoolConvert();

    test('fromJson handles null', () {
      expect(converter.fromJson(null), isNull);
    });

    test('fromJson handles bool', () {
      expect(converter.fromJson(true), true);
      expect(converter.fromJson(false), false);
    });

    test('fromJson handles numbers', () {
      expect(converter.fromJson(1), true);
      expect(converter.fromJson(0), false);
      expect(converter.fromJson(42), true);
    });

    test('fromJson handles strings', () {
      expect(converter.fromJson('1'), true);
      expect(converter.fromJson('0'), false);
      expect(converter.fromJson('true'), true);
      expect(converter.fromJson('TRUE'), true);
      expect(converter.fromJson('false'), false);
    });

    test('toJson returns 1 or 0', () {
      expect(converter.toJson(true), 1);
      expect(converter.toJson(false), 0);
      expect(converter.toJson(null), isNull);
    });
  });

  group('LocaleConvert', () {
    final converter = const LocaleConvert();

    test('fromJson handles null', () {
      expect(converter.fromJson(null), isNull);
    });

    test('fromJson parses valid locale string', () {
      final locale = converter.fromJson('US_en');
      expect(locale, isNotNull);
      expect(locale!.languageCode, 'US');
      expect(locale.countryCode, 'en');
    });

    test('fromJson returns null for invalid format', () {
      expect(converter.fromJson('en'), isNull);
    });

    test('toJson serializes locale', () {
      final locale = const Locale('en', 'US');
      expect(converter.toJson(locale), 'US_en');
    });

    test('toJson returns null for null locale', () {
      expect(converter.toJson(null), isNull);
    });
  });
}
