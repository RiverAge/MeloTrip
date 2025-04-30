import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/initial/initial_page.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';
import 'package:melo_trip/svc/app_player/player_handler.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/fixed_center_circular.dart';

// import 'package:flutter/scheduler.dart' show timeDilation;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey();
  Http? _http;
  AppPlayer? _appPlayer;
  StreamSubscription? _playQueueSubscription;

  _addListner() async {
    _http = await Http.instance;
    _http?.addErrorScanfoldMessageListner(_onErrorScanfoldMessage);

    final handler = await AppPlayerHandler.instance;
    _appPlayer = handler.player;
    _playQueueSubscription = _appPlayer?.playQueueStream.listen(
      (_) => _updateMediaItem(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _http?.removeErrorScanfoldMessageListner(_onErrorScanfoldMessage);
    _playQueueSubscription?.cancel();
  }

  Future<void> _onErrorScanfoldMessage({
    required String errorMsg,
    int? statusCode,
  }) async {
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
  Future<void> _updateMediaItem() async {
    final playQueue = _appPlayer?.playQueue;
    final noTitle = AppLocalizations.of(context)?.noTitle;
    if (playQueue == null) return;
    if (playQueue.index >= playQueue.songs.length) {
      const item = MediaItem(
        id: '-1',
        album: 'MeloTrip',
        title: 'MeloTrip',
        artist: 'MeloTrip',
        duration: Duration.zero,
        playable: false,
      );
      _appPlayer?.addMediaItem(item);
      // print('empty play queu ${playQueue.index} ${playQueue.songs.length}');
      // Http.get('/rest/savePlayQueue?id=');
      return;
    }
    final song = playQueue.songs[playQueue.index];
    final url = await buildSubsonicUrl(
      '/rest/getCoverArt?id=${song.id}',
      proxy: true,
    );
    final duartion = song.duration;
    final item = MediaItem(
      id: song.id ?? '-1',
      album: song.album,
      title: song.title ?? noTitle ?? '',
      artist: song.artist,
      duration: duartion != null ? Duration(seconds: duartion) : Duration.zero,
      artUri: Uri.parse(url),
    );

    _appPlayer?.addMediaItem(item);
    final ids = playQueue.songs.map((e) => e.id).join(',');
    Http.get('/rest/savePlayQueue?id=$ids&current=${item.id}');
  }

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: appThemeModeProvider,
      nullableBuilder:
          (context, themeMode, ref) => AsyncValueBuilder(
            provider: appLocaleProvider,
            nullableBuilder:
                (context, locale, ref) => MaterialApp(
                  scaffoldMessengerKey: _scaffoldMessengerKey,
                  title: 'MeloTrip',
                  themeMode: themeMode,
                  locale: locale,
                  darkTheme: ThemeData.dark(),
                  localizationsDelegates:
                      AppLocalizations.localizationsDelegates,
                  supportedLocales: AppLocalizations.supportedLocales,
                  home: FutureBuilder(
                    future: _addListner(),
                    builder:
                        (context, snapshot) =>
                            snapshot.connectionState == ConnectionState.waiting
                                ? const FixedCenterCircular()
                                : const InitialPage(),
                  ),
                ),
          ),
    );
  }
}
