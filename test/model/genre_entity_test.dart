import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/genre/genre.dart';

void main() {
  group('GenreEntity', () {
    test('fromJson parses all fields', () {
      final json = {
        'value': 'Rock',
        'songCount': 100,
        'albumCount': 10,
      };

      final genre = GenreEntity.fromJson(json);

      expect(genre.value, equals('Rock'));
      expect(genre.songCount, equals(100));
      expect(genre.albumCount, equals(10));
    });

    test('fromJson handles null values', () {
      final json = <String, dynamic>{};

      final genre = GenreEntity.fromJson(json);

      expect(genre.value, isNull);
      expect(genre.songCount, isNull);
      expect(genre.albumCount, isNull);
    });

    test('fromJson handles partial data', () {
      final json = {
        'value': 'Rock',
      };

      final genre = GenreEntity.fromJson(json);

      expect(genre.value, equals('Rock'));
      expect(genre.songCount, isNull);
      expect(genre.albumCount, isNull);
    });

    test('toJson serializes all fields', () {
      final genre = const GenreEntity(
        value: 'Rock',
        songCount: 100,
        albumCount: 10,
      );

      final json = genre.toJson();

      expect(json['value'], equals('Rock'));
      expect(json['songCount'], equals(100));
      expect(json['albumCount'], equals(10));
    });

    test('copyWith creates modified copy', () {
      final original = const GenreEntity(
        value: 'Rock',
        songCount: 100,
      );

      final modified = original.copyWith(songCount: 200);

      expect(modified.value, equals('Rock'));
      expect(modified.songCount, equals(200));
    });

    test('equality works correctly', () {
      final genre1 = const GenreEntity(value: 'Rock');
      final genre2 = const GenreEntity(value: 'Rock');
      final genre3 = const GenreEntity(value: 'Pop');

      expect(genre1, equals(genre2));
      expect(genre1, isNot(equals(genre3)));
    });
  });

  group('GenresEntity', () {
    test('fromJson parses list of genres', () {
      final json = {
        'genre': [
          {'value': 'Rock', 'songCount': 100},
          {'value': 'Pop', 'songCount': 50},
        ],
      };

      final genres = GenresEntity.fromJson(json);

      expect(genres.genre, isNotNull);
      expect(genres.genre!.length, equals(2));
      expect(genres.genre!.first.value, equals('Rock'));
      expect(genres.genre!.last.value, equals('Pop'));
    });

    test('fromJson handles null genre list', () {
      final json = <String, dynamic>{};

      final genres = GenresEntity.fromJson(json);

      expect(genres.genre, isNull);
    });

    test('toJson serializes genre list', () {
      final genres = const GenresEntity(genre: [
        GenreEntity(value: 'Rock'),
        GenreEntity(value: 'Pop'),
      ]);

      final json = genres.toJson();

      expect(json['genre'], isA<List>());
      expect(json['genre'].length, equals(2));
    });

    test('copyWith creates modified copy', () {
      final original = const GenresEntity(genre: [
        GenreEntity(value: 'Rock'),
      ]);

      final modified = original.copyWith(genre: [
        const GenreEntity(value: 'Pop'),
      ]);

      expect(modified.genre!.first.value, equals('Pop'));
    });
  });
}
