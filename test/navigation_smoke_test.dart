import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/pages/shared/initial/initial_bootstrap_service.dart';
import 'package:melo_trip/pages/shared/initial/initial_page.dart';
import 'package:melo_trip/pages/shared/initial/tab_page.dart';
import 'package:melo_trip/pages/shared/login/login_page.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';

import 'test_helpers.dart';

void main() {
  testWidgets('InitialPage routes to LoginPage when user is not logged in', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
          currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const InitialPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('InitialPage routes to TabPage when bootstrap succeeds', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
          albumsProvider(.newest).overrideWith((_) async => const <AlbumEntity>[]),
          albumsProvider(.recent).overrideWith((_) async => const <AlbumEntity>[]),
          initialBootstrapServiceProvider.overrideWithValue(
            InitialBootstrapService(
              loadAuthUser: () async => const AuthUser(
                salt: 'salt',
                token: 'token',
                host: 'https://example.com',
              ),
              loadConfig: () async => null,
              resolveCachePath: () async => '/tmp/cache',
              startCacheServer: (_, _) {},
              restorePlaylistMode: (_) async {},
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const InitialPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byType(TabPage), findsOneWidget);
  });
}
