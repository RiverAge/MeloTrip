import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_motion_tokens.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_song_more_button.dart';
import 'package:melo_trip/pages/desktop/similar_songs/similar_songs_page.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/recommendation/for_you_recommendations.dart';
import 'package:melo_trip/provider/recommendation/recommendation_sections.dart';
import 'package:melo_trip/provider/sonic_similarity/sonic_similarity.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';

class DesktopRecommendationPage extends ConsumerStatefulWidget {
  const DesktopRecommendationPage({super.key});

  @override
  ConsumerState<DesktopRecommendationPage> createState() =>
      _DesktopRecommendationPageState();
}

class _DesktopRecommendationPageState
    extends ConsumerState<DesktopRecommendationPage> {
  int _dailyRefreshNonce = 0;
  int _favoriteRefreshNonce = 0;
  int _playlistRefreshNonce = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.paddingOf(context).bottom + 96;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(25, 22, 25, 22),
          sliver: SliverToBoxAdapter(
            child: _RecommendationPageHeader(title: l10n.recommendations),
          ),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(25, 0, 25, 28),
          sliver: SliverToBoxAdapter(child: _CurrentSongRecommendationPanel()),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 28),
          sliver: SliverToBoxAdapter(
            child: _RecommendationShelf(
              title: l10n.guessYouLike,
              icon: Icons.auto_awesome_rounded,
              songs: ref.watch(forYouRecommendationsProvider),
              onRefresh: (songs) {
                if (songs.isEmpty) {
                  ref.invalidate(forYouRecommendationsProvider);
                  return;
                }
                ref
                    .read(forYouRecommendationRefreshProvider.notifier)
                    .requestRefresh(songs);
              },
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 28),
          sliver: SliverToBoxAdapter(
            child: _RecommendationShelf(
              title: l10n.recommendedToday,
              icon: Icons.today_rounded,
              songs: ref.watch(
                dailyRecommendationsProvider(refreshNonce: _dailyRefreshNonce),
              ),
              onRefresh: (_) => setState(() => _dailyRefreshNonce++),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 28),
          sliver: SliverToBoxAdapter(
            child: _RecommendationShelf(
              title: l10n.favoriteRecommendations,
              icon: Icons.favorite_border_rounded,
              songs: ref.watch(
                favoriteBasedRecommendationsProvider(
                  refreshNonce: _favoriteRefreshNonce,
                ),
              ),
              onRefresh: (_) => setState(() => _favoriteRefreshNonce++),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 28),
          sliver: SliverToBoxAdapter(
            child: _RecommendationShelf(
              title: l10n.playlistRecommendations,
              icon: Icons.queue_music_rounded,
              songs: ref.watch(
                playlistBasedRecommendationsProvider(
                  refreshNonce: _playlistRefreshNonce,
                ),
              ),
              onRefresh: (_) => setState(() => _playlistRefreshNonce++),
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: bottomPadding)),
      ],
    );
  }
}

class _RecommendationPageHeader extends StatelessWidget {
  const _RecommendationPageHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.auto_awesome_rounded,
          size: 24,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: .ellipsis,
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: .w900),
          ),
        ),
      ],
    );
  }
}

class _CurrentSongRecommendationPanel extends ConsumerWidget {
  const _CurrentSongRecommendationPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PlayQueueBuilder(
      builder: (context, playQueue, _) {
        final current =
            playQueue.index < 0 || playQueue.index >= playQueue.songs.length
            ? null
            : playQueue.songs[playQueue.index];
        if (current == null) {
          return const SizedBox.shrink();
        }

        return _CurrentSongActions(song: current);
      },
    );
  }
}

class _CurrentSongActions extends ConsumerWidget {
  const _CurrentSongActions({required this.song});

  final SongEntity song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final title = song.title ?? l10n.noTitle;
    final artist = song.displayArtist ?? song.artist ?? '';

    return LayoutBuilder(
      builder: (context, constraints) {
        final useCompactLayout = constraints.maxWidth < 560;
        return DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: .42,
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: .28),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: useCompactLayout
                ? Column(
                    crossAxisAlignment: .start,
                    children: [
                      _CurrentSongSummary(
                        song: song,
                        title: title,
                        artist: artist,
                      ),
                      const SizedBox(height: 12),
                      _CurrentSongActionButtons(song: song),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _CurrentSongSummary(
                          song: song,
                          title: title,
                          artist: artist,
                        ),
                      ),
                      const SizedBox(width: 12),
                      _CurrentSongActionButtons(song: song),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _CurrentSongSummary extends StatelessWidget {
  const _CurrentSongSummary({
    required this.song,
    required this.title,
    required this.artist,
  });

  final SongEntity song;
  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: ArtworkImage(
            id: song.coverArt ?? song.albumId ?? song.id,
            width: 56,
            height: 56,
            size: 220,
            fit: .cover,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                l10n.currentSongRecommendations,
                maxLines: 1,
                overflow: .ellipsis,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                maxLines: 1,
                overflow: .ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: .w800),
              ),
              if (artist.trim().isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  artist,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: .78,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _CurrentSongActionButtons extends ConsumerWidget {
  const _CurrentSongActionButtons({required this.song});

  final SongEntity song;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: () => _openSimilarSongs(context, song),
          icon: const Icon(Icons.hub_rounded, size: 18),
          label: Text(l10n.similarSongs),
        ),
        FilledButton.icon(
          onPressed: () => _startSimilarRadio(context, ref, song),
          icon: const Icon(Icons.radio_rounded, size: 18),
          label: Text(l10n.similarRadio),
        ),
      ],
    );
  }

