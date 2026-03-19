import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/desktop/playlist/playlist_detail_page.dart';
import 'package:melo_trip/pages/desktop/playlist/playlist_page.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/widget/no_data.dart';

import 'test_helpers.dart';

SubsonicResponse _playlistsResponse(List<PlaylistEntity> playlists) {
  return SubsonicResponse(
    subsonicResponse: SubsonicResponseClass(
      status: 'ok',
      playlists: PlaylistsEntity(playlist: playlists),
    ),
  );
}

SubsonicResponse _playlistDetailResponse({
  required String id,
  required String name,
  required List<SongEntity> songs,
}) {
  return SubsonicResponse(
    subsonicResponse: SubsonicResponseClass(
      status: 'ok',
      playlist: PlaylistEntity(
        id: id,
        name: name,
        songCount: songs.length,
        entry: songs,
      ),
    ),
  );
}

SongEntity _song({
  required String id,
  required String title,
  int duration = 90,
}) {
  return SongEntity(id: id, title: title, duration: duration, artist: 'tester');
}

class _FakePlaylistDetail extends PlaylistDetail {
  _FakePlaylistDetail(this._value);

  final Result<SubsonicResponse, AppFailure> _value;

  @override
  Future<Result<SubsonicResponse, AppFailure>?> build(String? _) async => _value;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('DesktopPlaylistsPage shows NoData when playlist list is empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
          playlistsProvider.overrideWith(
            (ref) async => Result.ok(_playlistsResponse(const [])),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const DesktopPlaylistsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(NoData), findsOneWidget);
  });

  testWidgets('DesktopPlaylistsPage opens detail page when tapping playlist', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
          playlistsProvider.overrideWith(
            (ref) async => Result.ok(
              _playlistsResponse([
                const PlaylistEntity(
                  id: 'pl-1',
                  name: 'My Playlist 1',
                  songCount: 2,
                ),
              ]),
            ),
          ),
          playlistDetailProvider('pl-1').overrideWith(
            () => _FakePlaylistDetail(
              Result.ok(
                _playlistDetailResponse(
                  id: 'pl-1',
                  name: 'My Playlist 1',
                  songs: [
                    _song(id: 's1', title: 'Track 1', duration: 65),
                    _song(id: 's2', title: 'Track 2', duration: 125),
                  ],
                ),
              ),
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const DesktopPlaylistsPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('My Playlist 1'), findsOneWidget);

    await tester.tap(find.text('My Playlist 1'));
    await tester.pumpAndSettle();

    expect(find.byType(DesktopPlaylistDetailPage), findsOneWidget);
    expect(find.text('Track 1'), findsOneWidget);
    expect(find.text('Track 2'), findsOneWidget);
    expect(find.text('1:05'), findsOneWidget);
    expect(find.text('2:05'), findsOneWidget);
  });
}

