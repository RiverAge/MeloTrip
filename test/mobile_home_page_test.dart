import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/mobile/home/home_page.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/recommendation/for_you_recommendations.dart';

void main() {
  testWidgets('HomePage keeps listen now app bar pinned while scrolling', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          albumListProvider(
            AlbumListQuery(type: AlbumListType.newest.name),
          ).overrideWith((_) async => const Result.ok(<AlbumEntity>[])),
          albumListProvider(
            AlbumListQuery(type: AlbumListType.recent.name),
          ).overrideWith((_) async => const Result.ok(<AlbumEntity>[])),
          forYouRecommendationsProvider.overrideWith(
            (_) async => const <SongEntity>[],
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

    final appBar = tester.widget<SliverAppBar>(find.byType(SliverAppBar));

    expect(appBar.pinned, isTrue);
    expect(appBar.floating, isTrue);
    expect(appBar.snap, isTrue);
  });
}
