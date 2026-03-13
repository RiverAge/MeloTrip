import 'package:dio/dio.dart';
import 'package:melo_trip/provider/app_error/app_error.dart';
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
        onResponse: _onResponse,
        onError: _onError,
      ),
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final auth = await ref.read(currentUserProvider.future);
    final token = auth?.token;
    final host = auth?.host;

    if (token != null && host != null) {
      options.baseUrl = host;
      options.queryParameters.addAll({
        'u': auth?.username,
        't': token,
        's': auth?.salt,
        '_': DateTime.now().toIso8601String(),
        'v': '1.16.1',
        'c': 'melo_trip',
        'f': 'json',
      });
    }

    handler.next(options);
  }

  void _onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.requestOptions.responseType != ResponseType.stream &&
        response.data is Map<String, dynamic>?) {
      final Map<String, dynamic>? data = response.data as Map<String, dynamic>?;
      final Object? error = data?['subsonic-response']?['error'];
      if (error is Map<String, dynamic>) {
        final String? errorMessage = error['message'] as String?;
        if (errorMessage != null) {
          _emitGlobalError(errorMessage);
        }
      }
    }

    handler.next(response);
  }

  void _onError(
    DioException exception,
    ErrorInterceptorHandler handler,
  ) {
    final String? responseError =
        exception.response?.data is Map<String, dynamic>
            ? exception.response?.data['error'] as String?
            : null;
    final String? responseMessage = exception.message;
    final int? statusCode = exception.response?.statusCode;

    _emitGlobalError(responseError ?? responseMessage ?? '$statusCode');
    handler.next(exception);
  }

  void _emitGlobalError(String message) {
    ref.read(appErrorProvider.notifier).emit(message);
  }
}
