import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/desktop/home/parts/desktop_album_card.dart';
import 'package:melo_trip/provider/album/album_detail.dart';

SubsonicResponse _albumDetailResponse() {
  return SubsonicResponse(
    subsonicResponse: SubsonicResponseClass(
      status: 'ok',
      album: AlbumEntity(
        id: 'album-1',
        name: 'Hover Album',
        artist: 'Hover Artist',
        song: [SongEntity(id: 'song-1', title: 'Song 1')],
      ),
    ),
  );
}

void main() {
  testWidgets(
    'DesktopAlbumCard hover overlay does not overflow at narrow card width',
    (tester) async {
      // Card width on the home page clamps between 136 and 188. The hover
      // overlay Row (shuffle + play + skip buttons) previously overflowed by
      // a sub-pixel amount at the ~146px critical width because of fixed 12px
      // gaps. Spacers make the gaps elastic so it never overflows.
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            albumDetailProvider('album-1').overrideWith(
              () => _FakeAlbumDetail(_albumDetailResponse()),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(
              body: Center(
                child: SizedBox(
                  width: 146,
                  child: DesktopAlbumCard(
                    album: AlbumEntity(
                      id: 'album-1',
                      name: 'Hover Album',
                      artist: 'Hover Artist',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Hover to reveal the action overlay.
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(gesture.removePointer);
      await gesture.addPointer();
      await gesture.moveTo(tester.getCenter(find.byType(DesktopAlbumCard)));
      await tester.pumpAndSettle();

      // No RenderFlex overflow should be reported.
      expect(tester.takeException(), isNull);
    },
  );
}

class _FakeAlbumDetail extends AlbumDetail {
  _FakeAlbumDetail(this._response);

  final SubsonicResponse _response;

  @override
  Future<Result<SubsonicResponse, AppFailure>?> build(String? albumId) async =>
      Result.ok(_response);
}
