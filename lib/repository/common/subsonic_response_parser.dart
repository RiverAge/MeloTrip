import 'package:melo_trip/model/response/subsonic_response.dart';

SubsonicResponse parseSubsonicResponseOrThrow(
  Map<String, dynamic>? data, {
  required String endpoint,
}) {
  if (data == null) {
    throw StateError('Empty response payload: $endpoint');
  }

  final response = SubsonicResponse.fromJson(data);
  final status = response.subsonicResponse?.status;
  final message = response.subsonicResponse?.error?.message;

  if (message != null && message.isNotEmpty) {
    throw StateError(message);
  }

  if (status != null && status != 'ok') {
    throw StateError('Subsonic request failed: $endpoint (status=$status)');
  }

  return response;
}
