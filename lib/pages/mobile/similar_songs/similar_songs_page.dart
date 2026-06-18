import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/sonic_similarity/sonic_similarity.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

/// Page for displaying similar songs using AudioMuse-AI sonic similarity.
///
/// IMPORTANT: This uses getSonicSimilarTracks, NOT getSimilarSongs2.
/// If the feature is unavailable, shows appropriate message.
class SimilarSongsPage extends ConsumerWidget {
  const SimilarSongsPage({super.key, required this.songId, this.songTitle});

  final String? songId;
  final String? songTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.similarSongsTitle(songTitle ?? '')),
        actions: [
          // Play all button
          IconButton(
            icon: const Icon(Icons.play_arrow),
            tooltip: l10n.play,
            onPressed: () async {
              final result = await ref.read(
                similarSongsProvider(songId: songId ?? '', count: 50).future,
              );
              result.when(
                ok: (songs) async {
                  if (songs.isEmpty) return;
                  final player = await ref.read(
                    appPlayerHandlerProvider.future,
                  );
                  if (player != null) {
                    await player.setPlaylist(
                      songs: songs,
                      initialId: songs.first.id,
                    );
                    await player.play();
                  }
                },
                err: (_) {},
              );
            },
          ),
        ],
      ),
      body: AsyncValueBuilder(
        provider: similarSongsProvider(songId: songId ?? '', count: 30),
        builder: (context, result, ref) {
          // result is Result<List<SongEntity>, AppFailure>
          return result.when(
            ok: (songs) {
              if (songs.isEmpty) {
                return Center(child: Text(l10n.noSimilarSongsFound));
              }
              return _SimilarSongsList(songs: songs);
            },
            err: (error) => Center(child: Text(error.message)),
          );
        },
      ),
    );
  }
}

class _SimilarSongsList extends ConsumerWidget {
  const _SimilarSongsList({required this.songs});

  final List<SongEntity> songs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return ListTile(
          leading: ArtworkImage(id: song.coverArt, size: 56, fit: BoxFit.cover),
          title: Text(
            song.title ?? l10n.noTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            '${song.artist ?? ''} • ${song.album ?? ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Text(
            _formatDuration(song.duration),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          onTap: () async {
            final player = await ref.read(appPlayerHandlerProvider.future);
            if (player != null) {
              await player.insertAndPlay(song);
            }
          },
        );
      },
    );
  }

  String _formatDuration(int? seconds) {
    if (seconds == null) return '';
    final min = seconds ~/ 60;
    final sec = seconds % 60;
    return '$min:${sec.toString().padLeft(2, '0')}';
  }
}
