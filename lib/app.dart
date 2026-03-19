import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_logic/runtime/app_runtime_coordinator.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/auth_user/theme_seed.dart';
import 'package:melo_trip/model/common/app_failure.dart';
import 'package:melo_trip/pages/shared/initial/initial_page.dart';
import 'package:melo_trip/provider/app/error.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/app/route_observer.dart';
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

  String _resolveGlobalErrorMessage(AppErrorEvent event) {
    final l10n = AppLocalizations.of(context)!;
    return switch (event.failureType) {
      AppFailureType.network => l10n.globalErrorNetwork,
      AppFailureType.unauthorized => l10n.globalErrorUnauthorized,
      AppFailureType.server => l10n.globalErrorServer,
      AppFailureType.protocol => l10n.globalErrorProtocol,
      AppFailureType.unknown || null => l10n.unknownError,
    };
  }

  void _showGlobalErrorMessage({required AppErrorEvent event}) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(_resolveGlobalErrorMessage(event)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AppErrorEvent?>(appErrorProvider, (_, next) {
      if (next == null) {
        return;
      }
      _showGlobalErrorMessage(event: next);
    });

    final RouteObserver<ModalRoute<void>> observer = ref.watch(
      routeObserverProvider,
    );
    final config = ref.watch(userConfigProvider).asData?.value;
    final Color seedColor = (config?.themeSeed ?? AppThemeSeed.rose).color;

    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      title: 'MeloTrip',
      navigatorObservers: [observer],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: seedColor,
        ),
      ),
      themeMode: config?.theme,
      locale: config?.locale,
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: seedColor,
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const InitialPage(),
    );
  }
}
