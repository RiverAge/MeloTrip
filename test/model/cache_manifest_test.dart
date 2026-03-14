import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/cache_server/cache_manifest.dart';
import 'dart:io';

void main() {
  group('CacheManifest', () {
    test('fromJson creates instance with correct values', () {
      final json = {
        'contentType': 'audio/mpeg',
        'contentLength': 1024,
        'lastModified': 'Mon, 01 Jan 2024 00:00:00 GMT',
        'contentRange': 'bytes 0-1023/1024',
      };

      final entity = CacheManifest.fromJson(json);

      expect(entity.contentType?.mimeType, equals('audio/mpeg'));
      expect(entity.contentLength, equals(1024));
      expect(entity.lastModified, equals('Mon, 01 Jan 2024 00:00:00 GMT'));
      expect(entity.contentRange, equals('bytes 0-1023/1024'));
    });

    test('fromJson handles null values', () {
      final json = <String, dynamic>{};

      final entity = CacheManifest.fromJson(json);

      expect(entity.contentType, isNull);
      expect(entity.contentLength, isNull);
      expect(entity.lastModified, isNull);
      expect(entity.contentRange, isNull);
    });

    test('copyWith creates new instance with updated values', () {
      final original = CacheManifest(
        contentType: ContentType('audio', 'mpeg'),
        contentLength: 1024,
        lastModified: 'Mon, 01 Jan 2024 00:00:00 GMT',
        contentRange: 'bytes 0-1023/1024',
      );

      final copy = original.copyWith(
        contentLength: 2048,
        lastModified: 'Tue, 02 Jan 2024 00:00:00 GMT',
      );

      expect(copy.contentType, original.contentType);
      expect(copy.contentLength, equals(2048));
      expect(copy.lastModified, equals('Tue, 02 Jan 2024 00:00:00 GMT'));
      expect(copy.contentRange, equals(original.contentRange));
    });

    test('ContentTypeCovert converts from json', () {
      final converter = ContentTypeCovert();
      final result = converter.fromJson('audio/mpeg');
      expect(result.mimeType, equals('audio/mpeg'));
    });

    test('ContentTypeCovert converts to json', () {
      final converter = ContentTypeCovert();
      final contentType = ContentType('audio', 'mpeg');
      final result = converter.toJson(contentType);
      expect(result, equals('audio/mpeg'));
    });
  });
}
