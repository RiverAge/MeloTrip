import 'package:flutter/foundation.dart';
import 'package:melo_trip/const/index.dart';
import 'package:melo_trip/helper/subsonic_protocol.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';

class SubsonicUriBuilder {
  const SubsonicUriBuilder._();

  static Uri buildCoverArtUri({
    required AuthUser? auth,
    required String artworkId,
    int? size,
  }) {
    return buildRestUri(
      auth: auth,
      path: subsonicCoverArtPath,
      queryParameters: <String, String?>{
        'id': artworkId,
        'size': '${size ?? 500}',
      },
      includeResponseFormat: false,
    );
  }

  static Uri buildStreamUri({
    required AuthUser? auth,
    required String songId,
    String? maxBitRate,
  }) {
    return buildRestUri(
      auth: auth,
      path: subsonicStreamPath,
      queryParameters: <String, String?>{
        'id': songId,
        'maxBitRate': maxBitRate,
      },
      includeRequestTimestamp: true,
      includeResponseFormat: false,
    );
  }

  static Uri buildRestUri({
    required AuthUser? auth,
    required String path,
    Map<String, String?> queryParameters = const <String, String?>{},
    bool includeRequestTimestamp = false,
    bool includeResponseFormat = true,
  }) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse(_resolveBaseHost(auth: auth)).replace(
      path: normalizedPath,
      queryParameters: <String, String?>{
        ..._buildAuthQueryParameters(
          auth: auth,
          includeRequestTimestamp: includeRequestTimestamp,
          includeResponseFormat: includeResponseFormat,
        ),
        ...queryParameters,
      }..removeWhere((_, value) => value == null || value.isEmpty),
    );
  }

  static String _resolveBaseHost({required AuthUser? auth}) {
    final host = auth?.host;
    final baseHost = kIsWeb ? host : proxyCacheHost;
    if (baseHost == null || baseHost.isEmpty) {
      return proxyCacheHost;
    }
    return baseHost.endsWith('/')
        ? baseHost.substring(0, baseHost.length - 1)
        : baseHost;
  }

  static Map<String, String?> _buildAuthQueryParameters({
    required AuthUser? auth,
    required bool includeRequestTimestamp,
    required bool includeResponseFormat,
  }) {
    return <String, String?>{
      'u': auth?.username,
      't': auth?.token,
      's': auth?.salt,
      if (includeRequestTimestamp) '_': DateTime.now().toIso8601String(),
      'v': subsonicApiVersion,
      'c': subsonicClientName,
      if (includeResponseFormat) 'f': 'json',
    };
  }
}
