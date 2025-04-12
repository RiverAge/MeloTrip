part of 'index.dart';

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
