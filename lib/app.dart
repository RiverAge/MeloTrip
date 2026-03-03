import 'dart:async';
import 'package:desktop_lyrics/desktop_lyrics.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/const/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/pages/shared/initial/initial_page.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/desktop_lyrics/desktop_lyrics.dart';
import 'package:melo_trip/provider/lyrics/lyrics.dart';
import 'package:melo_trip/provider/route/route_observer.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:rxdart/rxdart.dart';

part 'app_logic/api_interceptor.dart';
part 'app_logic/player_listener.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey();
  final bool _enableBackgroundModeOptimization =
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  // 追踪打卡相关的状态
  String? _lastProcessedId;
  double? _lastSongDuration;
  Duration _activeDuration = Duration.zero; // 累计播放时长
  DateTime? _lastStateChangeTime; // 上一次状态（播放/切歌）变换的时间
  bool _wasPlaying = false; // 上一次的状态记录
  Timer? _nowPlayingTimer;

  StreamSubscription? _playlistModeSubscription;
  StreamSubscription? _scrobbleSubscription;
  StreamSubscription? _errorSubscription;
  StreamSubscription? _desktopLyricsTrackSubscription;
  StreamSubscription? _desktopLyricsProgressSubscription;

  @override
  void initState() {
    super.initState();
    _initApiInterceptor(); // 调用自 api_interceptor.dart
    _initPlayerListeners(); // 调用自 player_listener.dart
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cancelPlayerSubscriptions(); // 调用自 player_listener.dart
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (!_enableBackgroundModeOptimization) return;
    final player = await ref.read(appPlayerHandlerProvider.future);
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

  void _onErrorScanfoldMessage({required String errorMsg}) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          errorMsg == ''
              ? AppLocalizations.of(context)!.unknownError
              : errorMsg,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final observer = ref.watch(routeObserverProvider);
    final config = ref.watch(userConfigProvider).valueOrNull;

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
          brightness: .dark,
          seedColor: const Color(0xFFDB1D5D),
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const InitialPage(),
    );
  }
}
