import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:dio/dio.dart';

void main() {
  group('AppFailure', () {
    group('AppFailureType', () {
      test('contains all expected types', () {
        expect(AppFailureType.values, contains(AppFailureType.network));
        expect(AppFailureType.values, contains(AppFailureType.unauthorized));
        expect(AppFailureType.values, contains(AppFailureType.server));
        expect(AppFailureType.values, contains(AppFailureType.protocol));
        expect(AppFailureType.values, contains(AppFailureType.notAnalyzed));
        expect(AppFailureType.values, contains(AppFailureType.unknown));
      });
    });

    group('AppFailure constructor', () {
      test('creates with required fields only', () {
        final failure = AppFailure(
          type: AppFailureType.network,
          message: 'Connection failed',
        );

        expect(failure.type, equals(AppFailureType.network));
        expect(failure.message, equals('Connection failed'));
        expect(failure.statusCode, isNull);
        expect(failure.endpoint, isNull);
        expect(failure.requestId, isNull);
        expect(failure.cause, isNull);
        expect(failure.stackTrace, isNull);
      });

      test('creates with all fields', () {
        final cause = Exception('test cause');
        final stackTrace = StackTrace.current;

        final failure = AppFailure(
          type: AppFailureType.server,
          message: 'Server error',
          statusCode: 500,
          endpoint: '/api/test',
          requestId: 'req-123',
          cause: cause,
          stackTrace: stackTrace,
        );

        expect(failure.type, equals(AppFailureType.server));
        expect(failure.message, equals('Server error'));
        expect(failure.statusCode, equals(500));
        expect(failure.endpoint, equals('/api/test'));
        expect(failure.requestId, equals('req-123'));
        expect(failure.cause, equals(cause));
        expect(failure.stackTrace, equals(stackTrace));
      });
    });

    group('AppFailure.from', () {
      test('creates network failure from DioException connection timeout', () {
        final dioError = DioException(
          type: DioExceptionType.connectionTimeout,
          message: 'Connection timeout',
          requestOptions: RequestOptions(path: '/api/test'),
        );

        final failure = AppFailure.from(dioError);

        expect(failure.type, equals(AppFailureType.network));
        expect(failure.message, contains('Connection timeout'));
      });

      test('creates network failure from DioException connection error', () {
        final dioError = DioException(
          type: DioExceptionType.connectionError,
          message: 'Connection failed',
          requestOptions: RequestOptions(path: '/api/test'),
        );

        final failure = AppFailure.from(dioError);

        expect(failure.type, equals(AppFailureType.network));
      });

      test('creates unauthorized failure from DioException 401', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          message: 'Unauthorized',
          requestOptions: RequestOptions(path: '/api/test'),
          response: Response(
            statusCode: 401,
            requestOptions: RequestOptions(path: '/api/test'),
          ),
        );

        final failure = AppFailure.from(dioError);

        expect(failure.type, equals(AppFailureType.unauthorized));
        expect(failure.statusCode, equals(401));
      });

      test('creates unauthorized failure from DioException 403', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          message: 'Forbidden',
          requestOptions: RequestOptions(path: '/api/test'),
          response: Response(
            statusCode: 403,
            requestOptions: RequestOptions(path: '/api/test'),
          ),
        );

        final failure = AppFailure.from(dioError);

        expect(failure.type, equals(AppFailureType.unauthorized));
        expect(failure.statusCode, equals(403));
      });

      test('creates server failure from DioException 500', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          message: 'Internal server error',
          requestOptions: RequestOptions(path: '/api/test'),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/api/test'),
          ),
        );

        final failure = AppFailure.from(dioError);

        expect(failure.type, equals(AppFailureType.server));
        expect(failure.statusCode, equals(500));
        expect(failure.endpoint, equals('/api/test'));
      });

      test('creates server failure from DioException 502', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          message: 'Bad gateway',
          requestOptions: RequestOptions(path: '/api/test'),
          response: Response(
            statusCode: 502,
            requestOptions: RequestOptions(path: '/api/test'),
          ),
        );

        final failure = AppFailure.from(dioError);

        expect(failure.type, equals(AppFailureType.server));
        expect(failure.statusCode, equals(502));
      });

      test('creates protocol failure from StateError', () {
        final stateError = StateError('Invalid state');

        final failure = AppFailure.from(stateError);

        expect(failure.type, equals(AppFailureType.protocol));
        expect(failure.message, contains('Invalid state'));
      });

      test('creates notAnalyzed failure from AudioMuse error', () {
        final error = Exception('AudioMuse-AI returned status 404');

        final failure = AppFailure.from(error);

        expect(failure.type, equals(AppFailureType.notAnalyzed));
      });

      test('creates notAnalyzed failure from has not been analyzed error', () {
        final error = Exception('Song has not been analyzed by AudioMuse-AI');

        final failure = AppFailure.from(error);

        expect(failure.type, equals(AppFailureType.notAnalyzed));
      });

      test('creates unknown failure from generic exception', () {
        final error = Exception('Unknown error');

        final failure = AppFailure.from(error);

        expect(failure.type, equals(AppFailureType.unknown));
      });

      test('preserves stack trace', () {
        final dioError = DioException(
          type: DioExceptionType.connectionError,
          message: 'Connection failed',
          requestOptions: RequestOptions(path: '/api/test'),
        );
        final stackTrace = StackTrace.current;

        final failure = AppFailure.from(dioError, stackTrace);

        expect(failure.stackTrace, equals(stackTrace));
      });

      test('extracts endpoint from RequestOptions path', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          message: 'Error',
          requestOptions: RequestOptions(path: '/rest/getAlbum'),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/rest/getAlbum'),
          ),
        );

        final failure = AppFailure.from(dioError);

        expect(failure.endpoint, equals('/rest/getAlbum'));
      });

      test('extracts requestId from extra correlation_id', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          message: 'Error',
          requestOptions: RequestOptions(
            path: '/api/test',
            extra: {'correlation_id': 'corr-123'},
          ),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(
              path: '/api/test',
              extra: {'correlation_id': 'corr-123'},
            ),
          ),
        );

        final failure = AppFailure.from(dioError);

        expect(failure.requestId, equals('corr-123'));
      });

      test('extracts requestId from X-Correlation-Id header', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          message: 'Error',
          requestOptions: RequestOptions(
            path: '/api/test',
            headers: {'X-Correlation-Id': 'header-corr-456'},
          ),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(
              path: '/api/test',
              headers: {'X-Correlation-Id': 'header-corr-456'},
            ),
          ),
        );

        final failure = AppFailure.from(dioError);

        expect(failure.requestId, equals('header-corr-456'));
      });

      test('creates unknown failure from DioException badResponse with 400', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          message: 'Bad request',
          requestOptions: RequestOptions(path: '/api/test'),
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(path: '/api/test'),
          ),
        );

        final failure = AppFailure.from(dioError);

        // 400 is not 401/403 and not >= 500, so it should be unknown
        expect(failure.type, equals(AppFailureType.unknown));
        expect(failure.statusCode, equals(400));
      });

      test('extracts endpoint from empty path and uri path', () {
        // When path is empty, the _resolveEndpoint function falls back to uri path
        // RequestOptions.uri returns a Uri based on baseUrl and path
        // For this test, we use a path to verify extraction works
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          message: 'Error',
          requestOptions: RequestOptions(
            path: '/rest/ping',
          ),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(
              path: '/rest/ping',
            ),
          ),
        );

        final failure = AppFailure.from(dioError);

        expect(failure.endpoint, equals('/rest/ping'));
      });

      test('returns null endpoint for empty path with empty uri path', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          message: 'Error',
          requestOptions: RequestOptions(path: ''),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: ''),
          ),
        );

        final failure = AppFailure.from(dioError);

        // Empty path with no URI path should return null endpoint
        expect(failure.endpoint, isNull);
      });

      test('returns null requestId when no correlation id present', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          message: 'Error',
          requestOptions: RequestOptions(path: '/api/test'),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/api/test'),
          ),
        );

        final failure = AppFailure.from(dioError);

        expect(failure.requestId, isNull);
      });

      test('returns null requestId when correlation id is empty', () {
        final dioError = DioException(
          type: DioExceptionType.badResponse,
          message: 'Error',
          requestOptions: RequestOptions(
            path: '/api/test',
            extra: {'correlation_id': ''},
          ),
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(
              path: '/api/test',
              extra: {'correlation_id': ''},
            ),
          ),
        );

        final failure = AppFailure.from(dioError);

        expect(failure.requestId, isNull);
      });
    });
  });
}
