import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<String> getCacheFilePath() async {
  final cachDir = await getApplicationCacheDirectory();
  final packageInfo = await PackageInfo.fromPlatform();
  final path = p.join(cachDir.path, packageInfo.packageName);
  final dir = Directory(path);
  if (!dir.existsSync()) {
    await dir.create(recursive: true);
  }
  return path;
}
