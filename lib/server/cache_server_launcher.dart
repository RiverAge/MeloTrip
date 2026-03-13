import 'package:melo_trip/server/cache_server_launcher_stub.dart'
    if (dart.library.io) 'package:melo_trip/server/cache_server_launcher_io.dart'
    as impl;

void startCacheServerIsolate({
  required String dirPath,
  required String host,
}) {
  impl.startCacheServerIsolate(dirPath: dirPath, host: host);
}
