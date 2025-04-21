import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/mixin/song_control/song_control.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/svc/app_player/player_handler.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/endof_data.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/rating.dart';

part 'parts/sliver_app_bar.dart';
part 'parts/album_cover.dart';
part 'parts/album_info.dart';
part 'parts/album_play_all.dart';
part 'parts/blurred_filter.dart';
part 'parts/list_item.dart';

class AlbumDetailPage extends StatelessWidget {
  const AlbumDetailPage({super.key, required this.albumId});

  final String? albumId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AsyncValueBuilder(
        provider: albumDetailProvider(albumId),
        builder: (context, data, ref) {
          final album = data.subsonicResponse?.album;
          if (album == null) {
            return const NoData();
          }
          return CustomScrollView(
            slivers: [
              _SliverAppBar(
                album: album,
                onToggleFavorite: () {
                  ref
                      .read(albumFavoriteProvider.notifier)
                      .toggleFavorite(album.id);
                },
                onUpdateRating: (rating) {
                  ref
                      .read(albumRatingProvider.notifier)
                      .updateRating(album.id, rating);
                },
              ),
              SliverList.separated(
                separatorBuilder: (context, index) => const Divider(),
                itemCount: album.song?.length ?? 0,
                itemBuilder: (_, idx) {
                  final song = album.song?[idx];
                  return _ListItem(song: song, idx: idx);
                },
              ),
              const SliverToBoxAdapter(child: EndofData()),
            ],
          );
        },
      ),
    );
  }
}
