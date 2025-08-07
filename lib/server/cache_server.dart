import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:melo_trip/const/index.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart' as p;

int _getContentLength(HttpResponse response) {
  final contentRange = response.headers.value('content-range');
  if (contentRange != null) {
    final parts = contentRange.split('/');
    if (parts.length == 2) {
      final lengthStr = parts[1];
      return int.tryParse(lengthStr) ?? 0;
    }
  }
  return response.contentLength;
}

int _getResponseStartBytes(HttpResponse response) {
  final contentRange = response.headers.value('content-range');
  if (contentRange != null) {
    final parts = contentRange.replaceAll('bytes ', '').split('-');
    if (parts.length == 2) {
      final startStr = parts[0];
      return int.tryParse(startStr) ?? 0;
    }
  }
  return 0;
}

bool _isSubsonicStream(HttpRequest request) {
  if (request.uri.path != '/rest/stream' &&
      request.uri.path != '/rest/getCoverArt') {
    return false;
  }
  const requiredParams = ['u', 't', 's', 'v', 'c', 'id'];
  return requiredParams.every(
    (param) => request.uri.queryParameters.containsKey(param),
  );
}

String _buildSubsonicStreamDigest(HttpRequest request) {
  return request.uri
      .replace(
        queryParameters:
            Map.from(request.uri.queryParameters)
              ..remove('u')
              ..remove('t')
              ..remove('s')
              ..remove('c')
              ..remove('_'),
      )
      .toString();
}

Future<bool> _isPortAvailable(int port) async {
  try {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    await server.close();
    return true;
  } catch (e) {
    return false;
  }
}

int length = 0;
void runHttpServer(Map<String, dynamic> args) async {
  final String? dirPath = args['dirPath'];
  final String? host = args['host'];

  if (dirPath == null || host == null) {
    return;
  }

  if (!await _isPortAvailable(cacheServerPort)) {
    return;
  }

  final String metaPath = p.join(dirPath, '.meta');
  Directory(metaPath).createSync();

  final server = await HttpServer.bind(
    InternetAddress.anyIPv4,
    cacheServerPort,
  );
  final locks = <String, Lock>{};
  // 异步处理请求，非阻塞
  server.listen((HttpRequest request) async {
    final digest =
        md5
            .convert(
              utf8.encode(
                _isSubsonicStream(request)
                    ? _buildSubsonicStreamDigest(request)
                    : request.uri.toString(),
              ),
            )
            .toString();
    final file = File(p.join(dirPath, digest));
    final cacheSize = file.existsSync() ? file.lengthSync() : 0;
    final rangeHeader = request.headers.value('range');

    int startByte = 0, endByte = cacheSize - 1;
    if (rangeHeader != null) {
      final math = RegExp(r'bytes=(\d+)-(\d+)?').firstMatch(rangeHeader);
      if (math != null) {
        startByte = int.parse(math.group(1)!);
        if (math.group(2) != null) {
          endByte = int.parse(math.group(2)!);
        }
      }
    }

    if (endByte < cacheSize && cacheSize > 0 && startByte < cacheSize) {
      final metaFile = File(p.join(metaPath, digest));
      if (metaFile.existsSync()) {
        final metaJson = await metaFile.readAsString();
        final metadata = jsonDecode(metaJson) as Map<String, dynamic>;
        // 3. 将元数据应用到当前的响应头中
        if (metadata['contentType'] != null) {
          request.response.headers.contentType = ContentType.parse(
            metadata['contentType'],
          );
        }
        if (metadata['lastModified'] != null) {
          // HTTP头的key是大小写不敏感的，但通常用 'Last-Modified'
          request.response.headers.set(
            'Last-Modified',
            metadata['lastModified'],
          );
        }
      } else {
        request.response.headers.contentType = ContentType.binary;
      }

      final stream = file.openRead(startByte, endByte + 1);
      request.response
        ..statusCode =
            rangeHeader == null ? HttpStatus.ok : HttpStatus.partialContent
        ..headers.add(
          'Content-Range',
          'bytes${rangeHeader == null ? '' : ' $startByte-$endByte/$cacheSize'}',
        )
        ..headers.contentLength = endByte - startByte + 1;
      await stream.pipe(request.response);
      log('缓存命中 ${request.uri.toString()}');
      return;
    }

    final httpClient = HttpClient();
    httpClient.autoUncompress = false;
    final HttpClientRequest proxyRequest = await httpClient.getUrl(
      Uri.parse('$host${request.uri}'),
    );
    proxyRequest.followRedirects = false;

    request.headers.forEach((key, value) {
      proxyRequest.headers.add(key, value);
    });

    final hostHeader = Uri.parse(host);
    proxyRequest.headers.add(
      'host',
      hostHeader.hasPort
          ? '${hostHeader.host}:${hostHeader.port}'
          : hostHeader.host,
    );
    final HttpClientResponse proxyResponse = await proxyRequest.close();

    proxyResponse.headers.forEach((key, values) {
      for (var value in values) {
        request.response.headers.add(key, value);
      }
    });
    request.response.statusCode = proxyResponse.statusCode;

    final List<int> chunks = [];
    await for (var data in proxyResponse) {
      request.response.add(data);
      chunks.addAll(data);
    }
    await request.response.close();
    int streamPointer = _getResponseStartBytes(request.response);

    final lock = locks.putIfAbsent(digest, () => Lock());
    await lock.synchronized(() async {
      RandomAccessFile? raf;
      try {
        final contentLength = _getContentLength(request.response);
        if (contentLength != 0 && request.response.statusCode < 300) {
          raf = await file.open(mode: FileMode.append);
        }
        await raf?.setPosition(streamPointer);
        await raf?.writeFrom(chunks);
        log('写入缓存data ${request.uri.toString()}');
      } finally {
        await raf?.close();
      }
    });
    if (locks[digest]?.locked == false) {
      locks.remove(digest);
    }

    // 1. 准备要缓存的元数据
    final metadata = {
      'contentType': proxyResponse.headers.contentType?.toString(),
      // 你还可以存储其他有用的头信息，比如 ETag 或 Last-Modified
      'lastModified': proxyResponse.headers.value('Last-Modified'),
    };
    final metaFile = File(p.join(metaPath, digest));
    await metaFile.writeAsString(jsonEncode(metadata));
    log('写入缓存meta ${request.uri.toString()}');
  });
}
