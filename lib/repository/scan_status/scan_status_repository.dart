import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/repository/common/repository_guard.dart';
import 'package:melo_trip/repository/common/subsonic_response_parser.dart';

class ScanStatusRepository {
  ScanStatusRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse> fetchScanStatus() async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>('/rest/getScanStatus');
    return parseSubsonicResponseOrThrow(
      res.data,
      endpoint: '/rest/getScanStatus',
    );
  }

  Future<Result<SubsonicResponse, AppFailure>> fetchScanStatusResult() {
    return runGuarded(fetchScanStatus);
  }
}

final scanStatusRepositoryProvider = Provider<ScanStatusRepository>((ref) {
  return ScanStatusRepository(() => ref.read(apiProvider.future));
});
