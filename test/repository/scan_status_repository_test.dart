import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/repository/scan_status/scan_status_repository.dart';

void main() {
  group('ScanStatusRepository', () {
    late ProviderContainer container;
    late MockApiAdapter mockAdapter;

    setUp(() {
      mockAdapter = MockApiAdapter();
      container = ProviderContainer(
        overrides: [
          scanStatusRepositoryProvider.overrideWith((ref) {
            return ScanStatusRepository(() async => _createMockDio(mockAdapter));
          }),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('fetchScanStatus sends correct request', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'scanStatus': {'scanning': false},
        },
      });

      final repository = container.read(scanStatusRepositoryProvider);
      await repository.fetchScanStatus();

      expect(mockAdapter.lastRequest?.path, '/rest/getScanStatus');
    });

    test('fetchScanStatus returns parsed response when scanning', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'scanStatus': {
            'scanning': true,
            'count': 1500,
          },
        },
      });

      final repository = container.read(scanStatusRepositoryProvider);
      final result = await repository.fetchScanStatus();

      expect(result, isNotNull);
      expect(result.subsonicResponse?.scanStatus?.scanning, true);
      expect(result.subsonicResponse?.scanStatus?.count, 1500);
    });

    test('fetchScanStatus returns parsed response when not scanning', () async {
      mockAdapter.setResponse({
        'subsonic-response': {
          'status': 'ok',
          'scanStatus': {'scanning': false},
        },
      });

      final repository = container.read(scanStatusRepositoryProvider);
      final result = await repository.fetchScanStatus();

      expect(result, isNotNull);
      expect(result.subsonicResponse?.scanStatus?.scanning, false);
    });

    test('fetchScanStatus returns null for null data', () async {
      mockAdapter.setResponse(null);

      final repository = container.read(scanStatusRepositoryProvider);
      final result = await repository.fetchScanStatus();

      expect(result, isNull);
    });
  });
}

Dio _createMockDio(MockApiAdapter adapter) {
  final dio = Dio(BaseOptions(baseUrl: 'https://test.example.com'));
  dio.httpClientAdapter = adapter;
  return dio;
}

class MockApiAdapter implements HttpClientAdapter {
  Map<String, dynamic>? _response;
  RequestOptions? lastRequest;

  void setResponse(Map<String, dynamic>? response) {
    _response = response;
  }

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequest = options;
    if (_response == null) {
      return ResponseBody.fromBytes(
        utf8.encode(''),
        200,
        headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
      );
    }
    return ResponseBody.fromBytes(
      utf8.encode(jsonEncode(_response)),
      200,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );
  }
}
