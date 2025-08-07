part of '../cache_server.dart';

int _getContentLength(HttpClientResponse response) {
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

int _getResponseStartBytes(HttpClientResponse response) {
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
