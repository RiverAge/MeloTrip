import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/error/error.dart';

void main() {
  group('ErrorEntity', () {
    test('fromJson parses all fields', () {
      final json = {
        'code': 42,
        'message': 'Test error message',
      };

      final error = ErrorEntity.fromJson(json);

      expect(error.code, equals(42));
      expect(error.message, equals('Test error message'));
    });

    test('fromJson handles null code', () {
      final json = {
        'message': 'Test error message',
      };

      final error = ErrorEntity.fromJson(json);

      expect(error.code, isNull);
      expect(error.message, equals('Test error message'));
    });

    test('fromJson handles null message', () {
      final json = {
        'code': 42,
      };

      final error = ErrorEntity.fromJson(json);

      expect(error.code, equals(42));
      expect(error.message, isNull);
    });

    test('fromJson handles empty json', () {
      final json = <String, dynamic>{};

      final error = ErrorEntity.fromJson(json);

      expect(error.code, isNull);
      expect(error.message, isNull);
    });

    test('toJson serializes all fields', () {
      final error = const ErrorEntity(
        code: 42,
        message: 'Test error message',
      );

      final json = error.toJson();

      expect(json['code'], equals(42));
      expect(json['message'], equals('Test error message'));
    });

    test('copyWith creates modified copy', () {
      final original = const ErrorEntity(
        code: 42,
        message: 'Original message',
      );

      final modified = original.copyWith(message: 'Modified message');

      expect(modified.code, equals(42));
      expect(modified.message, equals('Modified message'));
    });

    test('equality works correctly', () {
      final error1 = const ErrorEntity(
        code: 42,
        message: 'Test message',
      );

      final error2 = const ErrorEntity(
        code: 42,
        message: 'Test message',
      );

      final error3 = const ErrorEntity(
        code: 43,
        message: 'Test message',
      );

      expect(error1, equals(error2));
      expect(error1, isNot(equals(error3)));
    });

    test('toString includes message', () {
      final error = const ErrorEntity(message: 'Test error');
      expect(error.toString(), contains('Test error'));
    });
  });
}
