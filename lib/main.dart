import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/const/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/initial/initial_page.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/smart_suggestion/smart_suggestion.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  MediaKit.ensureInitialized();
  // 这是关键的初始化步骤
  if (Platform.isWindows || Platform.isLinux) {
    // 初始化用于 Windows/Linux 的 FFI 版本
    sqfliteFfiInit();
    // 将默认的数据库工厂更改为 FFI 版本
    databaseFactory = databaseFactoryFfi;
  }
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey();

  var _nowPlaying = true;
  var _submission = true;

  // Future<void> _addListner() async {
  //   _http = await Http.instance;
  //   _http?.addErrorScanfoldMessageListner(_onErrorScanfoldMessage);
  // }

  @override
  void initState() {
    super.initState();

    _setApiInterceptor();

    _setPlayerMediaResolver();

    _setPlayQueueListener();
    _setPlaylistModeListener();
    _setPositionListener();
  }

  void _setApiInterceptor() async {
    final api = await ref.read(apiProvider.future);

    api.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final auth = await ref.read(currentUserProvider.future);
          final subsonicToken = auth?.subsonicToken;
          final host = auth?.host;
          if (subsonicToken != null && host != null) {
            options.baseUrl = host;
            options.queryParameters.addAll({
              'u': auth?.username,
              't': subsonicToken, // 假设 token 是这样传递
              's': auth?.subsonicSalt, // 假设 salt 是这样传递
              '_': DateTime.now().toIso8601String(),
              'v': '1.16.1',
              'c': 'melo_trip',
              'f': 'json',
            });
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          final data = response.data;
          if (data is Map<String, dynamic>?) {
            final error = data?['subsonic-response']?['error'];
            if (error is Map<String, dynamic>) {
              final errorMsg = error['message'] as String?;
              if (errorMsg != null) {
                _onErrorScanfoldMessage(errorMsg: errorMsg);
              }
            }
          }
          return handler.next(response);
        },
        onError: (response, handler) {
          final resError = response.response?.data["error"] as String?;
          final resMessage = response.message;
          final statusCode = response.response?.statusCode;
          _onErrorScanfoldMessage(
            errorMsg: resError ?? resMessage ?? '$statusCode',
          );
          return handler.next(response);
        },
      ),
    );
  }

  void _setPlayerMediaResolver() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    player?.setMediaResolver((song) async {
      final auth = await ref.read(currentUserProvider.future);
      final config = await ref.read(userConfigProvider.future);

      final url =
          '$proxyCacheHost/rest/stream?id=${song.id}&u=${auth?.username}&t=${auth?.subsonicToken}&s=${auth?.subsonicSalt}&_=${DateTime.now().toIso8601String()}&f=json&v=1.8.0&c=MeloTrip&maxBitRate=${config?.maxRate}';

      return Media(url, extras: {'song': song});
    });
  }

  void _setPlaylistModeListener() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    player?.playlistModeStream.listen((mode) {
      final config = ref.read(userConfigProvider.notifier);
      config.setConfiguration(playlistMode: ValueUpdater(mode));
    });
  }

  void _setPlayQueueListener() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    player?.playQueueStream.listen((_) => _updateMediaItem(player));
  }

  void _setPositionListener() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    player?.positionStream.listen((pos) => _updateScrolling(player, pos));
  }

  @override
  void dispose() {
    super.dispose();
    // _http?.removeErrorScanfoldMessageListner(_onErrorScanfoldMessage);
  }

  Future<void> _onErrorScanfoldMessage({required String errorMsg}) async {
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

  // 播放列表或者当前的播放项目变化时
  // 同步后台播放队列
  // 同步App播放通知
  Future<void> _updateMediaItem(AppPlayer player) async {
    final playQueue = player.playQueue;
    final noTitle = AppLocalizations.of(context)?.noTitle;
    if (playQueue.index >= playQueue.songs.length) {
      const item = MediaItem(
        id: '-1',
        album: 'MeloTrip',
        title: 'MeloTrip',
        artist: 'MeloTrip',
        duration: Duration.zero,
        playable: false,
      );
      player.addMediaItem(item);
      // print('empty play queu ${playQueue.index} ${playQueue.songs.length}');
      // Http.get('/rest/savePlayQueue?id=');
      return;
    }

    final auth = await ref.read(currentUserProvider.future);

    final song = playQueue.songs[playQueue.index];
    final url =
        '$proxyCacheHost/rest/getCoverArt?id=${song.id}&u=${auth?.username}&t=${auth?.subsonicToken}&s=${auth?.subsonicSalt}&_=${DateTime.now().toIso8601String()}&f=json&v=1.8.0&c=MeloTrip';

    final duartion = song.duration;
    final item = MediaItem(
      id: song.id ?? '-1',
      album: song.album,
      title: song.title ?? noTitle ?? '',
      artist: song.artist,
      duration: duartion != null ? Duration(seconds: duartion) : Duration.zero,
      artUri: Uri.parse(url),
    );

    player.addMediaItem(item);
    final ids = playQueue.songs.map((e) => 'id=${e.id}').join('&');
    final api = await ref.read(apiProvider.future);
    api.get('/rest/savePlayQueue?$ids&current=${item.id}');
  }

  Future<void> _updateScrolling(AppPlayer player, Duration position) async {
    if (_nowPlaying && _submission && position.inSeconds < 1) {
      _nowPlaying = false;
      _submission = false;
    } else if (!_nowPlaying && position.inSeconds > 1) {
      _nowPlaying = true;
      final playQueue = player.playQueue;
      if (playQueue.songs.isEmpty) {
        return;
      }
      final api = await ref.read(apiProvider.future);
      api.get(
        '/rest/scrobble',
        queryParameters: {
          'id': playQueue.songs[playQueue.index].id,
          'submission': false,
        },
      );
    } else if (!_submission &&
        position.inSeconds > (player.duration?.inSeconds ?? 0) * 2 / 3) {
      _submission = true;
      if (player.playQueue.songs.isEmpty) {
        return;
      }
      final api = await ref.read(apiProvider.future);
      api.get(
        '/rest/scrobble',
        queryParameters: {
          'id': player.playQueue.songs[player.playQueue.index].id,
          'time': DateTime.now().millisecondsSinceEpoch,
          'submission': true,
        },
      );
      ref
          .read(smartSuggestionProvider.notifier)
          .playHistory(
            song: player.playQueue.songs[player.playQueue.index],
            isComplted: true,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: userConfigProvider,
      nullableBuilder:
          (context, config, ref) => MaterialApp(
            scaffoldMessengerKey: _scaffoldMessengerKey,
            title: 'MeloTrip',
            themeMode: config?.theme,
            locale: config?.locale,
            darkTheme: ThemeData.dark(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: InitialPage(),
          ),
    );
  }
}
