import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/response/scan_status/scan_status.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/scan_status/scan_status.dart';
import 'package:melo_trip/repository/scan_status/scan_status_repository.dart';

class _MockScanStatusRepository extends ScanStatusRepository {
  _MockScanStatusRepository(this._fetchResult)
      : super(() async => Dio());

  final SubsonicResponse? _fetchResult;
  bool fetchCalled = false;

  @override
  Future<SubsonicResponse> fetchScanStatus() async {
    fetchCalled = true;
    return _fetchResult!;
  }
}

void main() {
  group('scanStatusResultProvider', () {
    test('returns Result.err when repository throws', () async {
      final mockRepository = _MockScanStatusRepository(null);
      final container = ProviderContainer(
        overrides: [
          scanStatusRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(scanStatusResultProvider.future);

      expect(result.isErr, isTrue);
      expect(result.error, isA<AppFailure>());
      expect(mockRepository.fetchCalled, isTrue);
    });

    test('returns Result.ok scan status from repository', () async {
      final mockResponse = const SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(
          status: 'ok',
          scanStatus: ScanStatusEntity(scanning: false, count: 0),
        ),
      );
      final mockRepository = _MockScanStatusRepository(mockResponse);
      final container = ProviderContainer(
        overrides: [
          scanStatusRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(scanStatusResultProvider.future);

      expect(result, isNotNull);
      expect(result.data?.subsonicResponse?.status, equals('ok'));
      expect(result.data?.subsonicResponse?.scanStatus, isNotNull);
      expect(mockRepository.fetchCalled, isTrue);
    });
  });
}
