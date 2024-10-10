import 'dart:io';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cached_data.g.dart';

@riverpod
Future<double> imageCache(ImageCacheRef ref) async {
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
Future<double> streamCache(StreamCacheRef ref) async {
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
