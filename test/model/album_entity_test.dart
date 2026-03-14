import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/album/album.dart';

void main() {
  group('AlbumEntity', () {
    test('fromJson parses all basic fields', () {
      final json = {
        'id': 'album123',
        'name': 'Test Album',
        'artist': 'Test Artist',
        'songCount': 10,
        'year': 2024,
      };

      final album = AlbumEntity.fromJson(json);

      expect(album.id, equals('album123'));
      expect(album.name, equals('Test Album'));
      expect(album.artist, equals('Test Artist'));
      expect(album.songCount, equals(10));
      expect(album.year, equals(2024));
    });

    test('fromJson handles null values', () {
      final json = <String, dynamic>{};

      final album = AlbumEntity.fromJson(json);

      expect(album.id, isNull);
      expect(album.name, isNull);
      expect(album.artist, isNull);
    });

    test('fromJson handles partial data', () {
      final json = {
        'id': 'album123',
        'name': 'Test Album',
      };

      final album = AlbumEntity.fromJson(json);

      expect(album.id, equals('album123'));
      expect(album.name, equals('Test Album'));
      expect(album.artist, isNull);
    });

    test('toJson serializes all fields', () {
      final album = const AlbumEntity(
        id: 'album123',
        name: 'Test Album',
        artist: 'Test Artist',
      );

      final json = album.toJson();

      expect(json['id'], equals('album123'));
      expect(json['name'], equals('Test Album'));
      expect(json['artist'], equals('Test Artist'));
    });

    test('copyWith creates modified copy', () {
      final original = const AlbumEntity(
        id: 'album123',
        name: 'Original',
      );

      final modified = original.copyWith(name: 'Modified');

      expect(modified.id, equals('album123'));
      expect(modified.name, equals('Modified'));
    });

    test('equality works correctly', () {
      final album1 = const AlbumEntity(id: '123', name: 'Album');
      final album2 = const AlbumEntity(id: '123', name: 'Album');
      final album3 = const AlbumEntity(id: '456', name: 'Album');

      expect(album1, equals(album2));
      expect(album1, isNot(equals(album3)));
    });
  });

  group('DiscTitle', () {
    test('fromJson parses fields', () {
      final json = {
        'disc': 1,
        'title': 'Disc One',
      };

      final discTitle = DiscTitle.fromJson(json);

      expect(discTitle.disc, equals(1));
      expect(discTitle.title, equals('Disc One'));
    });

    test('toJson serializes fields', () {
      final discTitle = const DiscTitle(disc: 1, title: 'Disc One');

      final json = discTitle.toJson();

      expect(json['disc'], equals(1));
      expect(json['title'], equals('Disc One'));
    });
  });

  group('ReleaseDate', () {
    test('fromJson parses fields', () {
      final json = {
        'year': 2024,
        'month': 1,
        'day': 15,
      };

      final releaseDate = ReleaseDate.fromJson(json);

      expect(releaseDate.year, equals(2024));
      expect(releaseDate.month, equals(1));
      expect(releaseDate.day, equals(15));
    });

    test('toJson serializes fields', () {
      final releaseDate = const ReleaseDate(year: 2024, month: 1, day: 15);

      final json = releaseDate.toJson();

      expect(json['year'], equals(2024));
      expect(json['month'], equals(1));
      expect(json['day'], equals(15));
    });
  });

  group('AlbumListEntity', () {
    test('fromJson parses list of albums', () {
      final json = {
        'album': [
          {'id': '1', 'name': 'Album 1'},
          {'id': '2', 'name': 'Album 2'},
        ],
      };

      final albumList = AlbumListEntity.fromJson(json);

      expect(albumList.album, isNotNull);
      expect(albumList.album!.length, equals(2));
      expect(albumList.album!.first.id, equals('1'));
      expect(albumList.album!.last.id, equals('2'));
    });

    test('fromJson handles null album list', () {
      final json = <String, dynamic>{};

      final albumList = AlbumListEntity.fromJson(json);

      expect(albumList.album, isNull);
    });

    test('toJson serializes album list', () {
      final albumList = const AlbumListEntity(album: [
        AlbumEntity(id: '1', name: 'Album 1'),
        AlbumEntity(id: '2', name: 'Album 2'),
      ]);

      final json = albumList.toJson();

      expect(json['album'], isA<List>());
      expect(json['album'].length, equals(2));
    });
  });
}
