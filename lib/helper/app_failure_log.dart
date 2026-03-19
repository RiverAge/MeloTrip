import 'dart:developer';

import 'package:melo_trip/model/common/app_failure.dart';

void logAppFailure(
  AppFailure failure, {
  required String scope,
  Object? error,
  StackTrace? stackTrace,
}) {
  final endpoint = failure.endpoint ?? '-';
  final requestId = failure.requestId ?? '-';
  final statusCode = failure.statusCode?.toString() ?? '-';
  final payload =
      '[${failure.type.name}] status=$statusCode endpoint=$endpoint requestId=$requestId message=${failure.message}';

  log(
    payload,
    name: scope,
    error: error ?? failure.cause ?? failure,
    stackTrace: stackTrace ?? failure.stackTrace,
  );
}
