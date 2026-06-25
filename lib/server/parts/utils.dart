part of '../cache_server.dart';

int _getContentLength(HttpClientResponse response) {
  return getContentLengthFromHeader(
    response.headers.value('content-range'),
    response.contentLength,
  );
}

int _getResponseStartBytes(HttpClientResponse response) {
  return getStartBytesFromContentRange(
    response.headers.value('content-range'),
  );
}

bool _isSubsonicStream(HttpRequest request) {
  return isCacheableSubsonicMediaUri(request.uri);
}

String _buildSubsonicStreamDigest(HttpRequest request) {
  return buildCacheableSubsonicMediaDigest(request.uri);
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

/// Extracts content length from HTTP response.
/// Parses Content-Range header or falls back to Content-Length.
@visibleForTesting
int getContentLengthFromHeader(String? contentRange, int fallbackContentLength) {
  if (contentRange != null) {
    final parts = contentRange.split('/');
    if (parts.length == 2) {
      final lengthStr = parts[1];
      return int.tryParse(lengthStr) ?? 0;
    }
  }
  return fallbackContentLength;
}

/// Extracts start byte from Content-Range header.
/// Returns 0 if header is missing or invalid.
@visibleForTesting
int getStartBytesFromContentRange(String? contentRange) {
  if (contentRange != null) {
    final parts = contentRange.replaceAll('bytes ', '').split('-');
    if (parts.length == 2) {
      final startStr = parts[0];
      return int.tryParse(startStr) ?? 0;
    }
  }
  return 0;
}
