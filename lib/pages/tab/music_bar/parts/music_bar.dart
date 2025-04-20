import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/playing/playing_page.dart';
import 'package:melo_trip/provider/lyrics/lyrics.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/svc/app_player/player_handler.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/guesture_hint.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'bottom_sheet_playlist.dart';
part 'bottom_sheet_actions_shuffle.dart';
part 'bottom_sheet_item.dart';
part 'bottom_sheet_title.dart';
part 'colored_container.dart';
part 'bottom_sheet_actions_mode.dart';

class MusicBar extends StatefulWidget {
  const MusicBar({super.key});

  @override
  State<StatefulWidget> createState() => _MusicBarState();
}

class _MusicBarState extends State<MusicBar> {
  @override
  void initState() {
    super.initState();
  }

  _onOpenPlaylist(BuildContext context) async {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder:
          (context) => const FractionallySizedBox(
            heightFactor: 0.6,
            child: _BottomSheetPlaylist(),
          ),
    );
  }

  _onOpenPlaying(BuildContext context) {
    // final renderBox = context.findRenderObject() as RenderBox?;
    // final rect = renderBox != null
    //     ? (renderBox.globalToLocal(Offset.zero) & renderBox.size)
    //     : Rect.zero;
    // print('retct $rect');
    // final relativeRect =
    //     RelativeRect.fromSize(rect, MediaQuery.of(context).size);
    // final relativeRectTween =
    //     RelativeRectTween(begin: relativeRect, end: RelativeRect.fill);
    // final realtiveAnimation =
    //     relativeRectTween.chain(CurveTween(curve: Curves.ease));
    // final pageRouteBuilder = PageRouteBuilder(
    //     pageBuilder: (_, __, ___) => const PlayingPage(),
    //     transitionDuration: const Duration(seconds: 10),
    //     transitionsBuilder: (_, animation, __, child) {
    //       return Stack(
    //         children: [
    //           PositionedTransition(
    //               rect: realtiveAnimation.animate(animation), child: child)
    //         ],
    //       );
    //     });
    // Navigator.of(context).push(pageRouteBuilder);

    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PlayingPage()));

    // showModalBottomSheet(
    //     isScrollControlled: true,
    //     shape: const RoundedRectangleBorder(
    //         borderRadius: BorderRadius.vertical(top: Radius.circular(0))),
    //     context: context,
    //     builder: (context2) => const PlayingPage());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: _ColoredContainer(),
        ),
        PlayQueueBuilder(
          builder: (_, playQueue, ref) {
            if (playQueue.index >= playQueue.songs.length) {
              return ListTile(
                leading: SizedBox(
                  width: 50,
                  child: Image.asset('images/navidrome.png'),
                ),
                title: const Text('MeloTrip'),
                subtitle: const Text('Elevate with the Symphony'),
              );
            }
            final current = playQueue.songs[playQueue.index];
            return ListTile(
              onTap: () => _onOpenPlaying(context),
              leading: SizedBox(
                width: 50,
                child: ArtworkImage(fit: BoxFit.contain, id: current.id),
              ),
              title: Text(
                '${current.title} - ${current.artist}',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: AsyncValueBuilder(
                provider: lyricsProvider(current.id),
                loading: (_, __) => const SizedBox.shrink(),
                builder: (_, lyrics, __) {
                  return AsyncStreamBuilder(
                    loading: (p0, _) => const SizedBox.shrink(),
                    provider: positionStreamProvider,
                    builder: (_, position, ref) {
                      return Text(
                        ref.watch(lyricsOfLineProvider(lyrics, position)),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      );
                    },
                  );
                },
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AsyncStreamBuilder(
                    provider: playingStreamProvider,
                    loading: (_, __) => const SizedBox.shrink(),
                    builder: (context, data, ref) {
                      return IconButton(
                        style: IconButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.all(0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () async {
                          final handler = await AppPlayerHandler.instance;
                          final player = handler.player;
                          player.playOrPause();
                        },
                        icon: Icon(
                          data
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outlined,
                          size: 35,
                        ),
                      );
                    },
                  ),
                  IconButton(
                    style: IconButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.all(0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () => _onOpenPlaylist(context),
                    icon: const Icon(Icons.playlist_play_sharp, size: 35),
                  ),
                ],
              ),
            );
          },
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 2,
          child: _durationBulder(),
        ),
      ],
    );
  }

  _durationBulder() {
    // 这里just_audio偶尔无法获取duration，这里使用后端返回的数据
    return PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        if (playQueue.index >= playQueue.songs.length) {
          return const SizedBox.shrink();
        }
        final current = playQueue.songs[playQueue.index];
        final serverDuration = Duration(seconds: current.duration ?? 0);

        return AsyncStreamBuilder(
          loading: (context, _) => const SizedBox.shrink(),
          provider: durationStreamProvider,
          emptyBuilder: (_, ref) => _positionBuilder(duration: serverDuration),
          builder:
              (_, duration, __) =>
                  _positionBuilder(duration: duration ?? serverDuration),
        );
      },
    );
  }

  _positionBuilder({Duration? duration}) {
    return AsyncStreamBuilder(
      loading: (context, _) => const SizedBox.shrink(),
      provider: positionStreamProvider,
      emptyBuilder: (_, __) => _progressBuilder(duration: duration),
      builder:
          (_, position, __) =>
              _progressBuilder(duration: duration, position: position),
    );
  }

  _progressBuilder({Duration? duration, Duration? position}) {
    final effectivePosition = position?.inSeconds ?? 0;
    final effectiveDuration = duration?.inSeconds ?? 0;

    return LinearProgressIndicator(
      value: effectiveDuration == 0 ? 0 : effectivePosition / effectiveDuration,
    );
  }
}