  void _openSimilarSongs(BuildContext context, SongEntity song) {
    final songId = song.id?.trim();
    if (songId == null || songId.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            DesktopSimilarSongsPage(songId: songId, songTitle: song.title),
      ),
    );
  }

  Future<void> _startSimilarRadio(
    BuildContext context,
    WidgetRef ref,
    SongEntity song,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.maybeOf(context);
    final player = await ref.read(appPlayerHandlerProvider.future);
    await ref.read(radioQueueProvider.notifier).startRadio(song);
    final radioQueue = ref.read(radioQueueProvider);
    if (!context.mounted) return;
    if (radioQueue.isEmpty) {
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.noSongsFoundForRadio)),
      );
      return;
    }
    await player?.setPlaylist(
      songs: radioQueue,
      initialId: radioQueue.firstOrNull?.id,
    );
    await player?.play();
  }
}

class _RecommendationShelf extends ConsumerStatefulWidget {
  const _RecommendationShelf({
    required this.title,
    required this.icon,
    required this.songs,
    this.onRefresh,
  });

  final String title;
  final IconData icon;
  final AsyncValue<List<SongEntity>> songs;
  final ValueChanged<List<SongEntity>>? onRefresh;

  @override
  ConsumerState<_RecommendationShelf> createState() =>
      _RecommendationShelfState();
}

class _RecommendationShelfState extends ConsumerState<_RecommendationShelf> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final songs = widget.songs.asData?.value ?? const <SongEntity>[];

    return Column(
      crossAxisAlignment: .start,
      children: [
        _RecommendationShelfHeader(
          title: widget.title,
          icon: widget.icon,
          onPlayAll: songs.isEmpty ? null : () => _playAll(songs),
          onRefresh: widget.onRefresh == null
              ? null
              : () => widget.onRefresh!(songs),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 236,
          child: widget.songs.when(
            loading: () =>
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, _) =>
                _RecommendationEmptyState(message: l10n.noRecommendations),
            data: (items) {
              if (items.isEmpty) {
                return _RecommendationEmptyState(
                  message: l10n.noRecommendations,
                );
              }
              return ScrollConfiguration(
                behavior: const _DesktopRecommendationScrollBehavior(),
                child: ListView.separated(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 14),
                  itemBuilder: (_, index) {
                    return _RecommendationSongCard(song: items[index]);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _playAll(List<SongEntity> songs) async {
    if (songs.isEmpty) return;
    final player = await ref.read(appPlayerHandlerProvider.future);
    await player?.setPlaylist(songs: songs, initialId: songs.firstOrNull?.id);
    await player?.play();
  }
}

class _RecommendationShelfHeader extends StatelessWidget {
  const _RecommendationShelfHeader({
    required this.title,
    required this.icon,
    this.onPlayAll,
    this.onRefresh,
  });

  final String title;
  final IconData icon;
  final VoidCallback? onPlayAll;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: .ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: .w800),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onPlayAll,
          tooltip: l10n.play,
          icon: const Icon(Icons.play_arrow_rounded),
          iconSize: 18,
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: onPlayAll == null ? .22 : .5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: onRefresh,
          tooltip: l10n.refreshRecommendations,
          icon: const Icon(Icons.refresh_rounded),
          iconSize: 18,
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: onRefresh == null ? .22 : .5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }
}

class _DesktopRecommendationScrollBehavior extends MaterialScrollBehavior {
  const _DesktopRecommendationScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {...super.dragDevices, .mouse};
}

class _RecommendationEmptyState extends StatelessWidget {
  const _RecommendationEmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: .topLeft,
      child: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .72),
        ),
      ),
    );
  }
}

class _RecommendationSongCard extends ConsumerStatefulWidget {
  const _RecommendationSongCard({required this.song});

  final SongEntity song;

  @override
  ConsumerState<_RecommendationSongCard> createState() =>
      _RecommendationSongCardState();
}

class _RecommendationSongCardState
    extends ConsumerState<_RecommendationSongCard> {
  bool _isHovering = false;

  Future<void> _playSong() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    await player?.insertAndPlay(widget.song);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final title = widget.song.title ?? l10n.noTitle;
    final artist = widget.song.displayArtist ?? widget.song.artist ?? '';

    return SizedBox(
      width: 156,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: _playSong,
          borderRadius: BorderRadius.circular(6),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withValues(alpha: .14),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: ArtworkImage(
                          id:
                              widget.song.coverArt ??
                              widget.song.albumId ??
                              widget.song.id,
                          fit: .cover,
                          size: 360,
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _isHovering ? 1 : 0,
                      duration: DesktopMotionTokens.fast,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.scrim.withValues(alpha: .42),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: FilledButton(
                            onPressed: _playSong,
                            style: FilledButton.styleFrom(
                              backgroundColor: theme.colorScheme.surface
                                  .withValues(alpha: .96),
                              foregroundColor: theme.colorScheme.onSurface,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(10),
                              minimumSize: const Size(42, 42),
                            ),
                            child: const Icon(
                              Icons.play_arrow_rounded,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: .w700,
                      ),
                    ),
                  ),
                  DesktopSongMoreButton(song: widget.song, iconSize: 16),
                ],
              ),
              if (artist.trim().isNotEmpty)
                Text(
                  artist,
                  maxLines: 1,
                  overflow: .ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: .68,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
