import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/helper/subsonic_protocol.dart';
import 'package:melo_trip/helper/subsonic_uri_builder.dart';

void main() {
  const auth = AuthUser(
    salt: 'salt',
    token: 'token',
    username: 'tester',
    host: 'https://example.com/',
  );

  test(
    'buildCoverArtUri uses web host auth parameters and shared metadata',
    () {
      final uri = SubsonicUriBuilder.buildCoverArtUri(
        auth: auth,
        artworkId: 'cover-1',
        size: 600,
      );

      expect(uri.path, '/rest/getCoverArt');
      expect(uri.queryParameters['id'], 'cover-1');
      expect(uri.queryParameters['size'], '600');
      expect(uri.queryParameters['u'], 'tester');
      expect(uri.queryParameters['t'], 'token');
      expect(uri.queryParameters['s'], 'salt');
      expect(uri.queryParameters['v'], subsonicApiVersion);
      expect(uri.queryParameters['c'], subsonicClientName);
      expect(uri.queryParameters.containsKey('f'), isFalse);
    },
  );

  test('buildStreamUri includes request timestamp and optional bitrate', () {
    final uri = SubsonicUriBuilder.buildStreamUri(
      auth: auth,
      songId: 'song-1',
      maxBitRate: '320',
    );

    expect(uri.path, '/rest/stream');
    expect(uri.queryParameters['id'], 'song-1');
    expect(uri.queryParameters['maxBitRate'], '320');
    expect(uri.queryParameters['_'], isNotEmpty);
    expect(uri.queryParameters['v'], subsonicApiVersion);
    expect(uri.queryParameters['c'], subsonicClientName);
    expect(uri.queryParameters.containsKey('f'), isFalse);
  });
}
