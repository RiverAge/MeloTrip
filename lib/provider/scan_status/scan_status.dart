import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/repository/scan_status/scan_status_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'scan_status.g.dart';

@riverpod
Future<Result<SubsonicResponse, AppFailure>> scanStatus(Ref ref) async {
  final repository = ref.read(scanStatusRepositoryProvider);
  return repository.fetchScanStatusResult();
}
