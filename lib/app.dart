import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_logic/app_runtime_coordinator.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/shared/initial/initial_page.dart';
import 'package:melo_trip/provider/app_error/app_error.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/route/route_observer.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey();
  final bool _enableBackgroundModeOptimization =
      !kIsWeb &&
      (defaultTargetPlatform == .android || defaultTargetPlatform == .iOS);

  AppRuntimeCoordinatorBindings? _runtimeBindings;

  @override
  void initState() {
    super.initState();
    _startAppRuntime();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_runtimeBindings?.cancel());
    super.dispose();
  }

  void _startAppRuntime() async {
    _runtimeBindings = await ref.read(appRuntimeCoordinatorProvider).start(ref);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (!_enableBackgroundModeOptimization) {
      return;
    }

    final AppPlayer? player = await ref.read(appPlayerHandlerProvider.future);
    switch (state) {
      case .resumed:
        player?.setBackgroundMode(false);
        break;
      case .paused:
      case .inactive:
      case .detached:
      case .hidden:
        player?.setBackgroundMode(true);
        break;
    }
  }

  void _showGlobalErrorMessage({required String errorMessage}) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          errorMessage.isEmpty
              ? AppLocalizations.of(context)!.unknownError
              : errorMessage,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AppErrorEvent?>(appErrorProvider, (_, next) {
      if (next == null) {
        return;
      }
      _showGlobalErrorMessage(errorMessage: next.message);
    });

    final RouteObserver<ModalRoute<void>> observer = ref.watch(
      routeObserverProvider,
    );
    final config = ref.watch(userConfigProvider).asData?.value;

    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      title: 'MeloTrip',
      navigatorObservers: [observer],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFDB1D5D)),
      ),
      themeMode: config?.theme,
      locale: config?.locale,
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFFDB1D5D),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const InitialPage(),
    );
  }
}
