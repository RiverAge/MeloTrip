import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/mixin/song_control/song_control.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/playlist/edit_playlist_page.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/svc/app_player/player_handler.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/endof_data.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/sliver_app_bar.dart';
part 'parts/playlist_detail_builder.dart';

class PlaylistDetailPage extends StatefulWidget {
  const PlaylistDetailPage({super.key, required this.playlistId});

  final String? playlistId;

  @override
  State<StatefulWidget> createState() => _PlaylistDetailPage();
}

class _PlaylistDetailPage extends State<PlaylistDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AsyncValueBuilder(
        provider: playlistDetailProvider(widget.playlistId),
        builder: (context, data, ref) {
          final playlist = data.subsonicResponse?.playlist;
          if (playlist == null) {
            return const NoData();
          }
          return CustomScrollView(
            slivers: [
              _SliverAppBar(playlist: playlist),
              if (playlist.entry != null)
                _PlaylistDetailBuilder(playlist: playlist),
              SliverToBoxAdapter(
                child:
                    playlist.entry != null ? const EndofData() : const NoData(),
              ),
            ],
          );
        },
      ),
    );
  }
}
