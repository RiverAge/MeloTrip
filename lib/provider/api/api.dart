import 'dart:async';

import 'package:dio/dio.dart';
import 'package:melo_trip/helper/app_failure_log.dart';
import 'package:melo_trip/helper/subsonic_protocol.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/provider/app/error.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api.g.dart';

@Riverpod(keepAlive: true)
class Api extends _$Api {
  static const String _correlationIdHeader = 'X-Correlation-Id';
  static const String _correlationIdExtraKey = 'correlation_id';
  static const String _retryCountExtraKey = 'retry_count';
  static const int _maxTransportRetryCount = 1;

  Dio? _dio;

  @override
  Future<Dio> build() async {
    final Dio dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
    _configureInterceptors(dio);
    _dio = dio;
    return dio;
  }

  void _configureInterceptors(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final correlationId = _resolveCorrelationId(options);
    options.headers.putIfAbsent(_correlationIdHeader, () => correlationId);

    options.queryParameters.putIfAbsent(
      '_',
      () => DateTime.now().toIso8601String(),
    );
    options.queryParameters.putIfAbsent('v', () => subsonicApiVersion);
    options.queryParameters.putIfAbsent('c', () => subsonicClientName);
    options.queryParameters.putIfAbsent('f', () => 'json');

    final auth = await ref.read(sessionAuthProvider.future);
    final token = auth?.token;
    final host = auth?.host;
    final hasExplicitAuth =
        options.queryParameters.containsKey('u') ||
        options.queryParameters.containsKey('t') ||
        options.queryParameters.containsKey('s');

    if (token != null && host != null && !hasExplicitAuth) {
      options.baseUrl = host;
      options.queryParameters.addAll({
        'u': auth?.username,
        't': token,
        's': auth?.salt,
      });
    }

    handler.next(options);
  }

  Future<void> _onError(
    DioException exception,
    ErrorInterceptorHandler handler,
  ) async {
    final retryOutcome = await _retryTransportFailureOnce(exception);
    if (retryOutcome case _RetryResolved(:final response)) {
      handler.resolve(response);
      return;
    }

    final DioException finalException = switch (retryOutcome) {
      _RetryFailed(:final exception) => exception,
      _RetryResolved() => exception,
      _RetrySkipped() => exception,
    };
    if (_isTransportFailure(finalException)) {
      _emitGlobalError(finalException);
    }
    handler.next(finalException);
  }

  bool _isTransportFailure(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.connectionTimeout => true,
      DioExceptionType.sendTimeout => true,
      DioExceptionType.receiveTimeout => true,
      DioExceptionType.connectionError => true,
      DioExceptionType.unknown => true,
      _ => false,
    };
  }

  String _resolveCorrelationId(RequestOptions options) {
    final existing = options.extra[_correlationIdExtraKey] as String?;
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    final correlationId = 'req-${DateTime.now().microsecondsSinceEpoch}';
    options.extra[_correlationIdExtraKey] = correlationId;
    return correlationId;
  }

  Future<_RetryOutcome> _retryTransportFailureOnce(DioException exception) async {
    if (!_isTransportFailure(exception)) {
      return const _RetrySkipped();
    }
    if (_dio == null) {
      return const _RetrySkipped();
    }

    final options = exception.requestOptions;
    final retryCount = (options.extra[_retryCountExtraKey] as int?) ?? 0;
    final shouldRetry =
        options.method.toUpperCase() == 'GET' &&
        retryCount < _maxTransportRetryCount;
    if (!shouldRetry) {
      return const _RetrySkipped();
    }

    options.extra[_retryCountExtraKey] = retryCount + 1;
    await Future<void>.delayed(const Duration(milliseconds: 200));
    try {
      final response = await _dio!.fetch<Object?>(options);
      return _RetryResolved(response);
    } on DioException catch (retryException) {
      return _RetryFailed(retryException);
    }
  }

  void _emitGlobalError(DioException exception) {
    final failure = AppFailure.from(exception);
    logAppFailure(failure, scope: 'api_global_error', error: exception);
    ref.read(appErrorProvider.notifier).emitFailure(failure);
  }
}

sealed class _RetryOutcome {
  const _RetryOutcome();
}

final class _RetryResolved extends _RetryOutcome {
  const _RetryResolved(this.response);

  final Response<Object?> response;
}

final class _RetryFailed extends _RetryOutcome {
  const _RetryFailed(this.exception);

  final DioException exception;
}

final class _RetrySkipped extends _RetryOutcome {
  const _RetrySkipped();
}
