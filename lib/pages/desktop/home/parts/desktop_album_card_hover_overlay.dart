part of 'desktop_album_card.dart';

class _AlbumHoverOverlay extends StatelessWidget {
  const _AlbumHoverOverlay({
    required this.theme,
    required this.scaleAnimation,
    required this.overlayBackground,
    required this.overlayForeground,
    required this.overlayForegroundMuted,
    required this.mainButtonBackground,
    required this.mainButtonForeground,
    required this.secondaryButtonBackground,
    required this.isStarred,
    required this.rating,
    required this.onToggleFavorite,
    required this.onSetRating,
    required this.onPlayAlbumShuffled,
    required this.onPlayAlbum,
    required this.onAddAlbumToQueue,
  });

  final ThemeData theme;
  final Animation<double> scaleAnimation;
  final Color overlayBackground;
  final Color overlayForeground;
  final Color overlayForegroundMuted;
  final Color mainButtonBackground;
  final Color mainButtonForeground;
  final Color secondaryButtonBackground;
  final bool isStarred;
  final int rating;
  final VoidCallback onToggleFavorite;
  final ValueChanged<int> onSetRating;
  final VoidCallback onPlayAlbumShuffled;
  final VoidCallback onPlayAlbum;
  final VoidCallback onAddAlbumToQueue;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: overlayBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  IconButton(
                    onPressed: onToggleFavorite,
                    icon: Icon(
                      isStarred
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isStarred
                          ? theme.colorScheme.error
                          : overlayForeground,
                      size: 20,
                    ),
                    visualDensity: .compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {},
                    child: Rating(
                      rating: rating,
                      color: overlayForeground,
                      onRating: onSetRating,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: .center,
                children: [
                  _ActionCircle(
                    onPressed: onPlayAlbumShuffled,
                    icon: Icons.shuffle_rounded,
                    size: 28,
                    background: secondaryButtonBackground,
                    foreground: overlayForeground,
                  ),
                  const SizedBox(width: 12),
                  _ActionCircle(
                    onPressed: onPlayAlbum,
                    icon: Icons.play_arrow_rounded,
                    size: 42,
                    background: mainButtonBackground,
                    foreground: mainButtonForeground,
                  ),
                  const SizedBox(width: 12),
                  _ActionCircle(
                    onPressed: onAddAlbumToQueue,
                    icon: Icons.skip_next_rounded,
                    size: 28,
                    background: secondaryButtonBackground,
                    foreground: overlayForeground,
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Icon(
                    Icons.expand_more_rounded,
                    color: overlayForegroundMuted,
                    size: 20,
                  ),
                  Icon(
                    Icons.more_horiz_rounded,
                    color: overlayForegroundMuted,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionCircle extends StatelessWidget {
  const _ActionCircle({
    required this.onPressed,
    required this.icon,
    required this.background,
    required this.foreground,
    this.size = 32,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Color background;
  final Color foreground;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(icon, size: size * 0.6, color: foreground),
          ),
        ),
      ),
    );
  }
}
