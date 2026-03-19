import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/helper/app_failure_message.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/model/common/result.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/pages/mobile/playlist/playlist_page.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/widget/no_data.dart';

import 'test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final cases = <AppFailureType>[
    AppFailureType.network,
    AppFailureType.unauthorized,
    AppFailureType.server,
    AppFailureType.protocol,
  ];

  for (final c in cases) {
    testWidgets('PlaylistPage renders ${c.name} failure instead of NoData', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
            playlistsProvider.overrideWith(
              (_) async => Result.err(
                AppFailure(type: c, message: 'mock-${c.name}'),
              ),
            ),
          ],
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const PlaylistPage(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      final context = tester.element(find.byType(PlaylistPage));
      final l10n = AppLocalizations.of(context)!;
      final expectedMessage = resolveAppFailureMessage(l10n, type: c);

      expect(find.text(expectedMessage), findsOneWidget);
      expect(find.byType(NoData), findsNothing);
    });
  }

  testWidgets('PlaylistPage keeps NoData for true empty playlist response', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
          playlistsProvider.overrideWith(
            (_) async => const Result.ok(<PlaylistEntity>[]),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PlaylistPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(NoData), findsOneWidget);
  });
}
