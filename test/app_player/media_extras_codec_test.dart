import 'package:flutter_test/flutter_test.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/app_player/media_extras_codec.dart';
import 'package:melo_trip/model/response/song/song.dart';

void main() {
  group('media_extras_codec', () {
    test('buildMediaExtras stores song instance and stringified artUri', () {
      const song = SongEntity(id: 'song-1', title: 'Song', album: 'Album');
      final artUri = Uri.parse('https://proxy.example/rest/getCoverArt?id=1');

      final extras = buildMediaExtras(song: song, artUri: artUri);

      expect(extras[mediaExtraSong], same(song));
      expect(extras[mediaExtraArtUri], artUri.toString());
    });

    test('buildMediaExtras stores null artUri when omitted', () {
      const song = SongEntity(id: 'song-2', title: 'Track');

      final extras = buildMediaExtras(song: song);

      expect(extras[mediaExtraSong], same(song));
      expect(extras[mediaExtraArtUri], isNull);
    });

    test('readMediaSong / readMediaArtUri round-trip via Media.extras', () {
      const song = SongEntity(
        id: 'round-trip-1',
        title: 'Title',
        album: 'Album',
        artist: 'Artist',
        duration: 120,
      );
      final artUri = Uri.parse(
        'https://proxy.example/rest/getCoverArt?id=round-trip-1',
      );
      final media = Media(
        'https://proxy.example/rest/stream?id=round-trip-1',
        extras: buildMediaExtras(song: song, artUri: artUri),
      );

      expect(readMediaSong(media), same(song));
      expect(readMediaArtUri(media), artUri);
    });

    test('readMediaSong returns empty SongEntity when key is absent', () {
      final media = Media(
        'https://proxy.example/rest/stream?id=missing-song',
        extras: const <String, dynamic>{},
      );

      expect(readMediaSong(media), const SongEntity());
    });

    test('readMediaArtUri returns null when stored value is empty', () {
      const song = SongEntity(id: 'empty-art');
      final media = Media(
        'https://proxy.example/rest/stream?id=empty-art',
        extras: buildMediaExtras(song: song),
      );

      expect(readMediaArtUri(media), isNull);
    });

    test('readMediaArtUri returns null for invalid uri payloads', () {
      final media = Media(
        'https://proxy.example/rest/stream?id=invalid-art',
        extras: const <String, dynamic>{
          mediaExtraArtUri: 'http://[invalid',
        },
      );

      expect(readMediaArtUri(media), isNull);
    });
  });
}
