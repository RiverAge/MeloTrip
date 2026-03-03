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
    final colorScheme = theme.colorScheme;
    final strongOverlay = colorScheme.scrim.withValues(alpha: .5);
    final weakOverlay = colorScheme.scrim.withValues(alpha: .12);
    final textColor = colorScheme.onSurface;
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(
                      opacity: 0.6,
                      child: ArtworkImage(id: album.id, fit: BoxFit.cover, size: 800),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                      child: Container(color: colorScheme.surface.withValues(alpha: 0)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [strongOverlay, weakOverlay],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
                      child: Row(
                        children: [
                          Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: theme.shadowColor.withValues(alpha: .4),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  album.name ?? '-',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: textColor,
                                    letterSpacing: -1.2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  album.artist ?? '-',
                                  style: theme.textTheme.headlineSmall?.copyWith(
                                    color: textColor.withValues(alpha: .9),
                                    fontWeight: FontWeight.w600,
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
