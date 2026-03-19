import 'package:media_kit/media_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/helper/subsonic_uri_builder.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/user_session/user_session.dart';

class PlayerMediaResolverRuntime {
  Future<void> attach(WidgetRef ref) async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) {
      return;
    }

    player.setMediaResolver((song) async {
      final auth = await ref.read(sessionAuthProvider.future);
      final config = await ref.read(sessionConfigProvider.future);
      final url = SubsonicUriBuilder.buildStreamUri(
        auth: auth,
        songId: song.id ?? '',
        maxBitRate: config?.maxRate ?? '32',
      ).toString();

      return Media(url, extras: {'song': song});
    });
  }
}

final Provider<PlayerMediaResolverRuntime> playerMediaResolverRuntimeProvider =
    Provider<PlayerMediaResolverRuntime>((_) {
      return PlayerMediaResolverRuntime();
    });
