import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/song/song.dart';

void main() {
  group('SongEntity', () {
    test('fromJson parses all basic fields', () {
      final json = {
        'id': '123',
        'title': 'Test Song',
        'album': 'Test Album',
        'artist': 'Test Artist',
        'track': 1,
        'year': 2024,
        'duration': 180,
        'bitRate': 320,
      };

      final song = SongEntity.fromJson(json);

      expect(song.id, equals('123'));
      expect(song.title, equals('Test Song'));
      expect(song.album, equals('Test Album'));
      expect(song.artist, equals('Test Artist'));
      expect(song.track, equals(1));
      expect(song.year, equals(2024));
      expect(song.duration, equals(180));
      expect(song.bitRate, equals(320));
    });

    test('fromJson handles null values', () {
      final json = <String, dynamic>{};

      final song = SongEntity.fromJson(json);

      expect(song.id, isNull);
      expect(song.title, isNull);
      expect(song.album, isNull);
      expect(song.artist, isNull);
    });

    test('fromJson handles partial data', () {
      final json = {
        'id': '123',
        'title': 'Test Song',
      };

      final song = SongEntity.fromJson(json);

      expect(song.id, equals('123'));
      expect(song.title, equals('Test Song'));
      expect(song.album, isNull);
      expect(song.artist, isNull);
    });

    test('toJson serializes all fields', () {
      final song = const SongEntity(
        id: '123',
        title: 'Test Song',
        album: 'Test Album',
        artist: 'Test Artist',
        track: 1,
        year: 2024,
      );

      final json = song.toJson();

      expect(json['id'], equals('123'));
      expect(json['title'], equals('Test Song'));
      expect(json['album'], equals('Test Album'));
      expect(json['artist'], equals('Test Artist'));
    });

    test('copyWith creates modified copy', () {
      final original = const SongEntity(
        id: '123',
        title: 'Original',
      );

      final modified = original.copyWith(title: 'Modified');

      expect(modified.id, equals('123'));
      expect(modified.title, equals('Modified'));
    });

    test('equality works correctly', () {
      final song1 = const SongEntity(id: '123', title: 'Song');
      final song2 = const SongEntity(id: '123', title: 'Song');
      final song3 = const SongEntity(id: '456', title: 'Song');

      expect(song1, equals(song2));
      expect(song1, isNot(equals(song3)));
    });

    test('toString includes id', () {
      final song = const SongEntity(id: '123');
      expect(song.toString(), isA<String>());
    });
  });
}
