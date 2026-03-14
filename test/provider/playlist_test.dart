import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/repository/playlist/playlist_repository.dart';

class _MockPlaylistRepository extends PlaylistRepository {
  _MockPlaylistRepository(this._fetchResult) : super(() async => Dio());

  final SubsonicResponse? _fetchResult;
  bool fetchCalled = false;
  bool createCalled = false;
  bool deleteCalled = false;
  bool updateCalled = false;

  @override
  Future<SubsonicResponse?> fetchPlaylists() async {
    fetchCalled = true;
    return _fetchResult;
  }

  @override
  Future<SubsonicResponse?> fetchPlaylistDetail(String playlistId) async {
    fetchCalled = true;
    return _fetchResult;
  }

  @override
  Future<SubsonicResponse?> createPlaylist(String name) async {
    createCalled = true;
    return _fetchResult;
  }

  @override
  Future<SubsonicResponse?> deletePlaylist(String playlistId) async {
    deleteCalled = true;
    return _fetchResult;
  }

  @override
  Future<SubsonicResponse?> updatePlaylist({
    required String playlistId,
    int? songIndexToRemove,
    String? songIdToAdd,
    String? name,
    String? comment,
    bool? public,
  }) async {
    updateCalled = true;
    return _fetchResult;
  }
}

void main() {
  group('playlistsProvider', () {
    test('returns null when repository returns null', () async {
      final mockRepository = _MockPlaylistRepository(null);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(playlistsProvider.future);

      expect(result, isNull);
      expect(mockRepository.fetchCalled, isTrue);
    });

    test('returns playlists response from repository', () async {
      final mockResponse = const SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(status: 'ok'),
      );
      final mockRepository = _MockPlaylistRepository(mockResponse);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(playlistsProvider.future);

      expect(result, isNotNull);
      expect(result?.subsonicResponse?.status, equals('ok'));
      expect(mockRepository.fetchCalled, isTrue);
    });
  });

  group('playlistDetailProvider', () {
    test('returns null when playlistId is null', () async {
      final mockRepository = _MockPlaylistRepository(null);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(playlistDetailProvider(null).future);

      expect(result, isNull);
      expect(mockRepository.fetchCalled, isFalse);
    });

    test('returns playlist detail from repository', () async {
      final mockResponse = const SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(status: 'ok'),
      );
      final mockRepository = _MockPlaylistRepository(mockResponse);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(playlistDetailProvider('123').future);

      expect(result, isNotNull);
      expect(result?.subsonicResponse?.status, equals('ok'));
      expect(mockRepository.fetchCalled, isTrue);
    });
  });

  group('Playlists notifier', () {
    test('createPlaylist returns null when name is null', () async {
      final mockRepository = _MockPlaylistRepository(null);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(playlistsProvider.notifier);
      final result = await notifier.createPlaylist(null);

      expect(result, isNull);
      expect(mockRepository.createCalled, isFalse);
    });

    test('createPlaylist calls repository and refreshes', () async {
      final mockResponse = const SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(status: 'ok'),
      );
      final mockRepository = _MockPlaylistRepository(mockResponse);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(playlistsProvider.notifier);
      final result = await notifier.createPlaylist('My Playlist');

      expect(result, isNotNull);
      expect(mockRepository.createCalled, isTrue);
    });

    test('deletePlaytlist returns null when playlistId is null', () async {
      final mockRepository = _MockPlaylistRepository(null);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(playlistsProvider.notifier);
      final result = await notifier.deletePlaytlist(null);

      expect(result, isNull);
      expect(mockRepository.deleteCalled, isFalse);
    });

    test('deletePlaytlist calls repository and refreshes', () async {
      final mockResponse = const SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(status: 'ok'),
      );
      final mockRepository = _MockPlaylistRepository(mockResponse);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(playlistsProvider.notifier);
      final result = await notifier.deletePlaytlist('123');

      expect(result, isNotNull);
      expect(mockRepository.deleteCalled, isTrue);
    });
  });

  group('playlistUpdateProvider', () {
    test('modify returns null when update fails', () async {
      final mockRepository = _MockPlaylistRepository(null);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(playlistUpdateProvider.notifier);
      final result = await notifier.modify(playlistId: '123');

      expect(result, isNull);
      expect(mockRepository.updateCalled, isTrue);
    });

    test('modify returns response on success', () async {
      final mockResponse = const SubsonicResponse(
        subsonicResponse: SubsonicResponseClass(status: 'ok'),
      );
      final mockRepository = _MockPlaylistRepository(mockResponse);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(playlistUpdateProvider.notifier);
      final result = await notifier.modify(playlistId: '123');

      expect(result, isNotNull);
      expect(result?.subsonicResponse?.status, equals('ok'));
      expect(mockRepository.updateCalled, isTrue);
    });
  });
}
