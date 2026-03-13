import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/auth_user/configuration.dart';

void main() {
  test('Configuration.fromJson decodes sqlite-style shuffle values', () {
    expect(
      Configuration.fromJson({'shuffle': 0}).shuffle,
      isFalse,
    );
    expect(
      Configuration.fromJson({'shuffle': 1}).shuffle,
      isTrue,
    );
    expect(
      Configuration.fromJson({'shuffle': false}).shuffle,
      isFalse,
    );
    expect(
      Configuration.fromJson({'shuffle': true}).shuffle,
      isTrue,
    );
    expect(
      Configuration.fromJson({'shuffle': '0'}).shuffle,
      isFalse,
    );
    expect(
      Configuration.fromJson({'shuffle': '1'}).shuffle,
      isTrue,
    );
    expect(
      Configuration.fromJson({'shuffle': 'false'}).shuffle,
      isFalse,
    );
    expect(
      Configuration.fromJson({'shuffle': 'true'}).shuffle,
      isTrue,
    );
  });

  test('Configuration.toJson encodes shuffle as sqlite integer flags', () {
    expect(
      const Configuration(shuffle: false).toJson()['shuffle'],
      0,
    );
    expect(
      const Configuration(shuffle: true).toJson()['shuffle'],
      1,
    );
  });
}
