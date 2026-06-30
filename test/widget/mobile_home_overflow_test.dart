import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/mobile/home/home_page.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/recommendation/for_you_recommendations.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';

import '../test_helpers.dart';
import '../widget_test_bootstrap.dart';

/// Very long strings to exercise text-overflow paths on narrow screens.
const _longAlbumName =
    'This Is A Very Long Album Name That Should Stress Text Layout '
    'On A Narrow Mobile Screen Without Truncating Gracefully';
const _longArtistName =
    'An Extremely Verbose Artist Name That Goes On And On And On';
const _longSongTitle =
    'A Ridiculously Long Song Title Designed To Overflow The Horizontal '
    'Recommendation Card Width On A Small Screen';

AlbumEntity _album(int id) => AlbumEntity(
      id: 'album-$id',
      name: _longAlbumName,
      artist: _longArtistName,
      genre: 'Genre',
      year: 2025,
    );

SongEntity _song(int id) => SongEntity(
      id: 'song-$id',
      title: _longSongTitle,
      artist: _longArtistName,
      duration: 200,
    );

Future<void> _pumpHome(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
        sessionAuthProvider.overrideWith(fakeSessionAuthLoggedOut),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.newest.name),
        ).overrideWith((_) async => Result.ok(List.generate(6, _album))),
        albumListProvider(
          AlbumListQuery(type: AlbumListType.recent.name),
        ).overrideWith((_) async => Result.ok(List.generate(6, _album))),
        forYouRecommendationsProvider.overrideWith(
          (_) async => List.generate(6, _song),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpOverflowGuard();

  group('MobileHomePage overflow', () {
    testWidgets('renders without overflow on small screen', (tester) async {
      await _pumpHome(tester, const Size(320, 568));
      expect(find.byType(HomePage), findsOneWidget);
      expectNoFlutterErrors();
    });

    testWidgets('renders without overflow on large screen', (tester) async {
      await _pumpHome(tester, const Size(1024, 768));
      expect(find.byType(HomePage), findsOneWidget);
      expectNoFlutterErrors();
    });
  });
}
