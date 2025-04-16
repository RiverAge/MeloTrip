import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/mixin/song_control/song_control.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/pages/playlist/add_to_playlist_page.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/lyrics/lyrics.dart';
import 'package:melo_trip/provider/song/song_detail.dart';
import 'package:melo_trip/svc/app_player/player_handler.dart';
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
part 'parts/top_bar.dart';
part 'parts/animted_lyrics.dart';
part 'parts/cover_lyrics_switcher.dart';

class PlayingPage extends StatelessWidget {
  const PlayingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          _CoverBackground(),
          _BlurFilter(
            children: [
              _TopBar(),
              _CoverLyricsSwitcher(),
              Column(
                children: [
                  _ArtistAndAlbum(),
                  _TimerAxis(),
                  _PlayerControls(),
                  _MusicControls(),
                  SizedBox(height: 18),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
