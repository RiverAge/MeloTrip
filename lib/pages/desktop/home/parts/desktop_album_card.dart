import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/pages/desktop/album/album_detail_page.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_motion_tokens.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/widget/artwork_image.dart';

class DesktopAlbumCard extends ConsumerStatefulWidget {
  const DesktopAlbumCard({super.key, required this.album});

  final AlbumEntity album;

  @override
  ConsumerState<DesktopAlbumCard> createState() => _DesktopAlbumCardState();
}

class _DesktopAlbumCardState extends ConsumerState<DesktopAlbumCard>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: DesktopMotionTokens.medium,
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: DesktopMotionTokens.standardCurve,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    setState(() => _isHovering = hovering);
    if (hovering) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  Future<void> _playAlbum() async {
    final albumId = widget.album.id;
    if (albumId == null) return;

    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) return;

    final data = await ref.read(albumDetailProvider(albumId).future);
    final songs = data?.subsonicResponse?.album?.song ?? [];
    if (songs.isNotEmpty) {
      await player.setPlaylist(songs: songs, initialId: songs.firstOrNull?.id);
      await player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final overlayBackground = Colors.black.withValues(
      alpha: isDark ? .52 : .46,
    );
    final overlayForeground = Colors.white.withValues(alpha: .94);
    final overlayForegroundMuted = Colors.white.withValues(alpha: .82);
    final mainButtonBackground = Colors.white.withValues(
      alpha: isDark ? .98 : .94,
    );
    final mainButtonForeground = Colors.black.withValues(alpha: .9);
    final secondaryButtonBackground = Colors.white.withValues(alpha: .24);
    final isStarred = widget.album.starred != null;
    final rating = widget.album.userRating ?? 0;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DesktopAlbumDetailPage(albumId: widget.album.id),
            ),
          );
        },
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
                        id: widget.album.id,
                        fit: .cover,
                        size: 400,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: _isHovering ? 1.0 : 0.0,
                    duration: DesktopMotionTokens.medium,
                    child: Container(
                      decoration: BoxDecoration(
                        color: overlayBackground,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: .spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    isStarred
                                        ? Icons.favorite_rounded
                                        : Icons.favorite_border_rounded,
                                    color: isStarred
                                        ? Colors.redAccent
                                        : overlayForeground,
                                    size: 20,
                                  ),
                                  visualDensity: .compact,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                _RatingStars(rating: rating),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: .center,
                              children: [
                                _ActionCircle(
                                  onPressed: () {},
                                  icon: Icons.shuffle_rounded,
                                  size: 28,
                                  background: secondaryButtonBackground,
                                  foreground: overlayForeground,
                                ),
                                const SizedBox(width: 12),
                                _ActionCircle(
                                  onPressed: _playAlbum,
                                  icon: Icons.play_arrow_rounded,
                                  size: 42,
                                  background: mainButtonBackground,
                                  foreground: mainButtonForeground,
                                ),
                                const SizedBox(width: 12),
                                _ActionCircle(
                                  onPressed: () {},
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
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.album.name ?? '-',
              maxLines: 1,
              overflow: .ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: .w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.album.artist ?? '-',
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

class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final int rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: .min,
      children: List.generate(5, (index) {
        return Icon(
          index < (rating / 2).ceil()
              ? Icons.star_rounded
              : Icons.star_border_rounded,
          color: Colors.white.withValues(alpha: .9),
          size: 14,
        );
      }),
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
