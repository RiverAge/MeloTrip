part of '../desktop_home_page_test.dart';

SubsonicResponse _albumDetailResponse({
  required String albumId,
  required String albumName,
  required String artist,
  required List<SongEntity> songs,
}) {
  return SubsonicResponse(
    subsonicResponse: SubsonicResponseClass(
      status: 'ok',
      album: AlbumEntity(
        id: albumId,
        name: albumName,
        artist: artist,
        song: songs,
      ),
    ),
  );
}

AlbumEntity _album({
  required String id,
  required String name,
  required String artist,
  required String genre,
  int? year,
}) {
  return AlbumEntity(
    id: id,
    name: name,
    artist: artist,
    genre: genre,
    year: year,
    userRating: 8,
  );
}

SongEntity _song({required String id, required String title, int track = 1}) {
  return SongEntity(
    id: id,
    title: title,
    track: track,
    artist: 'test-artist',
    duration: 120,
    discNumber: 1,
  );
}

Future<void> _pumpDesktopHome(
  WidgetTester tester, {
  required List<AlbumEntity> random,
  required List<AlbumEntity> recent,
  required List<AlbumEntity> newest,
  required List<AlbumEntity> frequent,
  List<SongEntity> recommendations = const <SongEntity>[],
  Size viewportSize = const Size(1600, 1000),
  required SubsonicResponse detail,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = viewportSize;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
        sessionAuthProvider.overrideWith(fakeSessionAuthLoggedOut),
        forYouRecommendationsProvider.overrideWith(
          (_) async => recommendations,
        ),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.random.name),
        ).overrideWith((_) async => Result.ok(random)),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.recent.name),
        ).overrideWith((_) async => Result.ok(recent)),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.recent.name, size: 50),
        ).overrideWith((_) async => Result.ok(recent)),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.newest.name),
        ).overrideWith((_) async => Result.ok(newest)),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.newest.name, size: 50),
        ).overrideWith((_) async => Result.ok(newest)),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.frequent.name),
        ).overrideWith((_) async => Result.ok(frequent)),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.frequent.name, size: 50),
        ).overrideWith((_) async => Result.ok(frequent)),
        albumDetailProvider(
          'album-1',
        ).overrideWith(() => _FakeAlbumDetail(detail)),
      ],
      child: MaterialApp(
        theme: ThemeData(splashFactory: NoSplash.splashFactory),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: DesktopHomePage()),
      ),
    ),
  );
  await tester.pump();
}
