import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/mobile/playlist/edit_playlist_page.dart';
import 'package:melo_trip/pages/mobile/song_control/song_control.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/sliver_app_bar.dart';
part 'parts/playlist_info_header.dart';
part 'parts/playlist_action_bar.dart';
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
        builder: (context, result, ref) {
          final playlist = result.data;
          if (playlist == null) {
            return const NoData();
          }
          return CustomScrollView(
            slivers: [
              _SliverAppBar(playlist: playlist),
              _PlaylistInfoHeader(playlist: playlist),
              _PlaylistActionBar(playlist: playlist),
              if (playlist.entry != null)
                _PlaylistDetailBuilder(playlist: playlist),
              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),
            ],
          );
        },
      ),
    );
  }
}
