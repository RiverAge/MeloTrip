part of '../cache_server.dart';

Future<CacheManifest?> _getMetaFromFile(String metaFilePath) async {
  final metaFile = File(metaFilePath);
  if (metaFile.existsSync()) {
    final metaJson = await metaFile.readAsString();
    final metaMap = jsonDecode(metaJson) as Map<String, dynamic>;
    final metaStruct = CacheManifest.fromJson(metaMap);

    return metaStruct;
  }
  return null;
}

Future<void> _saveMetaFile(
  String metaFilePath,
  HttpClientResponse response,
) async {
  // final cacheManifest = CacheManifest();
  // 1. 准备要缓存的元数据
  final contentRange = await _updateContentRange(
    metaFilePath,
    response.headers.value('Content-Range'),
  );

  final metaFile = File(metaFilePath);

  final str = jsonEncode(
    CacheManifest(
      contentType: response.headers.contentType,
      lastModified: response.headers.value('Last-Modified'),
      contentRange: contentRange,
      contentLength: _getContentLength(response),
    ).toJson(),
  );
  await metaFile.writeAsString(str);
  log('写入缓存meta $str');
}

Future<String?> _updateContentRange(
  String metaFilePath,
  String? contentRangeRes,
) async {
  final manifestFile = await _getMetaFromFile(metaFilePath);
  if (manifestFile != null) {
    final String? effectiveContentRange = manifestFile.contentRange;
    List<String>? metaRangeList;
    if (effectiveContentRange != null) {
      metaRangeList = effectiveContentRange.split(',');
    }

    String? resRangeBytes;

    if (contentRangeRes != null) {
      final cParts = contentRangeRes.split('/');
      if (cParts.length == 2) {
        resRangeBytes = cParts[0].replaceAll('bytes ', '');
      }
    }

    if (resRangeBytes != null) {
      final mergeR = _mergeRanges(metaRangeList ?? [], resRangeBytes);
      final ret = mergeR.map((e) => e.toString()).join(',');
      return ret;
    }
  }
  return null;
}
