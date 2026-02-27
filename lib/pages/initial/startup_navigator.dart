import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/pages/initial/initial_bootstrap_service.dart';
import 'package:melo_trip/pages/login/login_page.dart';
import 'package:melo_trip/pages/tab/tab_page.dart';

class StartupNavigator {
  const StartupNavigator();

  void navigate(BuildContext context, InitialBootstrapResult result) {
    final targetPage = switch (result) {
      InitialBootstrapResult.loggedIn => const TabPage(),
      InitialBootstrapResult.loggedOut => const LoginPage(),
    };

    FlutterNativeSplash.remove();
    Navigator.of(context).pushAndRemoveUntil(
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
