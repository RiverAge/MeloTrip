import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/album/album_detail_page.dart';
import 'package:melo_trip/pages/artist/artist_detail_page.dart';
import 'package:melo_trip/pages/playlist/add_to_playlist_page.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/song/song_detail.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/guesture_hint.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/widget/rating.dart';

part 'parts/song_meta.dart';
part 'parts/song_actions.dart';
part 'parts/song_title.dart';

mixin SongControl {
  Future<T?> showSongControlSheet<T>(
    BuildContext context,
    String? songId,
  ) async {
    final effectiveSongId = songId;
    if (effectiveSongId == null) return null;
    return showModalBottomSheet<T>(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      context: context,
      builder: (context) {
        return _SongControls(songId: effectiveSongId);
      },
    );
  }
}

class _SongControls extends StatelessWidget {
  const _SongControls({required this.songId});
  final String songId;
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: AsyncValueBuilder(
          provider: songDetailProvider(songId),
          builder: (ctx, data, ref) {
            final song = data.subsonicResponse?.song;
            if (song == null) return const Center(child: NoData());
            return SafeArea(
              child: Column(
                children: [
                  GestureHint(),
                  _SongTitle(song: song),
                  _SongActions(
                    song: song,
                    onToggleFavorite:
                        () => ref
                            .read(songFavoriteProvider.notifier)
                            .toggleFavorite(song),
                  ),
                  _SongMeta(song: song),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
