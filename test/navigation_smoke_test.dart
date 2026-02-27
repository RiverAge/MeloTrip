import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/initial/initial_bootstrap_service.dart';
import 'package:melo_trip/pages/initial/initial_page.dart';
import 'package:melo_trip/pages/login/login_page.dart';
import 'package:melo_trip/pages/tab/tab_page.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';

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

  testWidgets('InitialPage routes to TabPage when bootstrap is loggedIn', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          initialBootstrapServiceProvider.overrideWithValue(
            _AlwaysLoggedInBootstrap(),
          ),
          appPlayerHandlerProvider.overrideWith(FakeAppPlayerHandler.new),
          currentUserProvider.overrideWith(FakeCurrentUserLoggedOut.new),
          apiProvider.overrideWith(FakeApiNull.new),
          userConfigProvider.overrideWith(FakeUserConfigNull.new),
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

class _AlwaysLoggedInBootstrap extends InitialBootstrapService {
  _AlwaysLoggedInBootstrap()
    : super(
        loadAuthUser: () async => null,
        loadConfig: () async => null,
        loadPlayQueue: () async => null,
        resolveCachePath: () async => '',
        startCacheServer: (_, _) {},
        restorePlaylist: ({required songs, initialId}) async {},
        restorePlaylistMode: (_) async {},
      );

  @override
  Future<InitialBootstrapResult> bootstrap() async {
    return .loggedIn;
  }
}
