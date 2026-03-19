import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/repository/common/repository_guard.dart';

void main() {
  group('runGuarded contract', () {
    test('returns Result.ok when request succeeds', () async {
      final result = await runGuarded(() async => 42);

      expect(result.isOk, isTrue);
      expect(result.data, 42);
    });

    test('maps StateError to protocol AppFailure', () async {
      final result = await runGuarded<int>(() async {
        throw StateError('invalid payload');
      });

      expect(result.isErr, isTrue);
      expect(result.error?.type, AppFailureType.protocol);
      expect(result.error?.message, contains('invalid payload'));
    });

    test('maps DioException timeout to network AppFailure', () async {
      final result = await runGuarded<int>(() async {
        throw DioException(
          requestOptions: RequestOptions(
            path: '/rest/getSong',
            extra: {'correlation_id': 'req-guard-1'},
          ),
          type: DioExceptionType.connectionTimeout,
          message: 'timeout',
        );
      });

      expect(result.isErr, isTrue);
      expect(result.error?.type, AppFailureType.network);
      expect(result.error?.message, contains('timeout'));
      expect(result.error?.endpoint, '/rest/getSong');
      expect(result.error?.requestId, 'req-guard-1');
    });
  });
}
