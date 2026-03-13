import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/subsonic_protocol.dart';

void main() {
  test('isCacheableSubsonicMediaUri recognizes shared cover art protocol', () {
    final uri = Uri.parse(
      'https://example.com$subsonicCoverArtPath'
      '?id=cover-1&u=tester&t=token&s=salt&v=$subsonicApiVersion'
      '&c=$subsonicClientName&size=500',
    );

    expect(isCacheableSubsonicMediaUri(uri), isTrue);
  });

  test('isCacheableSubsonicMediaUri rejects incomplete auth query', () {
    final uri = Uri.parse(
      'https://example.com$subsonicStreamPath?id=song-1&u=tester&t=token',
    );

    expect(isCacheableSubsonicMediaUri(uri), isFalse);
  });

  test('buildCacheableSubsonicMediaDigest strips auth and metadata noise', () {
    final uri = Uri.parse(
      'https://example.com$subsonicStreamPath'
      '?id=song-1&u=tester&t=token&s=salt&v=$subsonicApiVersion'
      '&c=$subsonicClientName&_=${Uri.encodeComponent('stamp')}'
      '&maxBitRate=320',
    );

    final digest = buildCacheableSubsonicMediaDigest(uri);

    expect(
      digest,
      'https://example.com/rest/stream?id=song-1&maxBitRate=320',
    );
  });
}
