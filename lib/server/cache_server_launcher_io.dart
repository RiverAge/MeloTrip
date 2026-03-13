import 'dart:isolate';

import 'package:melo_trip/server/cache_server.dart';

void startCacheServerIsolate({
  required String dirPath,
  required String host,
}) {
  Isolate.spawn(runHttpServer, {'dirPath': dirPath, 'host': host});
}
