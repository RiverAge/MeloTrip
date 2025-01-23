import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cached_data.g.dart';

@riverpod
Future<double> imageCache(Ref ref) async {
  final sp = p.join((await getTemporaryDirectory()).path);
  final dir = Directory(sp);
  double size = 0;
  await dir.list(recursive: true).forEach((e) async {
    final stat = await e.stat();
    final filename = e.uri.path;
    if (filename.contains('/libCachedImageData')) size += stat.size;
  });
  return size;
}

@riverpod
Future<double> streamCache(Ref ref) async {
  final sp = p.join((await getTemporaryDirectory()).path);
  final dir = Directory(sp);
  double size = 0;
  await dir.list(recursive: true).forEach((e) async {
    final stat = await e.stat();
    final filename = e.uri.path;
    if (filename.contains('just_audio_cache')) size += stat.size;
  });
  return size;
}
