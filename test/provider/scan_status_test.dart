import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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
  Future<SubsonicResponse?> fetchScanStatus() async {
    fetchCalled = true;
    return _fetchResult;
  }
}

void main() {
  group('scanStatusProvider', () {
    test('returns null when repository returns null', () async {
      final mockRepository = _MockScanStatusRepository(null);
      final container = ProviderContainer(
        overrides: [
          scanStatusRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(scanStatusProvider.future);

      expect(result, isNull);
      expect(mockRepository.fetchCalled, isTrue);
    });

    test('returns scan status response from repository', () async {
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

      final result = await container.read(scanStatusProvider.future);

      expect(result, isNotNull);
      expect(result?.subsonicResponse?.status, equals('ok'));
      expect(result?.subsonicResponse?.scanStatus, isNotNull);
      expect(mockRepository.fetchCalled, isTrue);
    });
  });
}
