part of '../providers_extended_smoke_test.dart';

typedef JsonResolver = Map<String, dynamic>? Function(RequestOptions options);

class RecordingRouteAdapter implements HttpClientAdapter {
  RecordingRouteAdapter(this.resolver);

  final JsonResolver resolver;
  final List<RequestOptions> requests = [];

  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final payload = resolver(options);
    final body = payload == null ? 'null' : jsonEncode(payload);
    return ResponseBody.fromBytes(
      utf8.encode(body),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }
}

class FakeApiWithAdapter extends Api {
  FakeApiWithAdapter(this.adapter);

  final RecordingRouteAdapter adapter;

  @override
  Future<Dio> build() async {
    final dio = Dio();
    dio.httpClientAdapter = adapter;
    return dio;
  }
}
