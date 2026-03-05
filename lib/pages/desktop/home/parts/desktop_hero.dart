part of '../home_page.dart';

class _DesktopHero extends ConsumerStatefulWidget {
  const _DesktopHero();

  @override
  ConsumerState<_DesktopHero> createState() => _DesktopHeroState();
}

class _DesktopHeroState extends ConsumerState<_DesktopHero> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    return AsyncValueBuilder(
      provider: albumsProvider(AlumsType.random),
      loading: (_, _) => const SizedBox(height: 280),
      builder: (context, data, _) {
        final album = data.subsonicResponse?.albumList?.album?.firstOrNull;
        if (album == null) return const SizedBox.shrink();

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => DesktopAlbumDetailPage(albumId: album.id),
                ),
              );
            },
            child: Container(
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PlaybackArtworkBackground(artworkId: album.id, size: 1400),
                    const PlaybackBlurOverlay(surfaceAlpha: .34),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 32,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 180,
                            height: 180,
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
                              child: ArtworkImage(id: album.id, size: 500),
                            ),
                          ),
                          const SizedBox(width: 40),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: .center,
                              crossAxisAlignment: .start,
                              children: [
                                Text(
                                  album.name ?? '-',
                                  maxLines: 2,
                                  overflow: .ellipsis,
                                  style: theme.textTheme.displaySmall?.copyWith(
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
                                        color: textColor.withValues(alpha: .9),
                                        fontWeight: .w600,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${album.genre ?? ""} - ${album.year ?? ""}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: textColor.withValues(alpha: .7),
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
        );
      },
    );
  }
}
