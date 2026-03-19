import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/artist/artist.dart';
import 'package:melo_trip/model/response/search_result/search_result3.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/desktop/tab/parts/search_command_palette.dart';
import 'package:melo_trip/provider/search/search.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';

import 'test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp(Widget child) {
    return ProviderScope(
      overrides: [userConfigProvider.overrideWith(FakeUserConfigNull.new)],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
  }

  SubsonicResponse searchResponse() {
    return SubsonicResponse(
      subsonicResponse: SubsonicResponseClass(
        status: 'ok',
        searchResult3: SearchResult3Entity(
          song: const <SongEntity>[
            SongEntity(id: 's1', title: 'Quick Song', album: 'Quick Album'),
          ],
          album: const <AlbumEntity>[
            AlbumEntity(id: 'a1', name: 'Quick Album', artist: 'Quick Artist'),
          ],
          artist: const <ArtistEntity>[
            ArtistEntity(id: 'ar1', name: 'Quick Artist', albumCount: 2),
          ],
        ),
      ),
    );
  }

  testWidgets('SearchCommandPalette renders localized content', (tester) async {
    await tester.pumpWidget(buildApp(const SearchCommandPalette()));
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(IconButton), findsWidgets);
    expect(find.text('ESC'), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsWidgets);
  });

  testWidgets('SearchCommandPalette close button dismisses dialog', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [userConfigProvider.overrideWith(FakeUserConfigNull.new)],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const SearchCommandPalette(),
                      );
                    },
                    child: const Text('Open'),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.byType(SearchCommandPalette), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expect(find.byType(SearchCommandPalette), findsNothing);
  });

  testWidgets('SearchCommandPalette shows song, album and artist results', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userConfigProvider.overrideWith(FakeUserConfigNull.new),
          searchByQueryProvider('rock').overrideWith(
            (ref) async => Result.ok(searchResponse()),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: SearchCommandPalette()),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField), 'rock');
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.text('Quick Song'), findsOneWidget);
    expect(find.text('Quick Album'), findsWidgets);
    expect(find.text('Quick Artist'), findsWidgets);
  });
}

