import 'package:media_kit/media_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/const/index.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/auth/auth.dart';
import 'package:melo_trip/provider/user_config/user_config.dart';

class PlayerMediaResolverRuntime {
  Future<void> attach(WidgetRef ref) async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) {
      return;
    }

    player.setMediaResolver((song) async {
      final auth = await ref.read(currentUserProvider.future);
      final config = await ref.read(userConfigProvider.future);
      final host = auth?.host;
      final baseHost = kIsWeb ? host : proxyCacheHost;
      final normalizedBase =
          baseHost == null || baseHost.isEmpty
              ? proxyCacheHost
              : baseHost.endsWith('/')
              ? baseHost.substring(0, baseHost.length - 1)
              : baseHost;

      final url = Uri.parse('$normalizedBase/rest/stream').replace(
        queryParameters: {
          'id': song.id,
          'u': auth?.username,
          't': auth?.token,
          's': auth?.salt,
          '_': DateTime.now().toIso8601String(),
          'f': 'json',
          'v': '1.8.0',
          'c': 'MeloTrip',
          'maxBitRate': config?.maxRate,
        }..removeWhere((_, value) => value == null || value.isEmpty),
      ).toString();

      return Media(url, extras: {'song': song});
    });
  }
}

final Provider<PlayerMediaResolverRuntime> playerMediaResolverRuntimeProvider =
    Provider<PlayerMediaResolverRuntime>((_) {
      return PlayerMediaResolverRuntime();
    });
