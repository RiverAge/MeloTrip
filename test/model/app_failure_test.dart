import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';

void main() {
  group('AppFailure.from', () {
    test(
      'extracts endpoint and requestId from DioException request options',
      () {
        final exception = DioException(
          requestOptions: RequestOptions(
            path: '/rest/getPlaylists',
            extra: {'correlation_id': 'req-100'},
          ),
          type: DioExceptionType.connectionTimeout,
          message: 'timeout',
        );

        final failure = AppFailure.from(exception);

        expect(failure.type, AppFailureType.network);
        expect(failure.endpoint, '/rest/getPlaylists');
        expect(failure.requestId, 'req-100');
      },
    );

    test(
      'extracts requestId from correlation-id header when extra is missing',
      () {
        final exception = DioException(
          requestOptions: RequestOptions(
            path: '/rest/getArtists',
            headers: {'X-Correlation-Id': 'req-200'},
          ),
          type: DioExceptionType.connectionError,
          message: 'connection error',
        );

        final failure = AppFailure.from(exception);

        expect(failure.endpoint, '/rest/getArtists');
        expect(failure.requestId, 'req-200');
      },
    );
  });
}
