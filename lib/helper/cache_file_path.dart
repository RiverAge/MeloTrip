import 'package:melo_trip/helper/cache_file_path_impl_stub.dart'
    if (dart.library.io) 'package:melo_trip/helper/cache_file_path_impl_io.dart'
    as impl;

Future<String> getCacheFilePath() => impl.getCacheFilePath();
