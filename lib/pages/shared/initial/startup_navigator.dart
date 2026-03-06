import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/pages/shared/initial/initial_bootstrap_service.dart';
import 'package:melo_trip/pages/shared/initial/tab_page.dart';
import 'package:melo_trip/pages/shared/login/login_page.dart';

class StartupNavigator {
  const StartupNavigator();

  void navigate(NavigatorState navigator, InitialBootstrapResult result) {
    final targetPage = switch (result) {
      InitialBootstrapResult.loggedIn => const TabPage(),
      InitialBootstrapResult.loggedOut => const LoginPage(),
    };

    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS)) {
      FlutterNativeSplash.remove();
    }
    navigator.pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, _, _) => targetPage,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (_) => false,
    );
  }
}

final startupNavigatorProvider = Provider<StartupNavigator>((_) {
  return const StartupNavigator();
});
