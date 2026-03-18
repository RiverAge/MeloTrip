import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/app_failure.dart';
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
  Future<SubsonicResponse> fetchPlaylists() async {
    fetchCalled = true;
    return _fetchResult!;
  }

  @override
  Future<SubsonicResponse> fetchPlaylistDetail(String playlistId) async {
    fetchCalled = true;
    return _fetchResult!;
  }

  @override
  Future<SubsonicResponse> createPlaylist(String name) async {
    createCalled = true;
    return _fetchResult!;
  }

  @override
  Future<SubsonicResponse> deletePlaylist(String playlistId) async {
    deleteCalled = true;
    return _fetchResult!;
  }

  @override
  Future<SubsonicResponse> updatePlaylist({
    required String playlistId,
    int? songIndexToRemove,
    String? songIdToAdd,
    String? name,
    String? comment,
    bool? public,
  }) async {
    updateCalled = true;
    return _fetchResult!;
  }
}

void main() {
  group('playlistsResultProvider', () {
    test('returns Result.err when repository throws', () async {
      final mockRepository = _MockPlaylistRepository(null);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(playlistsResultProvider.future);

      expect(result.isErr, isTrue);
      expect(result.error, isA<AppFailure>());
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

      final result = await container.read(playlistsResultProvider.future);

      expect(result, isNotNull);
      expect(result.data?.subsonicResponse?.status, equals('ok'));
      expect(mockRepository.fetchCalled, isTrue);
    });
  });

  group('playlistDetailResultProvider', () {
    test('returns null when playlistId is null', () async {
      final mockRepository = _MockPlaylistRepository(null);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final result =
          await container.read(playlistDetailResultProvider(null).future);

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
          await container.read(playlistDetailResultProvider('123').future);

      expect(result, isNotNull);
      expect(result?.data?.subsonicResponse?.status, equals('ok'));
      expect(mockRepository.fetchCalled, isTrue);
    });
  });

  group('PlaylistActions notifier', () {
    test('createPlaylist returns null when name is null', () async {
      final mockRepository = _MockPlaylistRepository(null);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(playlistActionsProvider.notifier);
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

      final notifier = container.read(playlistActionsProvider.notifier);
      final result = await notifier.createPlaylist('My Playlist');

      expect(result, isNotNull);
      expect(result?.isOk, isTrue);
      expect(mockRepository.createCalled, isTrue);
    });

  });

  group('playlistDetailResultProvider notifier', () {
    test('deleteResult returns null when playlistId is null', () async {
      final mockRepository = _MockPlaylistRepository(null);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(playlistDetailResultProvider(null).notifier);
      final result = await notifier.deleteResult();

      expect(result, isNull);
      expect(mockRepository.deleteCalled, isFalse);
    });

    test('deleteResult calls repository and refreshes', () async {
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

      final notifier = container.read(playlistDetailResultProvider('123').notifier);
      final result = await notifier.deleteResult();

      expect(result, isNotNull);
      expect(result?.isOk, isTrue);
      expect(mockRepository.deleteCalled, isTrue);
    });

    test('modifyResult returns null when playlistId is null', () async {
      final mockRepository = _MockPlaylistRepository(null);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(playlistDetailResultProvider(null).notifier);
      final result = await notifier.modifyResult();

      expect(result, isNull);
      expect(mockRepository.updateCalled, isFalse);
    });

    test('modifyResult returns Result.err when update fails', () async {
      final mockRepository = _MockPlaylistRepository(null);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(playlistDetailResultProvider('123').notifier);
      final result = await notifier.modifyResult();

      expect(result?.isErr, isTrue);
      expect(result?.error, isA<AppFailure>());
      expect(mockRepository.updateCalled, isTrue);
    });

    test('modifyResult returns Result.ok on success', () async {
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

      final notifier = container.read(playlistDetailResultProvider('123').notifier);
      final result = await notifier.modifyResult();

      expect(result, isNotNull);
      expect(result?.data?.subsonicResponse?.status, equals('ok'));
      expect(mockRepository.updateCalled, isTrue);
    });
  });

  group('playlist Result APIs', () {
    test('createPlaylist returns Result.ok on success', () async {
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

      final notifier = container.read(playlistActionsProvider.notifier);
      final result = await notifier.createPlaylist('My Playlist');

      expect(result, isNotNull);
      expect(result?.isOk, isTrue);
      expect(result?.data?.subsonicResponse?.status, 'ok');
    });

    test('modifyResult returns Result.err on failure', () async {
      final mockRepository = _MockPlaylistRepository(null);
      final container = ProviderContainer(
        overrides: [
          playlistRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );
      addTearDown(container.dispose);

      final notifier = container.read(playlistDetailResultProvider('123').notifier);
      final result = await notifier.modifyResult();

      expect(result?.isErr, isTrue);
      expect(result?.error, isA<AppFailure>());
    });
  });
}
