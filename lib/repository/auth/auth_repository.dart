import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/helper/subsonic_protocol.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/repository/common/repository_guard.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

class AuthRepository {
  AuthRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse> ping({
    required String host,
    required String username,
    required String token,
    required String salt,
  }) async {
    final api = await _readApi();
    final endpoint = '$host/rest/ping';
    final res = await api.get<Map<String, dynamic>>(
      endpoint,
      queryParameters: {
        'u': username,
        't': token,
        's': salt,
        '_': DateTime.now().toIso8601String(),
        'v': subsonicApiVersion,
        'c': subsonicClientName,
        'f': 'json',
      },
    );
    return parseSubsonicResponseOrThrow(res.data, endpoint: endpoint);
  }

  Future<Result<SubsonicResponse, AppFailure>> tryPing({
    required String host,
    required String username,
    required String token,
    required String salt,
  }) {
    return runGuarded(
      () => ping(host: host, username: username, token: token, salt: salt),
    );
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(() => ref.read(apiProvider.future));
});
