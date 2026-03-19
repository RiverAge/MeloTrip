import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/pages/mobile/song_control/song_control.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/rating.dart';

part 'parts/album_cover.dart';
part 'parts/album_info.dart';
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
        final album = data.data?.subsonicResponse?.album;
        if (album == null) {
          return const NoData();
        }
        return AsyncValueBuilder(
          provider: appPlayerHandlerProvider,
          builder: (context, player, _) {
            return PlayQueueBuilder(
              builder: (context, playQueue, _) {
                final currentSong = playQueue.index >= playQueue.songs.length
                    ? null
                    : playQueue.songs[playQueue.index];
                return AsyncStreamBuilder(
                  provider: player.playingStream,
                  loading: (_) => _buildPage(
                    context: context,
                    ref: ref,
                    album: album,
                    player: player,
                    currentSongId: currentSong?.id,
                    isPlaying: false,
                  ),
                  builder: (_, playing) => _buildPage(
                    context: context,
                    ref: ref,
                    album: album,
                    player: player,
                    currentSongId: currentSong?.id,
                    isPlaying: playing,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildPage({
    required BuildContext context,
    required WidgetRef ref,
    required AlbumEntity album,
    required AppPlayer player,
    required String? currentSongId,
    required bool isPlaying,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(album.name ?? ''),
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(albumDetailProvider(albumId).notifier)
                  .toggleFavoriteResult();
            },
            icon: album.starred != null
                ? const Icon(Icons.favorite, color: Colors.red)
                : const Icon(Icons.favorite_outline),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: (album.song?.length ?? 0) + 1,
        itemBuilder: (_, idx) {
          if (idx == 0) {
            return ListItemHead(
              album: album,
              onUpdateRating: (rating) {
                ref
                    .read(albumDetailProvider(album.id).notifier)
                    .setRatingResult(rating);
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
                    alignment: .centerLeft,
                    child: Text(
                      l10n.albumDiscLabel(song?.discNumber ?? 1),
                      textAlign: .left,
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withAlpha(100),
                      ),
                    ),
                  ),
                ),
              _ListItem(
                song: song,
                idx: idx,
                player: player,
                isCurrentPlaying: currentSongId == song?.id && isPlaying,
              ),
            ],
          );
        },
      ),
    );
  }
}
