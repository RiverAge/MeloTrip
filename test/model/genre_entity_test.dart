import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/genre/genre.dart';

void main() {
  group('GenreEntity', () {
    test('fromJson creates instance with correct values', () {
      final json = {
        'value': 'Rock',
        'songCount': 100,
        'albumCount': 10,
      };

      final entity = GenreEntity.fromJson(json);

      expect(entity.value, 'Rock');
      expect(entity.songCount, 100);
      expect(entity.albumCount, 10);
    });

    test('fromJson handles null values', () {
      final json = <String, dynamic>{};

      final entity = GenreEntity.fromJson(json);

      expect(entity.value, null);
      expect(entity.songCount, null);
      expect(entity.albumCount, null);
    });

    test('copyWith creates new instance with updated values', () {
      final original = GenreEntity(
        value: 'Rock',
        songCount: 100,
        albumCount: 10,
      );

      final copy = original.copyWith(
        songCount: 200,
        albumCount: 20,
      );

      expect(copy.value, 'Rock');
      expect(copy.songCount, 200);
      expect(copy.albumCount, 20);
    });
  });

  group('GenresEntity', () {
    test('fromJson creates instance with genre list', () {
      final json = {
        'genre': [
          {'value': 'Rock', 'songCount': 100, 'albumCount': 10},
          {'value': 'Pop', 'songCount': 50, 'albumCount': 5},
        ],
      };

      final entity = GenresEntity.fromJson(json);

      expect(entity.genre, isNotNull);
      expect(entity.genre!.length, 2);
      expect(entity.genre!.first.value, 'Rock');
      expect(entity.genre!.last.value, 'Pop');
    });

    test('fromJson handles null genre list', () {
      final json = <String, dynamic>{};

      final entity = GenresEntity.fromJson(json);

      expect(entity.genre, null);
    });

    test('copyWith creates new instance with updated values', () {
      final original = GenresEntity(
        genre: [GenreEntity(value: 'Rock')],
      );

      final copy = original.copyWith(
        genre: [GenreEntity(value: 'Pop')],
      );

      expect(copy.genre!.first.value, 'Pop');
    });
  });
}
