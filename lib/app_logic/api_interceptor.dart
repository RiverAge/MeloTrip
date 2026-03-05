part of '../app.dart';

extension _ApiInterceptorLogic on _MyAppState {
  void _initApiInterceptor() async {
    final api = await ref.read(apiProvider.future);

    api.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final auth = await ref.read(currentUserProvider.future);
          final subsonicToken = auth?.token;
          final host = auth?.host;
          if (subsonicToken != null && host != null) {
            options.baseUrl = host;
            options.queryParameters.addAll({
              'u': auth?.username,
              't': subsonicToken,
              's': auth?.salt,
              '_': DateTime.now().toIso8601String(),
              'v': '1.16.1',
              'c': 'melo_trip',
              'f': 'json',
            });
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (response.requestOptions.responseType != ResponseType.stream &&
              response.data is Map<String, dynamic>?) {
            final data = response.data;
            final error = data?['subsonic-response']?['error'];
            if (error is Map<String, dynamic>) {
              final errorMsg = error['message'] as String?;
              if (errorMsg != null) {
                _onErrorScanfoldMessage(errorMsg: errorMsg);
              }
            }
          }
          return handler.next(response);
        },
        onError: (response, handler) {
          final resError = response.response?.data["error"] as String?;
          final resMessage = response.message;
          final statusCode = response.response?.statusCode;
          _onErrorScanfoldMessage(
            errorMsg: resError ?? resMessage ?? '$statusCode',
          );
          return handler.next(response);
        },
      ),
    );
  }
}
