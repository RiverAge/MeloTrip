import 'dart:convert';
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
      final stream = file.openRead(startByte, endByte + 1);
      request.response
        ..statusCode =
            rangeHeader == null ? HttpStatus.ok : HttpStatus.partialContent
        ..headers.contentType = ContentType.binary
        ..headers.add(
          'Content-Range',
          'bytes${rangeHeader == null ? '' : ' $startByte-$endByte/$cacheSize'}',
        )
        ..headers.contentLength = endByte - startByte + 1;
      await stream.pipe(request.response);
      return;
    }

    final httpClient = HttpClient();
    final HttpClientRequest proxyRequest = await httpClient.getUrl(
      Uri.parse('$host${request.uri}'),
    );

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
    final lock = locks.putIfAbsent(digest, () => Lock());
    await lock.synchronized(() async {
      RandomAccessFile? raf;
      int filePointer = 0;
      try {
        final contentLength = _getContentLength(request.response);
        if (contentLength != 0 && request.response.statusCode < 300) {
          raf = await file.open(mode: FileMode.append);
          filePointer = file.existsSync() ? file.lengthSync() : 0;
        }
      } catch (e) {
        raf?.close();
      }
      int streamPointer = _getResponseStartBytes(request.response);

      await for (var data in proxyResponse) {
        if (streamPointer >= filePointer) {
          await raf?.setPosition(streamPointer);
          await raf?.writeFrom(data);
        }
        streamPointer += data.length;
        request.response.add(data);
        length += data.length;
      }
      await raf?.close();
    });
    if (locks[digest]?.locked == false) {
      locks.remove(digest);
    }
    await request.response.close();
  });
}
