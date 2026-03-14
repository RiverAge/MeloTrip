import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/starred/starred.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:melo_trip/repository/favorite/favorite_repository.dart';

class _MockFavoriteRepository extends FavoriteRepository {
  _MockFavoriteRepository(this._fetchResult) : super(() async => Dio());

  final SubsonicResponse? _fetchResult;
  bool fetchCalled = false;

  @override
  Future<SubsonicResponse?> fetchStarred() async {
    fetchCalled = true;
    return _fetchResult;
  }
}

void main() {
  group('favoriteProvider', () {
    test('returns null when repository returns null', () async {
      final mockRepository = _MockFavoriteRepository(null);
      final container = ProviderContainer(
        overrides: [
          favoriteRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(favoriteProvider.future);

      expect(result, isNull);
      expect(mockRepository.fetchCalled, isTrue);
    });

    test('returns starred response from repository', () async {
      final mockResponse = SubsonicResponse(
        subsonicResponse: const SubsonicResponseClass(
          status: 'ok',
          starred: StarredEntity(song: [], album: [], artist: []),
        ),
      );
      final mockRepository = _MockFavoriteRepository(mockResponse);
      final container = ProviderContainer(
        overrides: [
          favoriteRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(favoriteProvider.future);

      expect(result, isNotNull);
      expect(result?.subsonicResponse?.status, equals('ok'));
      expect(result?.subsonicResponse?.starred, isNotNull);
      expect(mockRepository.fetchCalled, isTrue);
    });
  });
}
