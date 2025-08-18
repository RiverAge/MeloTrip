import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' hide log;

import 'package:crypto/crypto.dart';
import 'package:melo_trip/const/index.dart';
import 'package:melo_trip/model/cache_server/cache_manifest.dart';
import 'package:synchronized/synchronized.dart';
import 'package:path/path.dart' as p;

part 'parts/range.dart';
part 'parts/utils.dart';
part 'parts/meta_file.dart';

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
    final lock = locks.putIfAbsent(digest, () => Lock());

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

    final metaData = await _getMetaFromFile(p.join(metaPath, digest));

    if (endByte < cacheSize &&
        cacheSize > 0 &&
        startByte < cacheSize &&
        metaData != null &&
        (metaData.contentLength == -1 ||
            ('0-${(metaData.contentLength ?? 0) - 1}' ==
                metaData.contentRange))) {
      request.response.headers.contentType = metaData.contentType;

      final contentLength = metaData.contentLength;
      if (contentLength != null) {
        request.response.headers.contentLength = contentLength;
      }

      final lastModified = metaData.lastModified;
      if (lastModified != null) {
        request.response.headers.set('Last-Modified', lastModified);
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
    final proxyResponse = await proxyRequest.close();

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
    int streamPointer = _getResponseStartBytes(proxyResponse);

    await lock.synchronized(() async {
      RandomAccessFile? raf;
      try {
        final contentLength = _getContentLength(proxyResponse);
        if (contentLength != 0 && request.response.statusCode < 300) {
          raf = await file.open(mode: FileMode.append);
        }
        await raf?.setPosition(streamPointer);
        await raf?.writeFrom(chunks);
        log('写入缓存data ${request.uri.toString()}');

        _saveMetaFile(p.join(metaPath, digest), proxyResponse);
      } finally {
        await raf?.close();
      }
    });
    if (locks[digest]?.locked == false) {
      locks.remove(digest);
    }
  });
}
