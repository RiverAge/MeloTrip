import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class CurrentSongBuilder extends StatelessWidget {
  const CurrentSongBuilder(
      {super.key, required this.builder, this.loadingBuilder});

  final Widget Function(BuildContext context, SongEntity? current,
      List<SongEntity?> sequence, int index, WidgetRef ref) builder;

  final Widget Function(BuildContext context, WidgetRef ref)? loadingBuilder;

  @override
  Widget build(BuildContext context) {
    return AsyncStreamBuilder(
        provider: sequenceStreamProvider,
        loading: (ctx, ref) => loadingBuilder == null
            ? const SizedBox.shrink()
            : loadingBuilder!(ctx, ref),
        emptyBuilder: (context, ref) => builder(context, null, [], -1, ref),
        builder: (_, sequence, __) {
          return AsyncStreamBuilder(
              loading: (ctx, ref) => loadingBuilder == null
                  ? const SizedBox.shrink()
                  : loadingBuilder!(ctx, ref),
              provider: currentIndexStreamProvider,
              builder: (_, currentIndex, ref) {
                final songs = sequence;
                final index = currentIndex;
                if (songs == null ||
                    songs.isEmpty ||
                    index == null ||
                    index == -1 ||
                    index >= songs.length) {
                  return builder(context, null, [], -1, ref);
                }
                return builder(context, songs[index], songs, index, ref);
              });
        });
  }
}
              // })});
    // return AsyncValueBuilder(
    //   provider: appPlayerProvider,
    //   loading: (p0) => const SizedBox.shrink(),
    //   builder: (p0, data, ref) {
    //     final song = data.sequenceState?.currentSource?.tag as Song?;
    //     if (song == null) {
    //       return empty == null ? const SizedBox.shrink() : empty!(context, ref);
    //     }
    //     return builder(p0, song, ref);
    //   },
    // );
