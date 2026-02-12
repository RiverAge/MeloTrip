import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/mixin/song_control/song_control.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/rating.dart';

part 'parts/album_cover.dart';
part 'parts/album_info.dart';
part 'parts/album_play_all.dart';
part 'parts/blurred_filter.dart';
part 'parts/list_item.dart';
part 'parts/list_item_head.dart';

class AlbumDetailPage extends StatelessWidget {
  const AlbumDetailPage({super.key, required this.albumId});

  final String? albumId;

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: albumDetailProvider(albumId),

      builder: (context, data, ref) {
        final album = data.subsonicResponse?.album;
        if (album == null) {
          return const NoData();
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(album.name ?? ''),
            actions: [
              IconButton(
                onPressed: () {
                  ref
                      .read(albumFavoriteProvider.notifier)
                      .toggleFavorite(album);
                },
                icon: album.starred != null
                    ? const Icon(Icons.favorite, color: Colors.red)
                    : const Icon(Icons.favorite_outline),
              ),
            ],
          ),
          body:
              // _SliverAppBar(
              //   album: album,
              //   onToggleFavorite: () {
              //     ref
              //         .read(albumFavoriteProvider.notifier)
              //         .toggleFavorite(album);
              //   },
              //   onUpdateRating: (rating) {
              //     ref
              //         .read(albumRatingProvider.notifier)
              //         .updateRating(album.id, rating);
              //   },
              // // ),
              // SliverToBoxAdapter(
              //   child: SizedBox(
              //     height: (DividerTheme.of(context).space ?? 16) / 2,
              //   ),
              // ),
              ListView.builder(
                itemCount: (album.song?.length ?? 0) + 1,
                itemBuilder: (_, idx) {
                  if (idx == 0) {
                    return ListItemHead(
                      album: album,
                      onUpdateRating: (rating) {
                        ref
                            .read(albumRatingProvider.notifier)
                            .updateRating(album.id, rating);
                      },
                    );
                  }
                  final index = idx - 1;
                  final song = album.song?[index];
                  return Column(
                    children: [
                      if (index == 0 ||
                          album.song?[index - 1].discNumber != song?.discNumber)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'DISC ${song?.discNumber}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withAlpha(100),
                              ),
                            ),
                          ),
                        ),
                      _ListItem(song: song, idx: idx),
                    ],
                  );
                },
              ),
        );
      },
    );
  }
}
