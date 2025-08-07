part of '../cache_server.dart';

class _MetaStruct {
  ContentType? contentType;
  int? contentLength;
  String? lastModified;
  String? contentRange;

  @override
  String toString() {
    return 'contentType: $contentType contentLength: $contentLength lastModified: $lastModified contentRange: $contentRange';
  }
}

Future<_MetaStruct?> _getMetaFromFile(String metaFilePath) async {
  final metaFile = File(metaFilePath);
  if (metaFile.existsSync()) {
    final metaJson = await metaFile.readAsString();

    final metaMap = jsonDecode(metaJson) as Map<String, dynamic>;

    final metaStruct = _MetaStruct();

    metaStruct.contentLength = metaMap['contentLength'];

    metaStruct.lastModified = metaMap['lastModified'];
    if (metaMap['contentType'] != null) {
      metaStruct.contentType = ContentType.parse(metaMap['contentType']);
    }
    metaStruct.contentRange = metaMap['contentRange'];

    return metaStruct;
  }
  return null;
}

Future<void> _saveMetaFile(
  String metaFilePath,
  HttpClientResponse response,
) async {
  // 1. 准备要缓存的元数据
  final metaData = {
    'contentType': response.headers.contentType?.toString(),
    // 你还可以存储其他有用的头信息，比如 ETag 或 Last-Modified
    'lastModified': response.headers.value('Last-Modified'),
    'contentLength': _getContentLength(response),
  };
  final metaFile = File(metaFilePath);

  if (metaFile.existsSync()) {
    final metaJson = await metaFile.readAsString();
    final metaMap = jsonDecode(metaJson) as Map<String, dynamic>;
    final String? metaRangeStr = metaMap['contentRange'];
    List<String>? metaRangeList;

    if (metaRangeStr != null) {
      metaRangeList = metaRangeStr.split(',');
    }

    final contentRangeRaw = response.headers.value('Content-Range');
    String? resRangeBytes;

    if (contentRangeRaw != null) {
      final cParts = contentRangeRaw.split('/');
      if (cParts.length == 2) {
        resRangeBytes = cParts[0].replaceAll('bytes ', '');
      }
    }

    if (resRangeBytes != null) {
      final mergeR = _mergeRanges(metaRangeList ?? [], resRangeBytes);
      final ret = mergeR.map((e) => e.toString()).join(',');
      metaData['contentRange'] = ret;
    }
  }

  await metaFile.writeAsString(jsonEncode(metaData));
  log('写入缓存meta ${jsonEncode(metaData)}');
}
