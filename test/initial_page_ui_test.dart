import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/pages/shared/initial/initial_bootstrap_service.dart';
import 'package:melo_trip/pages/shared/initial/initial_page.dart';
import 'package:melo_trip/pages/shared/login/login_page.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';

import 'test_helpers.dart';

var _appPlayerBuildCalls = 0;

class _CountingAppPlayerHandler extends AppPlayerHandler {
  @override
  Future<AppPlayer?> build() async {
    _appPlayerBuildCalls++;
    return null;
  }
}

void main() {
  setUp(() {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  Widget buildApp(List<Override> overrides) {
    return ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const InitialPage(),
      ),
    );
  }

  testWidgets('InitialPage shows startup icon and status text', (
    WidgetTester tester,
  ) async {
    final pendingAuth = Completer<AuthUser?>();
    final service = InitialBootstrapService(
      loadAuthUser: () => pendingAuth.future,
      loadConfig: () async => null,
      loadPlayQueue: () async => null,
      resolveCachePath: () async => '/tmp/cache',
      startCacheServer: (_, _) {},
      restorePlaylist: ({required songs, initialId}) async {},
      restorePlaylistMode: (_) async {},
    );

    await tester.pumpWidget(
      buildApp([
        initialBootstrapServiceProvider.overrideWithValue(service),
      ]),
    );

    expect(find.byIcon(Icons.music_note_rounded), findsOneWidget);
    expect(find.text('Starting MeloTrip...'), findsOneWidget);
    expect(find.text('Retry startup'), findsNothing);
    expect(find.byType(LoginPage), findsNothing);

    if (!pendingAuth.isCompleted) {
      pendingAuth.complete(null);
    }
    await tester.pumpAndSettle();
  });

  testWidgets(
    'InitialPage logged-out flow does not eagerly initialize player',
    (WidgetTester tester) async {
      _appPlayerBuildCalls = 0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appPlayerHandlerProvider.overrideWith(_CountingAppPlayerHandler.new),
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
      expect(_appPlayerBuildCalls, 0);
    },
  );
}
