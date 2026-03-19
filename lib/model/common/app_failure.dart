import 'package:dio/dio.dart';

enum AppFailureType { network, unauthorized, server, protocol, unknown }

class AppFailure {
  const AppFailure({
    required this.type,
    required this.message,
    this.statusCode,
    this.endpoint,
    this.requestId,
    this.cause,
    this.stackTrace,
  });

  factory AppFailure.from(Object error, [StackTrace? stackTrace]) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      final endpoint = _resolveEndpoint(error.requestOptions);
      final requestId = _resolveRequestId(error.requestOptions);
      if (statusCode == 401 || statusCode == 403) {
        return AppFailure(
          type: AppFailureType.unauthorized,
          message: error.message ?? 'Unauthorized request.',
          statusCode: statusCode,
          endpoint: endpoint,
          requestId: requestId,
          cause: error,
          stackTrace: stackTrace,
        );
      }

      if (statusCode != null && statusCode >= 500) {
        return AppFailure(
          type: AppFailureType.server,
          message: error.message ?? 'Server request failed.',
          statusCode: statusCode,
          endpoint: endpoint,
          requestId: requestId,
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
          endpoint: endpoint,
          requestId: requestId,
          cause: error,
          stackTrace: stackTrace,
        );
      }

      return AppFailure(
        type: AppFailureType.unknown,
        message: error.message ?? error.toString(),
        statusCode: statusCode,
        endpoint: endpoint,
        requestId: requestId,
        cause: error,
        stackTrace: stackTrace,
      );
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
  final String? endpoint;
  final String? requestId;
  final Object? cause;
  final StackTrace? stackTrace;
}

String? _resolveEndpoint(RequestOptions options) {
  final path = options.path.trim();
  if (path.isNotEmpty) {
    return path;
  }
  final uriPath = options.uri.path.trim();
  return uriPath.isEmpty ? null : uriPath;
}

String? _resolveRequestId(RequestOptions options) {
  final extraRequestId = options.extra['correlation_id']?.toString().trim();
  if (extraRequestId != null && extraRequestId.isNotEmpty) {
    return extraRequestId;
  }

  final headerValue =
      options.headers['X-Correlation-Id'] ??
      options.headers['x-correlation-id'];
  final candidate = switch (headerValue) {
    Iterable<dynamic>() => () {
      final iterator = headerValue.iterator;
      if (!iterator.moveNext()) {
        return null;
      }
      return iterator.current?.toString().trim();
    }(),
    _ => headerValue?.toString().trim(),
  };
  if (candidate == null || candidate.isEmpty) {
    return null;
  }
  return candidate;
}
