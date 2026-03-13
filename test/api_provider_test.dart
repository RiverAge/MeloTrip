import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app_error/app_error.dart';
import 'package:melo_trip/provider/auth/auth.dart';

void main() {
  test('apiProvider injects auth and subsonic query parameters', () async {
    final container = ProviderContainer(
      overrides: [
        currentUserProvider.overrideWith(FakeCurrentUserLoggedIn.new),
      ],
    );
    addTearDown(container.dispose);

    final Dio api = await container.read(apiProvider.future);
    final RecordingAdapter adapter = RecordingAdapter((options) {
      expect(options.baseUrl, 'https://example.com');
      expect(options.queryParameters['u'], 'tester');
      expect(options.queryParameters['t'], 'token');
      expect(options.queryParameters['s'], 'salt');
      expect(options.queryParameters['v'], '1.16.1');
      expect(options.queryParameters['c'], 'melo_trip');
      expect(options.queryParameters['f'], 'json');
      expect(options.queryParameters['_'], isA<String>());
      return {
        'subsonic-response': {'status': 'ok'},
      };
    });
    api.httpClientAdapter = adapter;

    await api.get('/rest/getAlbumList');
    expect(adapter.lastRequestPath, '/rest/getAlbumList');
  });

  test(
    'apiProvider forwards subsonic response errors to app error bus',
    () async {
      final container = ProviderContainer(
        overrides: [
          currentUserProvider.overrideWith(FakeCurrentUserLoggedIn.new),
        ],
      );
      addTearDown(container.dispose);

      final Dio api = await container.read(apiProvider.future);
      api.httpClientAdapter = RecordingAdapter((_) {
        return {
          'subsonic-response': {
            'status': 'failed',
            'error': {'message': 'server boom'},
          },
        };
      });

      await api.get('/rest/getAlbumList');

      final AppErrorEvent? error = container.read(appErrorProvider);
      expect(error?.message, 'server boom');
    },
  );
}

class FakeCurrentUserLoggedIn extends CurrentUser {
  @override
  Future<AuthUser?> build() async {
    return const AuthUser(
      salt: 'salt',
      token: 'token',
      username: 'tester',
      host: 'https://example.com',
    );
  }
}

class RecordingAdapter implements HttpClientAdapter {
  RecordingAdapter(this._buildJson);

  final Map<String, dynamic> Function(RequestOptions options) _buildJson;
  String? lastRequestPath;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    lastRequestPath = options.path;
    final Map<String, dynamic> payload = _buildJson(options);
    return ResponseBody.fromBytes(
      utf8.encode(jsonEncode(payload)),
      200,
      headers: <String, List<String>>{
        Headers.contentTypeHeader: <String>[Headers.jsonContentType],
      },
    );
  }
}
