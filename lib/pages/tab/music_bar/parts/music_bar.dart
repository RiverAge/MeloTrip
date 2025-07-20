import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/playing/playing_page.dart';
import 'package:melo_trip/provider/api/api.dart';
import 'package:melo_trip/provider/lyrics/lyrics.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/guesture_hint.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'bottom_sheet_play_queue.dart';
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

  void _onOpenPlayQueue(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      builder:
          (context) => const FractionallySizedBox(
            heightFactor: 0.6,
            child: _BottomSheetPlayQueue(),
          ),
    );
  }

  void _onOpenPlaying(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const PlayingPage()));
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
              contentPadding: EdgeInsetsDirectional.only(start: 16.0, end: 8.0),
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
                loading: (_, _) => const SizedBox.shrink(),
                builder: (_, lyrics, _) {
                  return AsyncValueBuilder(
                    provider: appPlayerHandlerProvider,
                    builder: (context, player, _) {
                      return AsyncStreamBuilder(
                        loading: (_) => const SizedBox.shrink(),
                        provider: player.positionStream,
                        builder: (_, position) {
                          return Text(
                            ref.watch(lyricsOfLineProvider(lyrics, position)) ??
                                AppLocalizations.of(context)!.noLyricsFound,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              trailing: LayoutBuilder(
                builder: (context, dimens) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AsyncValueBuilder(
                        provider: appPlayerHandlerProvider,
                        builder: (context, player, _) {
                          return AsyncStreamBuilder(
                            provider: player.playingStream,
                            loading: (_) => const SizedBox.shrink(),
                            builder: (context, data) {
                              return IconButton(
                                style: IconButton.styleFrom(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
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
                          );
                        },
                      ),
                      IconButton(
                        style: IconButton.styleFrom(
                          // minimumSize: Size.zero,
                          // padding: const EdgeInsets.all(0),
                          // tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () => _onOpenPlayQueue(context),
                        icon: const Icon(Icons.playlist_play_sharp, size: 35),
                      ),
                      if (dimens.maxWidth >= 600) _volumeBuilder(),
                    ],
                  );
                },
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

  Widget _durationBulder() {
    // 这里just_audio偶尔无法获取duration，这里使用后端返回的数据
    return PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        if (playQueue.index >= playQueue.songs.length) {
          return const SizedBox.shrink();
        }
        final current = playQueue.songs[playQueue.index];
        final serverDuration = Duration(seconds: current.duration ?? 0);

        return AsyncValueBuilder(
          provider: appPlayerHandlerProvider,
          builder: (context, player, _) {
            return AsyncStreamBuilder(
              loading: (context) => const SizedBox.shrink(),
              provider: player.durationStream,
              emptyBuilder:
                  (_) => _positionBuilder(
                    duration: serverDuration,
                    player: player,
                  ),
              builder:
                  (_, duration) => _positionBuilder(
                    duration: duration ?? serverDuration,
                    player: player,
                  ),
            );
          },
        );
      },
    );
  }

  Widget _positionBuilder({Duration? duration, required AppPlayer player}) {
    return AsyncStreamBuilder(
      loading: (context) => const SizedBox.shrink(),
      provider: player.positionStream,
      emptyBuilder: (_) => _progressBuilder(duration: duration),
      builder:
          (_, position) =>
              _progressBuilder(duration: duration, position: position),
    );
  }

  Widget _progressBuilder({Duration? duration, Duration? position}) {
    final effectivePosition = position?.inSeconds ?? 0;
    final effectiveDuration = duration?.inSeconds ?? 0;

    return LinearProgressIndicator(
      value: effectiveDuration == 0 ? 0 : effectivePosition / effectiveDuration,
    );
  }

  Widget _volumeBuilder() {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return AsyncStreamBuilder(
          loading: (_) => const SizedBox.shrink(),
          provider: player.volumeStream,
          builder: (context, data) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 10),
                Icon(Icons.volume_up, size: 25),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    overlayShape: SliderComponentShape.noOverlay,
                    thumbShape: SliderComponentShape.noOverlay,
                  ),
                  child: Slider(
                    value: data,
                    min: 0.0,
                    max: 100.0,
                    onChanged: (value) {
                      player.setVolume(value);
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
