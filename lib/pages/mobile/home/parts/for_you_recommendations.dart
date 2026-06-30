part of '../home_page.dart';

class _ForYouRecommendations extends ConsumerStatefulWidget {
  const _ForYouRecommendations();

  @override
  ConsumerState<_ForYouRecommendations> createState() =>
      _ForYouRecommendationsState();
}

class _ForYouRecommendationsState
    extends ConsumerState<_ForYouRecommendations> {
  late final ScrollController _scrollController;
  bool _isRefreshing = false;

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

  Future<void> _refreshRecommendations(List<SongEntity> currentSongs) async {
    if (_isRefreshing) {
      return;
    }
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    setState(() => _isRefreshing = true);
    ref
        .read(forYouRecommendationRefreshProvider.notifier)
        .requestRefresh(currentSongs);

    try {
      await ref.read(forYouRecommendationsProvider.future);
    } finally {
      if (mounted) {
        setState(() => _isRefreshing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return AsyncValueBuilder(
      provider: forYouRecommendationsProvider,
      loading: (_, _) => const _ForYouRecommendationsSkeleton(),
      builder: (context, songs, ref) {
        // Show placeholder when no recommendations
        if (songs.isEmpty) {
          return const _ForYouPlaceholder();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      l10n.guessYouLike,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: const TextStyle(fontSize: 18, fontWeight: .w900),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.refreshRecommendations,
                    onPressed: _isRefreshing
                        ? null
                        : () => _refreshRecommendations(songs),
                    icon: _isRefreshing
                        ? SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.72),
                            ),
                          )
                        : Icon(Icons.refresh_rounded, size: 20),
                    style: _quietRefreshButtonStyle(theme),
                  ),
                  // Play all button
                  TextButton.icon(
                    onPressed: () async {
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
                    icon: Icon(
                      Icons.play_arrow_rounded,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                    label: Text(
                      l10n.play,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 180,
                child: ScrollConfiguration(
                  behavior: const _HorizontalCardScrollBehavior(),
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: songs.length,
                    itemBuilder: (context, index) {
                      final song = songs[index];
                      return _SongCard(song: song);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

ButtonStyle _quietRefreshButtonStyle(ThemeData theme) {
  return ButtonStyle(
    foregroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.disabled)) {
        return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.38);
      }
      return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.68);
    }),
    backgroundColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.pressed)) {
        return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.12);
      }
      if (states.contains(WidgetState.hovered) ||
          states.contains(WidgetState.focused)) {
        return theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.08);
      }
      return null;
    }),
  );
}

class _HorizontalCardScrollBehavior extends MaterialScrollBehavior {
  const _HorizontalCardScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {...super.dragDevices, .mouse};
}

class _SongCard extends StatelessWidget {
  const _SongCard({required this.song});

  final SongEntity song;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final artist = song.displayArtist ?? song.artist ?? '';

    return Consumer(
      builder: (context, ref, _) {
        return Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SizedBox(
            width: 130,
            child: InkWell(
              onTap: () async {
                final player = await ref.read(appPlayerHandlerProvider.future);
                if (player != null) {
                  await player.insertAndPlay(song);
                }
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.colorScheme.shadow.withValues(
                                    alpha: 0.05,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: ArtworkImage(
                                fit: .cover,
                                id: song.coverArt ?? song.albumId,
                                size: 300,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: _MoreButton(songId: song.id),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      song.title ?? '',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: .bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      artist,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: .7,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Compact "more" button overlaid on a recommendation card cover.
///
/// Opens the standard song control sheet (favorite / play next / add to queue
/// / add to playlist / similar radio), so a single entry point surfaces the
/// full set of song actions without adding multiple buttons to the card.
class _MoreButton extends StatelessWidget {
  const _MoreButton({required this.songId});

  final String? songId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: AppLocalizations.of(context)!.moreActions,
      child: Material(
        color: theme.colorScheme.scrim.withValues(alpha: 0.45),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: songId == null || songId!.isEmpty
              ? null
              : () => showSongControlSheet(context, songId),
          child: SizedBox(
            width: 26,
            height: 26,
            child: Icon(
              Icons.more_horiz_rounded,
              size: 16,
              color: theme.colorScheme.onPrimary.withValues(alpha: 0.95),
            ),
          ),
        ),
      ),
    );
  }
}
