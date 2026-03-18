import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/mobile/song_control/song_control.dart';
import 'package:melo_trip/pages/mobile/playlist/add_to_playlist_page.dart';
import 'package:melo_trip/pages/shared/player/animated_lyrics_panel.dart';
import 'package:melo_trip/pages/shared/player/playback_background.dart';
import 'package:melo_trip/pages/shared/player/playback_media_meta_badge.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/lyrics/lyrics.dart';
import 'package:melo_trip/provider/song/song_detail.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/single_line_animated_lyrics.dart';
// import 'package:path/path.dart';

part 'parts/rotate_cover.dart';
part 'parts/timer_axis.dart';
part 'parts/player_controls.dart';
part 'parts/music_controls.dart';
part 'parts/artist_and_album.dart';
part 'parts/cover_background.dart';
part 'parts/blur_filter.dart';
part 'parts/animted_lyrics.dart';
part 'parts/cover_lyrics_switcher.dart';
part 'parts/rounded_cover.dart';
part 'parts/media_meta.dart';

class PlayingPage extends StatelessWidget {
  const PlayingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        final current = playQueue.index >= playQueue.songs.length
            ? null
            : playQueue.songs[playQueue.index];
        final effictiveArtist = current?.artists ?? [];
        final effectiveDisplayArtist = effictiveArtist.length > 1
            ? '${effictiveArtist.first.name}'
            : current?.displayArtist;
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
              statusBarBrightness: Brightness.dark,
            ),
            centerTitle: true,
            scrolledUnderElevation: 0,
            title: Column(
              children: [
                Text(
                  current?.title ?? '-',
                  style: const TextStyle(fontSize: 18, fontWeight: .bold),
                ),
                SizedBox(height: 2),
                if (effictiveArtist.length <= 2)
                  Text(
                    '$effectiveDisplayArtist',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withAlpha(127),
                    ),
                    textAlign: .left,
                  ),
                if (effictiveArtist.length > 2)
                  Row(
                    mainAxisSize: .min,
                    crossAxisAlignment: .end,
                    children: [
                      Text(
                        '${effictiveArtist[0].name} ${effictiveArtist[1].name}',
                        style: const TextStyle(fontSize: 11),
                      ),

                      Text(
                        AppLocalizations.of(
                          context,
                        )!.manyArtists(effictiveArtist.length),
                        style: TextStyle(
                          fontSize: 10,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(100),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            // title: Text(
            //   current?.title ?? '',
            //   style: const TextStyle(fontWeight: .bold),
            // ),
            actions: [
              AsyncValueBuilder(
                provider: songDetailProvider(current?.id),
                empty: (_, _) => SizedBox.shrink(),
                builder: (ctx, data, ref) {
                  final isStarred =
                      data.subsonicResponse?.song?.starred != null;
                  return IconButton(
                    onPressed: () {
                      ref
                          .read(songDetailProvider(current?.id).notifier)
                          .toggleFavoriteResult();
                    },
                    icon: Icon(
                      isStarred ? Icons.favorite : Icons.favorite_outline,
                      color: isStarred
                          ? Theme.of(context).colorScheme.primary
                          : null,
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Container(
                    height:
                        MediaQuery.paddingOf(context).top + kToolbarHeight + 8,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: .topCenter,
                        end: .bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.35),
                          Colors.black.withValues(alpha: 0.18),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                top: true,
                bottom: false,
                child: Column(
                  children: [
                    Expanded(child: _CoverLyricsSwitcher()),
                    _ArtistAndAlbum(),
                    _TimerAxis(),
                    _PlayerControls(),
                    _MusicControls(),
                    SizedBox(height: 18),
                  ],
                ),
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
