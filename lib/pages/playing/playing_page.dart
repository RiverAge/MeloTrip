import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/mixin/song_control/song_control.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/pages/playlist/add_to_playlist_page.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/lyrics/lyrics.dart';
import 'package:melo_trip/provider/song/song_detail.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/rotate_cover.dart';
part 'parts/timer_axis.dart';
part 'parts/player_controls.dart';
part 'parts/music_controls.dart';
part 'parts/artist_and_album.dart';
part 'parts/cover_background.dart';
part 'parts/blur_filter.dart';
part 'parts/animted_lyrics.dart';
part 'parts/cover_lyrics_switcher.dart';

class PlayingPage extends StatelessWidget {
  const PlayingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        final current =
            playQueue.index >= playQueue.songs.length
                ? null
                : playQueue.songs[playQueue.index];
        return Scaffold(
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            centerTitle: true,
            scrolledUnderElevation: 0,
            title: Text(
              current?.title ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            actions: [
              AsyncValueBuilder(
                provider: songDetailProvider(current?.id),
                builder: (ctx, data, ref) {
                  final isStarred =
                      data.subsonicResponse?.song?.starred != null;
                  return IconButton(
                    onPressed: () {
                      ref
                          .read(songFavoriteProvider.notifier)
                          .toggleFavorite(current);
                    },
                    icon: Icon(
                      isStarred ? Icons.favorite : Icons.favorite_outline,
                      color: isStarred ? Theme.of(context).colorScheme.primary : null,
                    ),
                  );
                },
              ),
            ],
          ),
          body: Stack(
            children: [
              _CoverBackground(),
              _BlurFilter(),
              Column(
                children: [
                  // SizedBox(height: AppBar().preferredSize.height),
                  Expanded(child: _CoverLyricsSwitcher()),
                  _ArtistAndAlbum(),
                  _TimerAxis(),
                  _PlayerControls(),
                  _MusicControls(),
                  SizedBox(height: 18),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Stack(
  //       children: [
  //         _CoverBackground(),
  //         _BlurFilter(),
  //         Column(
  //           children: [
  //             _TopBar(),
  //             _CoverLyricsSwitcher(),
  //             Column(
  //               children: [
  //                 _ArtistAndAlbum(),
  //                 _TimerAxis(),
  //                 _PlayerControls(),
  //                 _MusicControls(),
  //                 SizedBox(height: 18),
  //               ],
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  //   @override
  //   Widget build(BuildContext context) {
  //     return const Scaffold(
  //       body: Stack(
  //         children: [
  //           _CoverBackground(),
  //           _BlurFilter(
  //             children: [
  //               _TopBar(),
  //               _CoverLyricsSwitcher(),
  //               Column(
  //                 children: [
  //                   _ArtistAndAlbum(),
  //                   _TimerAxis(),
  //                   _PlayerControls(),
  //                   _MusicControls(),
  //                   SizedBox(height: 18),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     );
  //   }
}
