import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:melo_trip/helper/cache_file_path.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cached_data.g.dart';

@riverpod
Future<double> cachedFileSize(Ref ref) async {
  if (kIsWeb) {
    return 0;
  }
  final sp = await getCacheFilePath();
  final dir = Directory(sp);
  double size = 0;
  await for (var entity in dir.list(recursive: true, followLinks: false)) {
    if (entity is File) {
      size += await entity.length();
    }
  }
  return size;
}
