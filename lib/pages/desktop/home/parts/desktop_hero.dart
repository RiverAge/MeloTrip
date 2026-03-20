part of '../home_page.dart';

class _DesktopHero extends ConsumerStatefulWidget {
  const _DesktopHero();

  @override
  ConsumerState<_DesktopHero> createState() => _DesktopHeroState();
}

class _DesktopHeroState extends ConsumerState<_DesktopHero> {
  double _heroHeight(BuildContext context, BoxConstraints constraints) {
    final availableHeight = constraints.maxHeight.isFinite
        ? constraints.maxHeight
        : MediaQuery.sizeOf(context).height;
    return (availableHeight * 0.32).clamp(220.0, 340.0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    return AsyncValueBuilder(
      provider: albumListProvider(
        AlbumListQuery(type: AlbumListType.random.name),
      ),
      loading: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          final heroHeight = _heroHeight(context, constraints);
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: heroHeight,
              maxHeight: heroHeight,
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      ),
      builder: (context, data, _) {
        if (data.isErr) return const SizedBox.shrink();
        final album = data.data?.firstOrNull;
        if (album == null) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: (context, constraints) {
            final heroHeight = _heroHeight(context, constraints);
            final double coverSize = (heroHeight * 0.64).clamp(140.0, 200.0);
            final double coverGap = (heroHeight * 0.14).clamp(20.0, 40.0);
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: heroHeight,
                maxHeight: heroHeight,
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            DesktopAlbumDetailPage(albumId: album.id),
                      ),
                    );
                  },
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          PlaybackArtworkBackground(
                            artworkId: album.id,
                            size: 1400,
                          ),
                          const PlaybackBlurOverlay(surfaceAlpha: .34),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 32,
                            ),
                            child: Row(
                              children: [
                                SizedBox.square(
                                  dimension: coverSize,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: theme.shadowColor.withValues(
                                            alpha: .4,
                                          ),
                                          blurRadius: 30,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: ArtworkImage(
                                        id: album.id,
                                        size: 500,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: coverGap),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: .center,
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text(
                                        album.name ?? '-',
                                        maxLines: 2,
                                        overflow: .ellipsis,
                                        style: theme.textTheme.displaySmall
                                            ?.copyWith(
                                              fontWeight: .w900,
                                              color: textColor,
                                              letterSpacing: -1.2,
                                            ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        album.artist ?? '-',
                                        style: theme.textTheme.headlineSmall
                                            ?.copyWith(
                                              color: textColor.withValues(
                                                alpha: .9,
                                              ),
                                              fontWeight: .w600,
                                            ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '${album.genre ?? ""} - ${album.year ?? ""}',
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                              color: textColor.withValues(
                                                alpha: .7,
                                              ),
                                            ),
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
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
