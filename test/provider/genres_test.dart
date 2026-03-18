import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/genre/genre.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/genre/genres.dart';
import 'package:melo_trip/repository/genre/genres_repository.dart';

class _MockGenresRepository extends GenresRepository {
  _MockGenresRepository(this._fetchResponse, this._fetchItems)
      : super(() async => Dio());

  final SubsonicResponse? _fetchResponse;
  final List<GenreEntity> _fetchItems;
  bool responseCalled = false;
  bool itemsCalled = false;

  @override
  Future<SubsonicResponse> fetchGenresResponse() async {
    responseCalled = true;
    return _fetchResponse!;
  }

  @override
  Future<List<GenreEntity>> fetchGenresItems() async {
    itemsCalled = true;
    return _fetchItems;
  }
}

void main() {
  group('genresProvider', () {
    test('returns empty list when repository returns empty list', () async {
      final mockRepository = _MockGenresRepository(null, []);
      final container = ProviderContainer(
        overrides: [
          genresRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(genresProvider.future);

      expect(result, isEmpty);
      expect(mockRepository.itemsCalled, isTrue);
    });

    test('returns genre list from repository', () async {
      final mockGenres = [
        const GenreEntity(value: 'Rock', songCount: 10, albumCount: 2),
        const GenreEntity(value: 'Pop', songCount: 20, albumCount: 3),
      ];
      final mockRepository = _MockGenresRepository(null, mockGenres);
      final container = ProviderContainer(
        overrides: [
          genresRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(genresProvider.future);

      expect(result, isNotEmpty);
      expect(result.length, equals(2));
      expect(result.first.value, equals('Rock'));
      expect(result.first.songCount, equals(10));
      expect(mockRepository.itemsCalled, isTrue);
    });
  });

  group('fetchGenresItems', () {
    test('calls repository fetchGenresItems', () async {
      final mockRepository = _MockGenresRepository(null, []);
      final container = ProviderContainer(
        overrides: [
          genresRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      container.read(genresProvider);

      expect(mockRepository.itemsCalled, isTrue);
    });
  });
}
