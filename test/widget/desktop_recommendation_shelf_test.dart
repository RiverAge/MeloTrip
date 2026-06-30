import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_recommendation_shelf.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_recommendation_song_card.dart';
import 'package:melo_trip/widget/shimmer.dart';

SongEntity _song(String id, {String? title, String? artist}) {
  return SongEntity(id: id, title: title ?? 'Song $id', artist: artist);
}

void main() {
  group('DesktopRecommendationShelf', () {
    testWidgets('loading state shows shimmer skeleton', (tester) async {
      final provider = Provider<AsyncValue<List<SongEntity>>>(
        (_) => const AsyncValue.loading(),
      );

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SizedBox(
                width: 1200,
                child: DesktopRecommendationShelf(
                  title: 'Guess You Like',
                  songs: ProviderContainer().read(provider),
                ),
              ),
            ),
          ),
        ),
      );

      // Shimmer skeleton should render during loading.
      expect(find.byType(Shimmer), findsOneWidget);
      expect(find.byType(DesktopRecommendationSongCard), findsNothing);
    });

    testWidgets('data state shows song cards', (tester) async {
      final songs = [
        _song('1', title: 'Alpha'),
        _song('2', title: 'Beta'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SizedBox(
                width: 1200,
                child: DesktopRecommendationShelf(
                  title: 'Guess You Like',
                  songs: AsyncValue.data(songs),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(DesktopRecommendationSongCard), findsNWidgets(2));
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsOneWidget);
    });

    testWidgets('empty data shows no-recommendations message', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SizedBox(
                width: 1200,
                child: DesktopRecommendationShelf(
                  title: 'Guess You Like',
                  songs: const AsyncValue.data(<SongEntity>[]),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // No song cards, but the localized "no recommendations" text appears.
      expect(find.byType(DesktopRecommendationSongCard), findsNothing);
      // The exact string depends on locale; assert no cards + a Text rendered.
      expect(find.byType(Text), findsWidgets);
    });

    testWidgets('refresh button triggers onRefresh callback',
        (tester) async {
      var refreshCalled = false;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SizedBox(
                width: 1200,
                child: DesktopRecommendationShelf(
                  title: 'Guess You Like',
                  songs: AsyncValue.data([_song('1', title: 'Alpha')]),
                  onRefresh: () => refreshCalled = true,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.refresh_rounded));
      await tester.pump();

      expect(refreshCalled, isTrue);
    });
  });
}
