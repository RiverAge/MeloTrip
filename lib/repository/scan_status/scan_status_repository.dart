import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/api/api.dart';

class ScanStatusRepository {
  ScanStatusRepository(this._readApi);

  final Future<Dio> Function() _readApi;

  Future<SubsonicResponse?> fetchScanStatus() async {
    final api = await _readApi();
    final res = await api.get<Map<String, dynamic>>('/rest/getScanStatus');
    final data = res.data;
    if (data == null) return null;
    return SubsonicResponse.fromJson(data);
  }
}

final scanStatusRepositoryProvider = Provider<ScanStatusRepository>((ref) {
  return ScanStatusRepository(() => ref.read(apiProvider.future));
});
