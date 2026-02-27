import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';

class FakeAppPlayerHandler extends AppPlayerHandler {
  @override
  Future<AppPlayer?> build() async => null;
}

class FakeCurrentUserLoggedOut extends CurrentUser {
  @override
  Future<AuthUser?> build() async => null;
}

class FakeApiNull extends Api {
  @override
  Future<Dio> build() async {
    final dio = Dio();
    dio.httpClientAdapter = StaticJsonAdapter(null);
    return dio;
  }
}

class FakeApiAlbumList extends Api {
  @override
  Future<Dio> build() async {
    final dio = Dio();
    dio.httpClientAdapter = StaticJsonAdapter({
      'subsonic-response': {
        'status': 'ok',
        'albumList': {
          'album': [
            {'id': '1', 'name': 'Test Album', 'artist': 'Tester'},
          ],
        },
      },
    });
    return dio;
  }
}

class FakeApiScanStatus extends Api {
  @override
  Future<Dio> build() async {
    final dio = Dio();
    dio.httpClientAdapter = StaticJsonAdapter({
      'subsonic-response': {
        'status': 'ok',
        'version': '1.2.3',
      },
    });
    return dio;
  }
}

class StaticJsonAdapter implements HttpClientAdapter {
  StaticJsonAdapter(this.json);

  final Map<String, dynamic>? json;

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final payload = json == null ? 'null' : jsonEncode(json);
    return ResponseBody.fromBytes(
      utf8.encode(payload),
      200,
      headers: {Headers.contentTypeHeader: [Headers.jsonContentType]},
    );
  }
}
