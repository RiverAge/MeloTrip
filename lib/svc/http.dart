import 'dart:async';

import 'package:dio/dio.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/svc/user.dart';
import 'package:uuid/v4.dart';

typedef MessageCallback =
    void Function({required String errorMsg, int? statusCode});

class Http {
  final _dio = Dio();
  final clientId = const UuidV4();
  User? _user;

  Http._();

  final List<MessageCallback> _errorListeners = [];

  addErrorScanfoldMessageListner(MessageCallback listener) {
    if (!_errorListeners.contains(listener)) {
      _errorListeners.add(listener);
    }
  }

  removeErrorScanfoldMessageListner(MessageCallback listener) {
    if (_errorListeners.contains(listener)) {
      _errorListeners.remove(listener);
    }
  }

  static Completer<Http>? _completer;

  static Future<Http> get instance async {
    if (_completer == null) {
      final completer = Completer<Http>();
      _completer = completer;
      final instance = Http._();
      final u = await User.instance;
      instance._user = u;
      completer.complete(instance);
    }
    return _completer!.future;
  }

  static Future<Response<T>?> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ResponseType? responseType,
  }) async => _fetch(
    RequestOptions(
      path: url,
      method: 'GET',
      queryParameters: queryParameters,
      responseType: responseType,
      cancelToken: cancelToken,
    ),
    url.startsWith('/rest'),
  );

  static Future<Response<T>?> post<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    dynamic data,
    ResponseType? responseType,
  }) async => _fetch(
    RequestOptions(
      path: url,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      responseType: responseType,
      cancelToken: cancelToken,
    ),
    url.startsWith('/rest'),
  );

  static Future<Response<T>?> _fetch<T>(
    RequestOptions requestOptions,
    bool withSubsonicParams,
  ) async {
    final ins = await Http.instance;
    final auth = ins._user?.auth;
    if (auth?.host != null) {
      requestOptions.baseUrl = auth!.host!;
    }
    if (withSubsonicParams) {
      requestOptions.path = await buildSubsonicUrl(requestOptions.path);
    } else {
      if (auth?.token != null) {
        requestOptions.headers['X-Nd-Authorization'] = 'Bearer ${auth?.token}';
        requestOptions.headers['X-Nd-Client-Unique-Id'] = ins.clientId;
      }
    }

    try {
      final res = await ins._dio.fetch<T>(requestOptions);

      final data = res.data;
      if (data is Map<String, dynamic>?) {
        final error = data?['subsonic-response']?['error'];
        if (error is Map<String, dynamic>) {
          final code = error['code'];
          final message = error['message'];
          if (code != null || message != null) {
            for (final l in ins._errorListeners) {
              l(errorMsg: message, statusCode: code);
            }
          }
        }
      }

      return res;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        return null;
      }
      String msg = '';
      if (e.response?.data != null) {
        msg = e.response?.data["error"];
      } else if (e.message != null && e.message != '') {
        msg = e.message!;
      }
      for (final l in ins._errorListeners) {
        l(errorMsg: msg, statusCode: e.response?.statusCode);
      }
    }
    return null;
  }
}
