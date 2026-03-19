import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/playlist/playlist.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

part 'parts/playlist_detail_sections.dart';
part 'parts/playlist_track_table.dart';

class DesktopPlaylistDetailPage extends ConsumerWidget {
  const DesktopPlaylistDetailPage({super.key, required this.playlistId});

  final String? playlistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0),
      child: AsyncValueBuilder(
        provider: playlistDetailProvider(playlistId),
        loading: (_, _) => const Center(child: CircularProgressIndicator()),
        empty: (_, _) => const NoData(),
        builder: (context, result, ref) {
          if (result.isErr) {
            return const NoData();
          }
          final playlist = result.data;
          final List<SongEntity> songs =
              playlist?.entry ?? const <SongEntity>[];
          if (playlist == null) return const NoData();

          return Column(
            crossAxisAlignment: .start,
            children: [
              PlaylistHeader(
                playlist: playlist,
                songs: songs,
                l10n: l10n,
                onPlayAll: () => _playAll(ref, songs),
                onPlayNext: () => _playNext(ref, songs),
                onPlayLast: () => _playLast(ref, songs),
              ),
              PlaylistToolbar(l10n: l10n),
              PlaylistTrackTableHeader(theme: theme, l10n: l10n),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (_, index) {
                    final SongEntity song = songs[index];
                    return PlaylistTrackRow(
                      index: index + 1,
                      song: song,
                      onTap: () => _playSong(ref, song),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _playAll(WidgetRef ref, List<SongEntity> songs) async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null || songs.isEmpty) return;
    await player.setPlaylist(songs: songs, initialId: songs.firstOrNull?.id);
    await player.play();
  }

  Future<void> _playNext(WidgetRef ref, List<SongEntity> songs) async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null || songs.isEmpty) return;
    for (final SongEntity song in songs) {
      await player.insertAndPlay(song);
    }
  }

  Future<void> _playLast(WidgetRef ref, List<SongEntity> songs) async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null || songs.isEmpty) return;
    await player.setPlaylist(songs: songs, initialId: songs.lastOrNull?.id);
    await player.play();
  }

  Future<void> _playSong(WidgetRef ref, SongEntity song) async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) return;
    await player.insertAndPlay(song);
  }
}

