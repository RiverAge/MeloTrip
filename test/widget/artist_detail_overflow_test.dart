import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/desktop/artist/artist_detail_page.dart'
    as desktop;
import 'package:melo_trip/pages/mobile/artist/artist_detail_page.dart'
    as mobile;
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/artist/artist_detail.dart';
import 'package:melo_trip/provider/artist/similar_artists.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';

import '../test_helpers.dart';
import '../widget_test_bootstrap.dart';

const _longName =
    'An Extremely Verbose Artist Name That Goes On And On And On And Should '
    'Stress The Horizontal Similar-Artist Card And The Header Layout';
const _longAlbumName =
    'A Very Long Album Title Designed To Overflow The Album Grid Cell Width '
    'On A Narrow Screen';

ArtistEntity _artist(int i) => ArtistEntity(
      id: 'artist-$i',
      name: _longName,
      albumCount: 5,
      album: List.generate(
        6,
        (j) => AlbumEntity(
          id: 'artist-$i-album-$j',
          name: _longAlbumName,
          artist: _longName,
          year: 2024,
        ),
      ),
    );

SubsonicResponse _artistDetailResponse() => SubsonicResponse(
      subsonicResponse: SubsonicResponseClass(
        status: 'ok',
        artist: _artist(0),
      ),
    );

List<ArtistEntity> _similarArtists() => List.generate(12, _artist);

final _overrides = [
  appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
  sessionAuthProvider.overrideWith(fakeSessionAuthLoggedOut),
  artistDetailProvider('artist-0').overrideWith(
    (_) async => Result.ok(_artistDetailResponse()),
  ),
  similarArtistsProvider(artistId: 'artist-0', count: 12).overrideWith(
    (_) async => _similarArtists(),
  ),
];

Future<void> _pumpMobile(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    ProviderScope(
      overrides: _overrides,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const mobile.ArtistDetailPage(artistId: 'artist-0'),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _pumpDesktop(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    ProviderScope(
      overrides: _overrides,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const desktop.DesktopArtistDetailPage(artistId: 'artist-0'),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpOverflowGuard();

  group('MobileArtistDetailPage overflow', () {
    testWidgets('renders without overflow on small screen', (tester) async {
      await _pumpMobile(tester, const Size(320, 568));
      expectNoFlutterErrors();
    });
  });

  group('DesktopArtistDetailPage overflow', () {
    testWidgets('renders without overflow at narrow window', (tester) async {
      await _pumpDesktop(tester, const Size(800, 1000));
      expectNoFlutterErrors();
    });
  });
}
