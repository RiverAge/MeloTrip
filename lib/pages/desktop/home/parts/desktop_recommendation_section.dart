part of '../home_page.dart';

class _DesktopRecommendationSection extends ConsumerStatefulWidget {
  const _DesktopRecommendationSection({required this.title});

  static const _minCardWidth = 136.0;
  static const _maxCardWidth = 188.0;
  static const _minCardGap = 12.0;
  static const _maxCardGap = 20.0;
  static const _metaBlockHeight = 52.0;

  final String title;

  @override
  ConsumerState<_DesktopRecommendationSection> createState() =>
      _DesktopRecommendationSectionState();
}

class _DesktopRecommendationSectionState
    extends ConsumerState<_DesktopRecommendationSection> {
  late final ScrollController _scrollController;
  bool _canScrollBack = false;
  bool _canScrollForward = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollUpdate);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollUpdate);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScrollUpdate() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    final canBack = pos.pixels > 1.0;
    final canForward = pos.pixels < pos.maxScrollExtent - 1.0;
    if (canBack != _canScrollBack || canForward != _canScrollForward) {
      setState(() {
        _canScrollBack = canBack;
        _canScrollForward = canForward;
      });
    }
  }

  void _onScrollBack() {
    if (!_canScrollBack) return;
    final double currentOffset = _scrollController.offset;
    final double viewWidth = _scrollController.position.viewportDimension;
    final double scrollDistance = viewWidth * .8;
    _scrollController.animateTo(
      (currentOffset - scrollDistance).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: DesktopMotionTokens.medium,
      curve: DesktopMotionTokens.standardCurve,
    );
  }

  void _onScrollForward() {
    if (!_canScrollForward) return;
    final double currentOffset = _scrollController.offset;
    final double viewWidth = _scrollController.position.viewportDimension;
    final double scrollDistance = viewWidth * .8;
    _scrollController.animateTo(
      (currentOffset + scrollDistance).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: DesktopMotionTokens.medium,
      curve: DesktopMotionTokens.standardCurve,
    );
  }

  void _refreshRecommendations(List<SongEntity> currentSongs) {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    if (_canScrollBack || _canScrollForward) {
      setState(() {
        _canScrollBack = false;
        _canScrollForward = false;
      });
    }
    ref
        .read(forYouRecommendationRefreshProvider.notifier)
        .requestRefresh(currentSongs);
  }

  @override
  Widget build(BuildContext context) {
    final recommendations = ref.watch(forYouRecommendationsProvider);
    final l10n = AppLocalizations.of(context)!;
    final currentSongs = recommendations.asData?.value ?? const <SongEntity>[];
    final isRefreshing = recommendations.isLoading && currentSongs.isNotEmpty;

    return SliverToBoxAdapter(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = (constraints.maxWidth * .15).clamp(
            _DesktopRecommendationSection._minCardWidth,
            _DesktopRecommendationSection._maxCardWidth,
          );
          final cardGap = (cardWidth * .1).clamp(
            _DesktopRecommendationSection._minCardGap,
            _DesktopRecommendationSection._maxCardGap,
          );
          final cardHeight =
              cardWidth + _DesktopRecommendationSection._metaBlockHeight;
          final hasRecommendations = recommendations.maybeWhen(
            data: (songs) => songs.isNotEmpty,
            orElse: () => false,
          );

          return Column(
            crossAxisAlignment: .start,
            children: [
              _SectionHeader(
                title: widget.title,
                onRefresh: currentSongs.isEmpty
                    ? null
                    : () => _refreshRecommendations(currentSongs),
                refreshTooltip: l10n.refreshRecommendations,
                isRefreshing: isRefreshing,
                onScrollBack: hasRecommendations && _canScrollBack
                    ? _onScrollBack
                    : null,
                onScrollForward: hasRecommendations && _canScrollForward
                    ? _onScrollForward
                    : null,
              ),
              SizedBox(
                height: cardHeight,
                child: recommendations.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  error: (_, _) =>
                      _DesktopRecommendationEmptyState(height: cardHeight),
                  data: (songs) {
                    if (songs.isEmpty) {
                      return _DesktopRecommendationEmptyState(
                        height: cardHeight,
                      );
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) _onScrollUpdate();
                    });

                    return ScrollConfiguration(
                      behavior: const _DesktopHorizontalCardScrollBehavior(),
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: songs.length,
                        itemBuilder: (_, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: cardGap),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: cardWidth),
                              child: _DesktopRecommendationSongCard(
                                song: songs[index],
                              ),
                            ),
                          );
                        },
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
}

class _DesktopHorizontalCardScrollBehavior extends MaterialScrollBehavior {
  const _DesktopHorizontalCardScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => {...super.dragDevices, .mouse};
}

class _DesktopRecommendationEmptyState extends StatelessWidget {
  const _DesktopRecommendationEmptyState({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: height,
      child: Align(
        alignment: .topLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            l10n.noRecommendations,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .72),
            ),
          ),
        ),
      ),
    );
  }
}

class _DesktopRecommendationSongCard extends ConsumerStatefulWidget {
  const _DesktopRecommendationSongCard({required this.song});

  final SongEntity song;

  @override
  ConsumerState<_DesktopRecommendationSongCard> createState() =>
      _DesktopRecommendationSongCardState();
}

class _DesktopRecommendationSongCardState
    extends ConsumerState<_DesktopRecommendationSongCard> {
  bool _isHovering = false;

  Future<void> _playSong() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    await player?.insertAndPlay(widget.song);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final artist = widget.song.displayArtist ?? widget.song.artist ?? '-';
    final title = widget.song.title ?? AppLocalizations.of(context)!.noTitle;

    return MouseRegion(
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withValues(alpha: .15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ArtworkImage(
                        id: widget.song.coverArt ?? widget.song.albumId,
                        fit: .cover,
                        size: 400,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _isHovering ? 1 : 0,
                    duration: DesktopMotionTokens.fast,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.scrim.withValues(alpha: .44),
                        borderRadius: BorderRadius.circular(5),
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
                          child: const Icon(Icons.play_arrow_rounded, size: 24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              maxLines: 1,
              overflow: .ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: .w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              artist,
              maxLines: 1,
              overflow: .ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
