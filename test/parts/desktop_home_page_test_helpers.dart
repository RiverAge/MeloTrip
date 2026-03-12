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
  required SubsonicResponse detail,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1600, 1000);
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
        currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
        albumListProvider(
          AlbumListType.random,
        ).overrideWith((_) async => random),
        albumListProvider(
          AlbumListType.recent,
        ).overrideWith((_) async => recent),
        albumListProvider(
          AlbumListType.newest,
        ).overrideWith((_) async => newest),
        albumListProvider(
          AlbumListType.frequent,
        ).overrideWith((_) async => frequent),
        albumDetailProvider('album-1').overrideWith((_) async => detail),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: DesktopHomePage()),
      ),
    ),
  );
  await tester.pump();
}
