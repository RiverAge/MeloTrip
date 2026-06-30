import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_recommendation_shelf.dart';
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

    final forYou = ref.watch(forYouRecommendationsProvider);
    final forYouSongs = forYou.asData?.value ?? const <SongEntity>[];
    final forYouRefreshing = forYou.isLoading && forYouSongs.isNotEmpty;

    final daily = ref.watch(
      dailyRecommendationsProvider(refreshNonce: _dailyRefreshNonce),
    );
    final dailySongs = daily.asData?.value ?? const <SongEntity>[];
    final dailyRefreshing = daily.isLoading && dailySongs.isNotEmpty;

    final favorite = ref.watch(
      favoriteBasedRecommendationsProvider(refreshNonce: _favoriteRefreshNonce),
    );
    final favoriteSongs = favorite.asData?.value ?? const <SongEntity>[];
    final favoriteRefreshing = favorite.isLoading && favoriteSongs.isNotEmpty;

    final playlist = ref.watch(
      playlistBasedRecommendationsProvider(refreshNonce: _playlistRefreshNonce),
    );
    final playlistSongs = playlist.asData?.value ?? const <SongEntity>[];
    final playlistRefreshing =
        playlist.isLoading && playlistSongs.isNotEmpty;

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
            child: DesktopRecommendationShelf(
              title: l10n.guessYouLike,
              icon: Icons.auto_awesome_rounded,
              songs: forYou,
              isRefreshing: forYouRefreshing,
              onRefresh: () {
                if (forYouSongs.isEmpty) {
                  ref.invalidate(forYouRecommendationsProvider);
                  return;
                }
                ref
                    .read(forYouRecommendationRefreshProvider.notifier)
                    .requestRefresh(forYouSongs);
              },
              onPlayAll: () => _playAll(forYouSongs),
              showMoreButton: true,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 28),
          sliver: SliverToBoxAdapter(
            child: DesktopRecommendationShelf(
              title: l10n.recommendedToday,
              icon: Icons.today_rounded,
              songs: daily,
              isRefreshing: dailyRefreshing,
              onRefresh: () => setState(() => _dailyRefreshNonce++),
              onPlayAll: () => _playAll(dailySongs),
              showMoreButton: true,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 28),
          sliver: SliverToBoxAdapter(
            child: DesktopRecommendationShelf(
              title: l10n.favoriteRecommendations,
              icon: Icons.favorite_border_rounded,
              songs: favorite,
              isRefreshing: favoriteRefreshing,
              onRefresh: () => setState(() => _favoriteRefreshNonce++),
              onPlayAll: () => _playAll(favoriteSongs),
              showMoreButton: true,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 28),
          sliver: SliverToBoxAdapter(
            child: DesktopRecommendationShelf(
              title: l10n.playlistRecommendations,
              icon: Icons.queue_music_rounded,
              songs: playlist,
              isRefreshing: playlistRefreshing,
              onRefresh: () => setState(() => _playlistRefreshNonce++),
              onPlayAll: () => _playAll(playlistSongs),
              showMoreButton: true,
            ),
          ),
        ),
        SliverToBoxAdapter(child: SizedBox(height: bottomPadding)),
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
