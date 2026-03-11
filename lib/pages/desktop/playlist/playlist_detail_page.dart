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
      backgroundColor: Colors.transparent,
      body: AsyncValueBuilder(
        provider: playlistDetailProvider(playlistId),
        loading: (_, _) => const Center(child: CircularProgressIndicator()),
        empty: (_, _) => const NoData(),
        builder: (context, data, ref) {
          final playlist = data.subsonicResponse?.playlist;
          final songs = playlist?.entry ?? [];
          if (playlist == null) return const NoData();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              _PlaylistHeader(
                playlist: playlist,
                songs: songs,
                l10n: l10n,
                onPlayAll: () => _playAll(ref, songs),
                onPlayNext: () => _playNext(ref, songs),
                onPlayLast: () => _playLast(ref, songs),
              ),
              // ── Toolbar ──
              _PlaylistToolbar(l10n: l10n),
              // ── Table Header ──
              _TrackTableHeader(theme: theme, l10n: l10n),
              const Divider(height: 1),
              // ── Track List ──
              Expanded(
                child: ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (_, index) {
                    final song = songs[index];
                    return _TrackRow(
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
    for (final song in songs) {
      await player.insertAndPlay(song);
    }
  }

  Future<void> _playLast(WidgetRef ref, List<SongEntity> songs) async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null || songs.isEmpty) return;
    await player.setPlaylist(
      songs: songs,
      initialId: songs.lastOrNull?.id,
    );
    await player.play();
  }

  Future<void> _playSong(WidgetRef ref, SongEntity song) async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) return;
    await player.insertAndPlay(song);
  }
}

// ─────────────────────────────────────────────
// Header: artwork + label + title + buttons
// ─────────────────────────────────────────────
class _PlaylistHeader extends StatelessWidget {
  const _PlaylistHeader({
    required this.playlist,
    required this.songs,
    required this.l10n,
    required this.onPlayAll,
    required this.onPlayNext,
    required this.onPlayLast,
  });

  final dynamic playlist;
  final List<SongEntity> songs;
  final AppLocalizations l10n;
  final VoidCallback onPlayAll;
  final VoidCallback onPlayNext;
  final VoidCallback onPlayLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Artwork
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: ArtworkImage(
              id: playlist.id,
              width: 160,
              height: 160,
              fit: BoxFit.cover,
              size: 400,
            ),
          ),
          const SizedBox(width: 24),
          // Info column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  l10n.playlist,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant
                        .withValues(alpha: .7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  playlist.name ?? '-',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Play button (filled, primary)
                    FilledButton.icon(
                      onPressed: songs.isEmpty ? null : onPlayAll,
                      icon: const Icon(Icons.play_arrow_rounded, size: 20),
                      label: Text(l10n.play),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Next button (outlined)
                    OutlinedButton.icon(
                      onPressed: songs.isEmpty ? null : onPlayNext,
                      icon: const Icon(Icons.redo_rounded, size: 18),
                      label: Text(l10n.playAddToNext),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Last button (outlined)
                    OutlinedButton.icon(
                      onPressed: songs.isEmpty ? null : onPlayLast,
                      icon: const Icon(Icons.skip_next_rounded, size: 18),
                      label: Text(l10n.playAddToLast),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        side: BorderSide(
                          color: theme.colorScheme.outlineVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Toolbar: shuffle icon + track label + sort
// ─────────────────────────────────────────────
class _PlaylistToolbar extends StatelessWidget {
  const _PlaylistToolbar({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.shuffle_rounded, size: 18, color: iconColor),
          const SizedBox(width: 16),
          Text(
            l10n.track,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 16),
          Icon(Icons.sort_by_alpha_rounded, size: 18, color: iconColor),
          const SizedBox(width: 12),
          Icon(Icons.filter_list_rounded, size: 18, color: iconColor),
          const SizedBox(width: 12),
          Icon(Icons.refresh_rounded, size: 18, color: iconColor),
          const SizedBox(width: 12),
          Icon(Icons.more_horiz_rounded, size: 18, color: iconColor),
          const Spacer(),
          Text(
            l10n.edit,
            style: theme.textTheme.labelMedium?.copyWith(color: iconColor),
          ),
          const SizedBox(width: 16),
          Icon(Icons.expand_less_rounded, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Icon(Icons.grid_view_rounded, size: 18, color: iconColor),
          const SizedBox(width: 8),
          Icon(Icons.tune_rounded, size: 18, color: iconColor),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Table header row
// ─────────────────────────────────────────────
class _TrackTableHeader extends StatelessWidget {
  const _TrackTableHeader({required this.theme, required this.l10n});
  final ThemeData theme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final headerStyle = _headerStyle.copyWith(
      color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .7),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: Row(
        children: [
          SizedBox(width: 40, child: Text('#', style: headerStyle)),
          Expanded(flex: 4, child: Text(l10n.title, style: headerStyle)),
          SizedBox(
            width: 60,
            child: Icon(
              Icons.access_time_rounded,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .5),
            ),
          ),
          Expanded(flex: 3, child: Text(l10n.album, style: headerStyle)),
          Expanded(flex: 2, child: Text(l10n.songMetaGenre, style: headerStyle)),
          SizedBox(width: 60, child: Text(l10n.songMetaYear, style: headerStyle)),
          const SizedBox(width: 30),
        ],
      ),
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.2,
  );
}

// ─────────────────────────────────────────────
// Single track row
// ─────────────────────────────────────────────
class _TrackRow extends StatelessWidget {
  const _TrackRow({
    required this.index,
    required this.song,
    required this.onTap,
  });
  final int index;
  final SongEntity song;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 40,
              child: Text(
                '$index',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: ArtworkImage(
                      id: song.id,
                      size: 80,
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          song.title ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          song.artist ?? '-',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: .7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(
                _formatSec(song.duration ?? 0),
                style: theme.textTheme.bodySmall,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                song.album ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                song.genre ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall,
              ),
            ),
            SizedBox(
              width: 60,
              child: Text(
                '${song.year ?? ""}',
                style: theme.textTheme.bodySmall,
              ),
            ),
            Icon(
              Icons.favorite_border_rounded,
              size: 16,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .4),
            ),
          ],
        ),
      ),
    );
  }

  String _formatSec(int sec) {
    final m = (sec ~/ 60).toString().padLeft(1, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
