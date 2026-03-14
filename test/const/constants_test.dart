import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/const/index.dart';

void main() {
  group('Constants', () {
    test('cacheServerPort is defined', () {
      expect(cacheServerPort, equals(19003));
    });

    test('proxyCacheHost contains correct port', () {
      expect(proxyCacheHost, contains('127.0.0.1'));
      expect(proxyCacheHost, contains('19003'));
    });

    test('proxyCacheHost format', () {
      expect(proxyCacheHost, startsWith('http://'));
    });
  });
}
