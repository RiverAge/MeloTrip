import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/auth_user/auth_user.dart';
import 'package:melo_trip/pages/initial/initial_bootstrap_service.dart';
import 'package:melo_trip/pages/initial/initial_page.dart';
import 'package:melo_trip/pages/login/login_page.dart';

void main() {
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

  testWidgets('InitialPage shows loading indicator and retry button', (
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

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Retry startup'), findsOneWidget);
    expect(find.byType(LoginPage), findsNothing);

    if (!pendingAuth.isCompleted) {
      pendingAuth.complete(null);
    }
    await tester.pumpAndSettle();
  });

  testWidgets('Retry triggers bootstrap again when initial attempt is pending', (
    WidgetTester tester,
  ) async {
    var bootstrapCalls = 0;
    final firstAttempt = Completer<AuthUser?>();
    final service = InitialBootstrapService(
      loadAuthUser: () {
        bootstrapCalls++;
        if (bootstrapCalls == 1) {
          return firstAttempt.future;
        }
        return Future<AuthUser?>.value(null);
      },
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

    expect(bootstrapCalls, 1);
    await tester.tap(find.text('Retry startup'));
    await tester.pumpAndSettle();

    expect(bootstrapCalls, 2);
    expect(find.byType(LoginPage), findsOneWidget);

    if (!firstAttempt.isCompleted) {
      firstAttempt.complete(null);
    }
    await tester.pumpAndSettle();
  });
}
