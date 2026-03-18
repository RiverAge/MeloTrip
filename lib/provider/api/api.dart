import 'package:dio/dio.dart';
import 'package:melo_trip/helper/subsonic_protocol.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
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
        onResponse: _onResponse,
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

  void _onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.requestOptions.responseType != ResponseType.stream) {
      final errorMessage = _extractSubsonicErrorMessage(response.data);
      if (errorMessage != null) {
        _emitGlobalError(errorMessage);
      }
    }

    handler.next(response);
  }

  void _onError(DioException exception, ErrorInterceptorHandler handler) {
    final String? responseError = _extractSubsonicErrorMessage(
      exception.response?.data,
    );
    final String? plainResponseError =
        exception.response?.data is Map<String, dynamic>
        ? (exception.response?.data as Map<String, dynamic>)['error'] as String?
        : null;
    final String? responseMessage = exception.message;
    final int? statusCode = exception.response?.statusCode;

    _emitGlobalError(
      responseError ?? plainResponseError ?? responseMessage ?? '$statusCode',
    );
    handler.next(exception);
  }

  String? _extractSubsonicErrorMessage(dynamic payload) {
    if (payload is! Map<String, dynamic>) {
      return null;
    }

    try {
      final response = SubsonicResponse.fromJson(payload);
      return response.subsonicResponse?.error?.message;
    } catch (_) {
      return null;
    }
  }

  void _emitGlobalError(String message) {
    ref.read(appErrorProvider.notifier).emit(message);
  }
}
