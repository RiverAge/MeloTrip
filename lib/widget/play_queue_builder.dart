import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class PlayQueueBuilder extends StatelessWidget {
  const PlayQueueBuilder({
    super.key,
    required this.builder,
    this.loadingBuilder,
  });

  final Widget Function(
    BuildContext context,
    PlayQueue playQueue,
    WidgetRef ref,
  )
  builder;

  final Widget Function(BuildContext context, WidgetRef ref)? loadingBuilder;

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, ref) {
        return AsyncStreamBuilder(
          provider: player.playQueueStream,
          loading:
              (ctx) =>
                  loadingBuilder == null
                      ? const SizedBox.shrink()
                      : loadingBuilder!(ctx, ref),
          emptyBuilder:
              (context) =>
                  builder(context, PlayQueue(songs: [], index: 0), ref),
          builder: (_, playQueue) {
            return builder(context, playQueue, ref);
          },
        );
      },
    );
  }
}
