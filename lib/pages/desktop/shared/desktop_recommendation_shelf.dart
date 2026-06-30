import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_motion_tokens.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_recommendation_song_card.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_shelf_header.dart';
import 'package:melo_trip/widget/shimmer.dart';

/// Self-contained recommendation shelf for desktop pages.
///
/// Renders a [DesktopShelfHeader] followed by a horizontally scrollable list
/// of [DesktopRecommendationSongCard]. The loading state shows a shimmer
/// skeleton matching the real card dimensions (no layout shift); the empty /
/// error state shows a localized "no recommendations" message.
///
/// When [onScrollBack] / [onScrollForward] are wanted, pass `showScrollArrows:
/// true` to expose them on the header (they are bound to the internal
/// [ScrollController] and animate by 80% of the viewport width).
class DesktopRecommendationShelf extends ConsumerStatefulWidget {
  const DesktopRecommendationShelf({
    super.key,
    required this.title,
    required this.songs,
    this.icon,
    this.onRefresh,
    this.refreshTooltip,
    this.isRefreshing = false,
    this.onViewAll,
    this.viewAllTooltip,
    this.onPlayAll,
    this.playAllTooltip,
    this.showScrollArrows = false,
  });

  final String title;
  final AsyncValue<List<SongEntity>> songs;
  final IconData? icon;

  final VoidCallback? onRefresh;
  final String? refreshTooltip;
  final bool isRefreshing;

  final VoidCallback? onViewAll;
  final String? viewAllTooltip;

  final VoidCallback? onPlayAll;
  final String? playAllTooltip;

  /// When true, render scroll-back / scroll-forward arrows on the header bound
  /// to the internal controller. Set false for pages that don't want arrows.
  final bool showScrollArrows;

  @override
  ConsumerState<DesktopRecommendationShelf> createState() =>
      _DesktopRecommendationShelfState();
}

class _DesktopRecommendationShelfState
    extends ConsumerState<DesktopRecommendationShelf> {
  static const _minCardWidth = 136.0;
  static const _maxCardWidth = 188.0;
  static const _minCardGap = 12.0;
  static const _maxCardGap = 20.0;
  static const _metaBlockHeight = 52.0;

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
    if (!_scrollController.hasClients) return;
    final currentOffset = _scrollController.offset;
    final viewWidth = _scrollController.position.viewportDimension;
    _scrollController.animateTo(
      (currentOffset - viewWidth * 0.8).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: DesktopMotionTokens.medium,
      curve: DesktopMotionTokens.standardCurve,
    );
  }

  void _onScrollForward() {
    if (!_scrollController.hasClients) return;
    final currentOffset = _scrollController.offset;
    final viewWidth = _scrollController.position.viewportDimension;
    _scrollController.animateTo(
      (currentOffset + viewWidth * 0.8).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      ),
      duration: DesktopMotionTokens.medium,
      curve: DesktopMotionTokens.standardCurve,
    );
  }

  void _handleRefresh() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    widget.onRefresh?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentSongs = widget.songs.asData?.value ?? const <SongEntity>[];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth * .15).clamp(
          _minCardWidth,
          _maxCardWidth,
        );
        final cardGap = (cardWidth * .1).clamp(_minCardGap, _maxCardGap);
        final cardHeight = cardWidth + _metaBlockHeight;
        final hasRecommendations = widget.songs.maybeWhen(
          data: (songs) => songs.isNotEmpty,
          orElse: () => false,
        );

        return Column(
          crossAxisAlignment: .start,
          children: [
            DesktopShelfHeader(
              title: widget.title,
              icon: widget.icon,
              onRefresh: widget.onRefresh == null ? null : _handleRefresh,
              refreshTooltip: widget.refreshTooltip ?? l10n.refreshRecommendations,
              isRefreshing: widget.isRefreshing,
              onViewAll: widget.onViewAll,
              viewAllTooltip: widget.viewAllTooltip ?? l10n.viewAll,
              onPlayAll: currentSongs.isEmpty ? null : widget.onPlayAll,
              playAllTooltip: widget.playAllTooltip ?? l10n.play,
              onScrollBack: widget.showScrollArrows &&
                      hasRecommendations &&
                      _canScrollBack
                  ? _onScrollBack
                  : null,
              onScrollForward: widget.showScrollArrows &&
                      hasRecommendations &&
                      _canScrollForward
                  ? _onScrollForward
                  : null,
            ),
            SizedBox(
              height: cardHeight,
              child: widget.songs.when(
                loading: () => _DesktopRecommendationShelfSkeleton(
                  cardWidth: cardWidth,
                  cardGap: cardGap,
                ),
                error: (_, _) => _DesktopRecommendationEmptyState(
                  height: cardHeight,
                ),
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
                      itemBuilder: (_, index) => Padding(
                        padding: EdgeInsets.only(right: cardGap),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: cardWidth),
                          child: DesktopRecommendationSongCard(
                            song: songs[index],
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

class _DesktopRecommendationShelfSkeleton extends StatelessWidget {
  const _DesktopRecommendationShelfSkeleton({
    required this.cardWidth,
    required this.cardGap,
  });

  final double cardWidth;
  final double cardGap;

  static const int _cardCount = 5;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: _cardCount,
        separatorBuilder: (_, _) => SizedBox(width: cardGap),
        itemBuilder: (_, _) => SizedBox(
          width: cardWidth,
          child: const _DesktopRecommendationCardSkeleton(),
        ),
      ),
    );
  }
}

class _DesktopRecommendationCardSkeleton extends StatelessWidget {
  const _DesktopRecommendationCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: .start,
      children: [
        AspectRatio(aspectRatio: 1, child: ShimmerBox(borderRadius: 6)),
        SizedBox(height: 12),
        ShimmerBox(height: 14, borderRadius: 4),
        SizedBox(height: 6),
        ShimmerBox(width: 90, height: 12, borderRadius: 4),
      ],
    );
  }
}
