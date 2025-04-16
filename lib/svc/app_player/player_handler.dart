import 'dart:async';
import 'dart:developer';

import 'package:audio_service/audio_service.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/model/response/subsonic_response.dart';
import 'package:melo_trip/svc/http.dart';
import 'package:melo_trip/svc/user.dart';
import 'package:rxdart/rxdart.dart';

part 'parts/player.dart';
part 'parts/init.dart';
part 'parts/queue.dart';
part 'parts/media_item.dart';
part 'parts/state.dart';
part 'parts/stream.dart';
part 'parts/now_playing.dart';

class AppPlayerHandler {
  static Completer<AppPlayerHandler>? _completer;

  final AppPlayer _player;

  AppPlayer get player {
    return _player;
  }

  AppPlayerHandler._({required AppPlayer player}) : _player = player;

  static Future<AppPlayerHandler> get instance async {
    if (_completer == null) {
      final completer = Completer<AppPlayerHandler>();
      _completer = completer;

      final res = await AudioService.init(
        builder: () => AppPlayer(),
        config: const AudioServiceConfig(
          androidNotificationChannelId: 'com.meme.melotrip.audio',
          androidNotificationChannelName: 'Audio Service MeloTrip',
          androidNotificationOngoing: true,
        ),
      );
      final instance = AppPlayerHandler._(player: res);
      completer.complete((instance));
    }

    return _completer!.future;
  }
}
