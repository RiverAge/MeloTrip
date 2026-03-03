import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/search_result/search_result3.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/pages/desktop/album/album_detail_page.dart';
import 'package:melo_trip/pages/desktop/search/search_page.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/search/search.dart';
import 'package:melo_trip/widget/no_data.dart';

import 'test_helpers.dart';

SubsonicResponse _searchResponse(List<AlbumEntity> albums) {
  return SubsonicResponse(
    subsonicResponse: SubsonicResponseClass(
      status: 'ok',
      searchResult3: SearchResult3Entity(album: albums),
    ),
  );
}

SubsonicResponse _albumDetailResponse(String id) {
  return SubsonicResponse(
    subsonicResponse: SubsonicResponseClass(
      status: 'ok',
      album: AlbumEntity(id: id, name: 'Album $id', artist: 'Artist $id'),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('DesktopSearchPage shows NoData when query is empty', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1600, 1000);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
          searchQueryProvider.overrideWith((_) => ''),
          searchResultProvider.overrideWith((_) async => null),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const DesktopSearchPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(NoData), findsOneWidget);
  });

  testWidgets('DesktopSearchPage renders results and opens album detail', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1600, 1000);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
          searchQueryProvider.overrideWith((_) => 'rock'),
          searchResultProvider.overrideWith(
            (_) async => _searchResponse([
              const AlbumEntity(
                id: 'a1',
                name: 'Search Album 1',
                artist: 'Search Artist 1',
              ),
            ]),
          ),
          albumDetailProvider('a1').overrideWith((_) async => _albumDetailResponse('a1')),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const DesktopSearchPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Search Album 1'), findsOneWidget);
    expect(find.text('Search Artist 1'), findsOneWidget);

    await tester.tap(find.text('Search Album 1'));
    await tester.pumpAndSettle();

    expect(find.byType(DesktopAlbumDetailPage), findsOneWidget);
  });
}
