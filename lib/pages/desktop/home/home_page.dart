import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/pages/desktop/album/album_detail_page.dart';
import 'package:melo_trip/provider/album/albums.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

class DesktopHomePage extends ConsumerWidget {
  const DesktopHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return CustomScrollView(
      slivers: [
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(25, 20, 25, 15),
          sliver: SliverToBoxAdapter(child: _DesktopHero()),
        ),
        const SliverPadding(
          padding: EdgeInsets.fromLTRB(25, 0, 25, 20),
          sliver: SliverToBoxAdapter(child: _DesktopGenreSection()),
        ),
        _DesktopAlbumSection(title: l10n.rencentPlayed, type: .recent),
        _DesktopAlbumSection(title: l10n.recentAdded, type: .newest),
        _DesktopAlbumSection(title: l10n.randomAlbum, type: .random),
        const SliverToBoxAdapter(child: SizedBox(height: 120)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onViewAll});

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 22,
              letterSpacing: -0.8,
            ),
          ),
          if (onViewAll != null) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.refresh_rounded,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .5),
            ),
          ],
          const Spacer(),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: Text(
                AppLocalizations.of(context)!.viewAll,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(alpha: .8),
                ),
              ),
            ),
          const SizedBox(width: 10),
          _ScrollButton(icon: Icons.arrow_back_ios_new_rounded, onPressed: () {}),
          const SizedBox(width: 8),
          _ScrollButton(icon: Icons.arrow_forward_ios_rounded, onPressed: () {}),
        ],
      ),
    );
  }
}

class _ScrollButton extends StatelessWidget {
  const _ScrollButton({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(
        alpha: isDark ? .28 : .72,
      ),
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 12, color: theme.colorScheme.onSurfaceVariant),
        ),
      ),
    );
  }
}

class _DesktopHero extends ConsumerWidget {
  const _DesktopHero();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final strongOverlay = theme.colorScheme.scrim.withValues(alpha: .5);
    final weakOverlay = theme.colorScheme.scrim.withValues(alpha: .12);
    final textColor = theme.colorScheme.onSurface;
    return AsyncValueBuilder(
      provider: albumsProvider(AlumsType.random),
      loading: (_, _) => const SizedBox(height: 280),
      builder: (context, data, _) {
        final album = data.subsonicResponse?.albumList?.album?.firstOrNull;
        if (album == null) return const SizedBox.shrink();

        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            height: 280,
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => DesktopAlbumDetailPage(albumId: album.id),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Blurred Background
                  Opacity(
                    opacity: 0.6,
                    child: ArtworkImage(id: album.id, fit: BoxFit.cover, size: 800),
                  ),
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                    child: Container(color: Colors.transparent),
                  ),
                  // Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          strongOverlay,
                          weakOverlay,
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                  ),
                  // Content
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
                                color: Colors.black.withValues(alpha: .4),
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
                                '${album.genre ?? ""} • ${album.year ?? ""}',
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
        );
      },
    );
  }
}

class _DesktopGenreSection extends ConsumerWidget {
  const _DesktopGenreSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: l10n.songMetaGenre),
        AsyncValueBuilder(
          provider: albumsProvider(AlumsType.recent),
          builder: (context, data, _) {
            final albums = data.subsonicResponse?.albumList?.album ?? const [];
            final fallback = albums
                .map((it) => it.genre?.trim())
                .whereType<String>()
                .where((it) => it.isNotEmpty)
                .toSet()
                .take(15)
                .toList();

            if (fallback.isEmpty) return const SizedBox.shrink();

            final seedPalette = [
              Colors.green, Colors.yellow, Colors.lightGreen, Colors.blue, Colors.orange,
              Colors.greenAccent, Colors.redAccent, Colors.orangeAccent, Colors.cyan, Colors.teal,
              Colors.blueAccent, Colors.purpleAccent, Colors.indigo, Colors.lightBlue, Colors.amber
            ];

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: fallback.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 3.4,
              ),
              itemBuilder: (_, index) {
                final genre = fallback[index];
                final isDark = theme.brightness == Brightness.dark;
                return Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withValues(alpha: .05) : Colors.black.withValues(alpha: .03),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        color: seedPalette[index % seedPalette.length].withValues(alpha: .9),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Text(
                            genre,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _DesktopAlbumSection extends ConsumerWidget {
  const _DesktopAlbumSection({required this.title, required this.type});

  final String title;
  final AlumsType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 30),
      sliver: SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: title, onViewAll: () {}),
            SizedBox(
              height: 250,
              child: AsyncValueBuilder(
                provider: albumsProvider(type),
                loading: (_, _) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                empty: (_, _) => const SizedBox.shrink(),
                builder: (context, data, _) {
                  final albums = data.subsonicResponse?.albumList?.album ?? [];
                  if (albums.isEmpty) return const SizedBox.shrink();
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: albums.length,
                    itemBuilder: (_, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 18),
                        child: SizedBox(
                          width: 160,
                          child: _DesktopAlbumCard(album: albums[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DesktopAlbumCard extends ConsumerStatefulWidget {
  const _DesktopAlbumCard({required this.album});

  final AlbumEntity album;

  @override
  ConsumerState<_DesktopAlbumCard> createState() => _DesktopAlbumCardState();
}

class _DesktopAlbumCardState extends ConsumerState<_DesktopAlbumCard> with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
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
    
    // Using albumDetailProvider to fetch songs
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Normal Album Cover
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: ArtworkImage(
                        id: widget.album.id,
                        fit: BoxFit.cover,
                        size: 400,
                      ),
                    ),
                  ),
                  
                  // Hover Overlay
                  AnimatedOpacity(
                    opacity: _isHovering ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: .5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  onPressed: () {}, // Favorite action
                                  icon: Icon(
                                    isStarred ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    color: isStarred ? Colors.redAccent : Colors.white,
                                    size: 20,
                                  ),
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                _RatingStars(rating: rating),
                              ],
                            ),
                            const Spacer(),
                            // Central Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _ActionCircle(
                                  onPressed: () {}, // Shuffle/Alternative Button
                                  icon: Icons.shuffle_rounded,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                _ActionCircle(
                                  onPressed: _playAlbum,
                                  icon: Icons.play_arrow_rounded,
                                  size: 42,
                                  isMain: true,
                                ),
                                const SizedBox(width: 12),
                                _ActionCircle(
                                  onPressed: () {}, // Next/Alternative Button
                                  icon: Icons.skip_next_rounded,
                                  size: 28,
                                ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.expand_more_rounded, color: Colors.white.withValues(alpha: .8), size: 20),
                                Icon(Icons.more_horiz_rounded, color: Colors.white.withValues(alpha: .8), size: 20),
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
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              widget.album.artist ?? '-',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < (rating / 2).ceil() ? Icons.star_rounded : Icons.star_border_rounded,
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
    this.size = 32,
    this.isMain = false,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final double size;
  final bool isMain;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: isMain ? 1.0 : .2),
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: size * 0.6,
            color: isMain ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}
