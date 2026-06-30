import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/shared/login/login_page.dart';

import '../widget_test_bootstrap.dart';

Future<void> _pumpLogin(WidgetTester tester, Size size) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const LoginPage(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpOverflowGuard();

  group('LoginPage overflow', () {
    // 320x568 is below the desktop breakpoint (900), so the mobile shell
    // (Column stack with hero + SizedBox heights + form) is exercised.
    testWidgets('renders without overflow on small screen', (tester) async {
      await _pumpLogin(tester, const Size(320, 568));
      expect(find.byType(LoginPage), findsOneWidget);
      expectNoFlutterErrors();
    });

    // Below 900 width but very short height stresses the vertical Column stack.
    testWidgets('renders without overflow on short screen', (tester) async {
      await _pumpLogin(tester, const Size(320, 400));
      expect(find.byType(LoginPage), findsOneWidget);
      expectNoFlutterErrors();
    });

    testWidgets('renders without overflow on large screen', (tester) async {
      await _pumpLogin(tester, const Size(1280, 800));
      expect(find.byType(LoginPage), findsOneWidget);
      expectNoFlutterErrors();
    });
  });
}
