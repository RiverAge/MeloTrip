import 'package:dio/dio.dart';

enum AppFailureType {
  network,
  unauthorized,
  server,
  protocol,
  unknown,
}

class AppFailure {
  const AppFailure({
    required this.type,
    required this.message,
    this.statusCode,
    this.cause,
    this.stackTrace,
  });

  factory AppFailure.from(Object error, [StackTrace? stackTrace]) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 401 || statusCode == 403) {
        return AppFailure(
          type: AppFailureType.unauthorized,
          message: error.message ?? 'Unauthorized request.',
          statusCode: statusCode,
          cause: error,
          stackTrace: stackTrace,
        );
      }

      if (statusCode != null && statusCode >= 500) {
        return AppFailure(
          type: AppFailureType.server,
          message: error.message ?? 'Server request failed.',
          statusCode: statusCode,
          cause: error,
          stackTrace: stackTrace,
        );
      }

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.unknown) {
        return AppFailure(
          type: AppFailureType.network,
          message: error.message ?? 'Network request failed.',
          statusCode: statusCode,
          cause: error,
          stackTrace: stackTrace,
        );
      }
    }

    if (error is StateError) {
      return AppFailure(
        type: AppFailureType.protocol,
        message: error.message,
        cause: error,
        stackTrace: stackTrace,
      );
    }

    return AppFailure(
      type: AppFailureType.unknown,
      message: error.toString(),
      cause: error,
      stackTrace: stackTrace,
    );
  }

  final AppFailureType type;
  final String message;
  final int? statusCode;
  final Object? cause;
  final StackTrace? stackTrace;
}
