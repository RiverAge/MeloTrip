import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/artist/artist.dart';

void main() {
  group('ArtistEntity', () {
    test('parses basic artist JSON', () {
      final json = {
        'id': 'art-123',
        'name': 'Test Artist',
        'coverArt': 'cover-art-123',
        'albumCount': 5,
        'artistImageUrl': 'https://example.com/artist.jpg',
      };

      final entity = ArtistEntity.fromJson(json);

      expect(entity.id, 'art-123');
      expect(entity.name, 'Test Artist');
      expect(entity.coverArt, 'cover-art-123');
      expect(entity.albumCount, 5);
      expect(entity.artistImageUrl, 'https://example.com/artist.jpg');
      expect(entity.album, isNull);
    });

    test('parses artist with albums', () {
      final json = {
        'id': 'art-456',
        'name': 'Artist With Albums',
        'albumCount': 2,
        'album': [
          {'id': 'alb-1', 'name': 'Album 1'},
          {'id': 'alb-2', 'name': 'Album 2'},
        ],
      };

      final entity = ArtistEntity.fromJson(json);

      expect(entity.id, 'art-456');
      expect(entity.name, 'Artist With Albums');
      expect(entity.albumCount, 2);
      expect(entity.album, isNotNull);
      expect(entity.album?.length, 2);
      expect(entity.album?.first.id, 'alb-1');
      expect(entity.album?.last.id, 'alb-2');
    });

    test('handles null fields', () {
      final json = <String, dynamic>{};
      final entity = ArtistEntity.fromJson(json);

      expect(entity.id, isNull);
      expect(entity.name, isNull);
      expect(entity.coverArt, isNull);
      expect(entity.albumCount, isNull);
      expect(entity.artistImageUrl, isNull);
      expect(entity.album, isNull);
    });

    test('handles missing albumCount', () {
      final json = {
        'id': 'art-789',
        'name': 'Artist Without Count',
      };

      final entity = ArtistEntity.fromJson(json);

      expect(entity.id, 'art-789');
      expect(entity.name, 'Artist Without Count');
      expect(entity.albumCount, isNull);
    });
  });
}
