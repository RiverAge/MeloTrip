import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/result.dart';

void main() {
  group('Result', () {
    group('Result.ok', () {
      test('creates ok result with data', () {
        final result = Result<int, String>.ok(42);

        expect(result.isOk, isTrue);
        expect(result.isErr, isFalse);
        expect(result.data, equals(42));
        expect(result.error, isNull);
      });

      test('creates ok result with nullable type', () {
        final result = Result<String?, int>.ok(null);

        expect(result.isOk, isTrue);
        expect(result.data, isNull);
      });
    });

    group('Result.err', () {
      test('creates error result with error', () {
        final result = Result<int, String>.err('something went wrong');

        expect(result.isOk, isFalse);
        expect(result.isErr, isTrue);
        expect(result.error, equals('something went wrong'));
        expect(result.data, isNull);
      });
    });

    group('when', () {
      test('calls ok callback for ok result', () {
        final result = Result<int, String>.ok(42);

        final value = result.when(
          ok: (data) => 'success: $data',
          err: (error) => 'error: $error',
        );

        expect(value, equals('success: 42'));
      });

      test('calls err callback for error result', () {
        final result = Result<int, String>.err('failed');

        final value = result.when(
          ok: (data) => 'success: $data',
          err: (error) => 'error: $error',
        );

        expect(value, equals('error: failed'));
      });
    });

    group('equality', () {
      test('ok results with same data are equal', () {
        final result1 = Result<int, String>.ok(42);
        final result2 = Result<int, String>.ok(42);

        expect(result1.data, equals(result2.data));
        expect(result1.isOk, equals(result2.isOk));
      });

      test('error results with same error are equal', () {
        final result1 = Result<int, String>.err('error');
        final result2 = Result<int, String>.err('error');

        expect(result1.error, equals(result2.error));
        expect(result1.isErr, equals(result2.isErr));
      });
    });

    group('type safety', () {
      test('works with complex generic types', () {
        final data = {'key': 'value', 'count': 42};
        final result = Result<Map<String, dynamic>, Exception>.ok(data);

        expect(result.isOk, isTrue);
        expect(result.data, equals(data));
      });

      test('works with custom error types', () {
        final error = Exception('custom error');
        final result = Result<String, Exception>.err(error);

        expect(result.isErr, isTrue);
        expect(result.error, equals(error));
      });
    });
  });
}
