import 'package:dio/dio.dart';
import 'package:melo_trip/helper/subsonic_protocol.dart';
import 'package:melo_trip/provider/app/error.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api.g.dart';

@Riverpod(keepAlive: true)
class Api extends _$Api {
  @override
  Future<Dio> build() async {
    final Dio dio = Dio();
    _configureInterceptors(dio);
    return dio;
  }

  void _configureInterceptors(Dio dio) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.queryParameters.putIfAbsent('_', () => DateTime.now().toIso8601String());
    options.queryParameters.putIfAbsent('v', () => subsonicApiVersion);
    options.queryParameters.putIfAbsent('c', () => subsonicClientName);
    options.queryParameters.putIfAbsent('f', () => 'json');

    final auth = await ref.read(currentUserProvider.future);
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

  void _onError(DioException exception, ErrorInterceptorHandler handler) {
    if (_isTransportFailure(exception)) {
      final String fallback =
          exception.message ?? exception.error?.toString() ?? exception.type.name;
      _emitGlobalError(fallback);
    }
    handler.next(exception);
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

  void _emitGlobalError(String message) {
    ref.read(appErrorProvider.notifier).emit(message);
  }
}
