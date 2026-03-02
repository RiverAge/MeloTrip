import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';
import 'package:melo_trip/model/response/album/album.dart';

class DesktopAlbumDetailPage extends ConsumerWidget {
  const DesktopAlbumDetailPage({super.key, required this.albumId});

  final String? albumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: AsyncValueBuilder(
        provider: albumDetailProvider(albumId),
        builder: (context, data, ref) {
          final album = data.subsonicResponse?.album;
          final songs = album?.song ?? [];
          if (album == null) return const NoData();

          return _AlbumDetailContent(album: album, songs: songs);
        },
      ),
    );
  }
}

class _AlbumDetailContent extends StatefulWidget {
  const _AlbumDetailContent({required this.album, required this.songs});
  final AlbumEntity album;
  final List<SongEntity> songs;

  @override
  State<_AlbumDetailContent> createState() => _AlbumDetailContentState();
}

class _AlbumDetailContentState extends State<_AlbumDetailContent> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 240 && !_showTitle) {
        setState(() => _showTitle = true);
      } else if (_scrollController.offset <= 240 && _showTitle) {
        setState(() => _showTitle = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        _buildSliverHeader(context),
        _buildTrackListToolbar(context),
        _buildTrackList(context),
        _buildArtistMoreSection(context),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return SliverAppBar(
      pinned: true,
      expandedHeight: 340,
      backgroundColor: theme.colorScheme.surface,
      elevation: _showTitle ? 2 : 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: AnimatedOpacity(
        opacity: _showTitle ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Text(
          widget.album.name ?? '',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            ArtworkImage(id: widget.album.id, fit: BoxFit.cover, size: 800),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
              child: Container(
                color: theme.colorScheme.scrim.withValues(alpha: .24),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 80, 40, 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 40,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ArtworkImage(id: widget.album.id, size: 600),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.album,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withValues(
                              alpha: .85,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Flexible(
                          child: Text(
                            widget.album.name ?? '-',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1.2,
                              fontSize: 36,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildAlbumMetaRow(widget.album, widget.songs, theme),
                        const SizedBox(height: 6),
                        Text(
                          widget.album.artist ?? '-',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Consumer(builder: (context, ref, _) {
                              return FilledButton.icon(
                                onPressed: widget.songs.isEmpty ? null : () => _playAlbum(ref, widget.songs),
                                icon: const Icon(Icons.play_arrow_rounded, size: 24),
                                label: Text(l10n.play),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  backgroundColor: theme.colorScheme.primary,
                                  foregroundColor: theme.colorScheme.onPrimary,
                                ),
                              );
                            }),
                            const SizedBox(width: 12),
                            _HeaderOutlineButton(
                              icon: Icons.shuffle_rounded,
                              label: l10n.shuffleOn,
                            ),
                            const SizedBox(width: 12),
                            _HeaderOutlineButton(
                              icon: Icons.playlist_play_rounded,
                              label: l10n.playQueue,
                            ),
                            const Spacer(),
                            const Icon(Icons.star_border_rounded, size: 22),
                            const SizedBox(width: 16),
                            const Icon(Icons.favorite_border_rounded, size: 20),
                            const SizedBox(width: 16),
                            const Icon(Icons.more_horiz_rounded, size: 22),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlbumMetaRow(AlbumEntity album, List<SongEntity> songs, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final year = album.year == null ? '' : '${l10n.songMetaYear}: ${album.year}';
    final count = '${songs.length} ${l10n.songCountUnit}';
    final duration = _formatTotalDuration(songs);
    final summary = [year, count, duration].where((it) => it.isNotEmpty).join(' · ');
    return Row(
      children: [
        Icon(Icons.music_note_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
        const SizedBox(width: 4),
        Text(summary, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
      ],
    );
  }

/* Continue original methods from here */

  Widget _buildTrackListToolbar(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(40, 20, 40, 0),
      sliver: SliverToBoxAdapter(
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.search_rounded, size: 18, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 12),
                Text(l10n.searchHint, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
                const Spacer(),
                Text('#', style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                const SizedBox(width: 24),
                Icon(Icons.swap_vert_rounded, size: 18, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 24),
                Icon(Icons.tune_rounded, size: 18, color: theme.colorScheme.onSurfaceVariant),
              ],
            ),
            const SizedBox(height: 12),
            Divider(height: 1, thickness: 0.5, color: theme.colorScheme.outlineVariant),
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(width: 38, child: Icon(Icons.music_note_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5))),
                Text(l10n.song.toUpperCase(), style: TextStyle(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5), fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1)),
                const Spacer(),
                Icon(Icons.access_time_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                const SizedBox(width: 48),
                Icon(Icons.favorite_border_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackList(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final song = widget.songs[index];
            return Consumer(builder: (context, ref, _) {
              return _TrackListTile(index: index + 1, song: song, onPlay: () => _playSong(ref, song));
            });
          },
          childCount: widget.songs.length,
        ),
      ),
    );
  }

  Widget _buildArtistMoreSection(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.recommendedToday, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, fontSize: 24)),
            const SizedBox(height: 16),
            SizedBox(
              height: 240,
              child: AsyncValueBuilder(
                provider: albumsProvider(AlumsType.random), // Simplified for "More by Artist" mock
                builder: (context, data, _) {
                  final albums = data.subsonicResponse?.albumList?.album ?? [];
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: albums.length,
                    itemBuilder: (_, index) {
                      return _MiniAlbumCard(album: albums[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _playSong(WidgetRef ref, SongEntity song) async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) return;
    await player.insertAndPlay(song);
  }

  Future<void> _playAlbum(WidgetRef ref, List<SongEntity> songs) async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) return;
    await player.setPlaylist(songs: songs, initialId: songs.firstOrNull?.id);
    await player.play();
  }

  String _formatTotalDuration(List<SongEntity> songs) {
    final totalSec = songs.fold(0, (sum, song) => sum + (song.duration ?? 0));
    final min = totalSec ~/ 60;
    final sec = totalSec % 60;
    return '$min:$sec';
  }
}

class _HeaderOutlineButton extends StatelessWidget {
  const _HeaderOutlineButton({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.2)),
        foregroundColor: theme.textTheme.bodyLarge?.color,
      ),
    );
  }
}

class _TrackListTile extends StatelessWidget {
  const _TrackListTile({required this.index, required this.song, required this.onPlay});
  final int index;
  final SongEntity song;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPlay,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text('$index', style: TextStyle(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6), fontSize: 13)),
            ),
            Expanded(
              child: Text(
                song.title ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600, 
                  fontSize: 14,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _formatSec(song.duration ?? 0),
              style: TextStyle(color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6), fontSize: 13),
            ),
            const SizedBox(width: 40),
            Icon(Icons.favorite_border_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }

  String _formatSec(int sec) {
    final m = (sec ~/ 60).toString();
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}

class _MiniAlbumCard extends StatelessWidget {
  const _MiniAlbumCard({required this.album});
  final AlbumEntity album;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SizedBox(
        width: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: ArtworkImage(id: album.id, size: 300, width: 150, height: 150, fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            Text(album.name ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            Text(album.artist ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            Text('${album.year ?? ""}', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7))),
          ],
        ),
      ),
    );
  }
}
