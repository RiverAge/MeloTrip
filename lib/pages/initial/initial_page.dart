import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/pages/login/login_page.dart';
import 'package:melo_trip/pages/tab/tab_page.dart';
import 'package:melo_trip/pages/initial/initial_bootstrap_service.dart';

class InitialPage extends ConsumerStatefulWidget {
  const InitialPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InitState();
}

class _InitState extends ConsumerState<InitialPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    final navigator = Navigator.of(context);
    final bootstrapService = ref.read(initialBootstrapServiceProvider);
    final result = await bootstrapService.bootstrap();

    if (!mounted) return;
    if (result == .loggedIn) {
      navigator.pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, _, _) => const TabPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => false,
      );
      FlutterNativeSplash.remove();
    } else {
      FlutterNativeSplash.remove();
      navigator.pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, _, _) => const LoginPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}
