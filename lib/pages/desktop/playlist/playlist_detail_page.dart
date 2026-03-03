import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/provider/playlist/playlist.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class DesktopPlaylistDetailPage extends ConsumerWidget {
  const DesktopPlaylistDetailPage({super.key, required this.playlistId});

  final String? playlistId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: AsyncValueBuilder(
        provider: playlistDetailProvider(playlistId),
        loading: (_, _) => const Center(child: CircularProgressIndicator()),
        empty: (_, _) => const NoData(),
        builder: (context, data, ref) {
          final playlist = data.subsonicResponse?.playlist;
          final songs = playlist?.entry ?? [];
          if (playlist == null) return const NoData();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 190,
                backgroundColor: theme.colorScheme.surface,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 70, 20, 16),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: ArtworkImage(
                            id: playlist.id,
                            width: 120,
                            height: 120,
                            fit: .cover,
                            size: 350,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: .end,
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                playlist.name ?? '-',
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(fontWeight: .w800),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${playlist.songCount ?? songs.length} ${l10n.songCountUnit}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        FilledButton.icon(
                          onPressed: songs.isEmpty
                              ? null
                              : () => _playAll(ref, songs),
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: Text(l10n.play),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                sliver: SliverList.builder(
                  itemCount: songs.length,
                  itemBuilder: (_, index) {
                    final song = songs[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: theme.colorScheme.surfaceContainerHigh
                            .withValues(alpha: .55),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => _playSong(ref, song),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  child: Text('${index + 1}'),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    song.title ?? '-',
                                    maxLines: 1,
                                    overflow: .ellipsis,
                                  ),
                                ),
                                Text(_formatSec(song.duration ?? 0)),
                              ],
                            ),
                          ),
                        ),
                      ),
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
    if (player == null) return;
    await player.setPlaylist(songs: songs, initialId: songs.firstOrNull?.id);
    await player.play();
  }

  Future<void> _playSong(WidgetRef ref, SongEntity song) async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) return;
    await player.insertAndPlay(song);
  }

  String _formatSec(int sec) {
    final m = (sec ~/ 60).toString().padLeft(1, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
