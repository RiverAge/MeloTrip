import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_status.g.dart';

@riverpod
Future<SubsonicResponse?> scanStatus(Ref ref) async {
  final res = await Http.get<Map<String, dynamic>>('/rest/getScanStatus');
  final data = res?.data;
  if (data != null) {
    return SubsonicResponse.fromJson(data);
  }
  return null;
}
