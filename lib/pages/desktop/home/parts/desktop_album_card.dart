import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/helper/app_failure_message.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/album/album.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/album/album_detail_page.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_motion_tokens.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/provider/album/album_detail.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/provider/favorite/favorite.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/rating.dart';

part 'desktop_album_card_hover_overlay.dart';

class DesktopAlbumCard extends ConsumerStatefulWidget {
  const DesktopAlbumCard({
    super.key,
    required this.album,
    this.showReleaseDate = false,
  });

  final AlbumEntity album;
  final bool showReleaseDate;

  @override
  ConsumerState<DesktopAlbumCard> createState() => _DesktopAlbumCardState();
}

class _DesktopAlbumCardState extends ConsumerState<DesktopAlbumCard>
    with SingleTickerProviderStateMixin {
  bool _isHovering = false;
  int? _optimisticRating;
  bool? _optimisticStarred;
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

  @override
  void didUpdateWidget(covariant DesktopAlbumCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.album.userRating != widget.album.userRating) {
      _optimisticRating = null;
    }
    if (oldWidget.album.starred != widget.album.starred) {
      _optimisticStarred = null;
    }
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
    final songs = data?.data?.subsonicResponse?.album?.song ?? <SongEntity>[];
    if (songs.isNotEmpty) {
      await player.setPlaylist(songs: songs, initialId: songs.firstOrNull?.id);
      await player.play();
    }
  }

  Future<void> _toggleFavorite() async {
    final albumId = widget.album.id;
    if (albumId == null) return;
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    final currentlyStarred = _optimisticStarred ?? widget.album.starred != null;
    setState(() {
      _optimisticStarred = !currentlyStarred;
    });

    final result = await ref
        .read(albumDetailProvider(albumId).notifier)
        .toggleFavorite(currentlyStarred: currentlyStarred);

    if (!mounted) return;
    if (result == null || result.isErr) {
      if (result?.error != null) {
        final message = resolveAppFailureMessage(l10n, failure: result!.error);
        messenger.showSnackBar(SnackBar(content: Text(message)));
      }
      setState(() {
        _optimisticStarred = currentlyStarred;
      });
      return;
    }

    ref.invalidate(favoriteProvider);
    ref.invalidate(albumDetailProvider(albumId));
  }

  Future<void> _playAlbumShuffled() async {
    final albumId = widget.album.id;
    if (albumId == null) return;

    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) return;

    final data = await ref.read(albumDetailProvider(albumId).future);
    final songs = data?.data?.subsonicResponse?.album?.song ?? <SongEntity>[];
    if (songs.isEmpty) return;

    final shuffledSongs = List.of(songs)..shuffle(Random());
    await player.setPlaylist(
      songs: shuffledSongs,
      initialId: shuffledSongs.firstOrNull?.id,
    );
    await player.play();
  }

  Future<void> _addAlbumToQueue() async {
    final albumId = widget.album.id;
    if (albumId == null) return;

    final player = await ref.read(appPlayerHandlerProvider.future);
    if (player == null) return;

    final data = await ref.read(albumDetailProvider(albumId).future);
    final songs = data?.data?.subsonicResponse?.album?.song ?? <SongEntity>[];
    for (final song in songs) {
      await player.insertToEnd(song);
    }
  }

  Future<void> _setAlbumRating(int value) async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    setState(() {
      _optimisticRating = value;
    });
    final res = await ref
        .read(albumDetailProvider(widget.album.id).notifier)
        .setRating(value);
    if (!mounted) return;
    if (res == null || res.isErr) {
      if (res?.error != null) {
        final message = resolveAppFailureMessage(l10n, failure: res!.error);
        messenger.showSnackBar(SnackBar(content: Text(message)));
      }
      setState(() {
        _optimisticRating = widget.album.userRating;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final overlayBackground = theme.colorScheme.scrim.withValues(alpha: .48);
    final overlayForeground = theme.colorScheme.onPrimary.withValues(
      alpha: .94,
    );
    final overlayForegroundMuted = theme.colorScheme.onPrimary.withValues(
      alpha: .82,
    );
    final mainButtonBackground = theme.colorScheme.surface.withValues(
      alpha: .96,
    );
    final mainButtonForeground = theme.colorScheme.onSurface.withValues(
      alpha: .9,
    );
    final secondaryButtonBackground = theme.colorScheme.surface.withValues(
      alpha: .24,
    );
    final isStarred = _optimisticStarred ?? widget.album.starred != null;
    final rating = _optimisticRating ?? widget.album.userRating ?? 0;
    final releaseYear = _buildReleaseYear();

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
                    child: _AlbumHoverOverlay(
                      theme: theme,
                      scaleAnimation: _scaleAnimation,
                      overlayBackground: overlayBackground,
                      overlayForeground: overlayForeground,
                      overlayForegroundMuted: overlayForegroundMuted,
                      mainButtonBackground: mainButtonBackground,
                      mainButtonForeground: mainButtonForeground,
                      secondaryButtonBackground: secondaryButtonBackground,
                      isStarred: isStarred,
                      rating: rating,
                      onToggleFavorite: _toggleFavorite,
                      onSetRating: _setAlbumRating,
                      onPlayAlbumShuffled: _playAlbumShuffled,
                      onPlayAlbum: _playAlbum,
                      onAddAlbumToQueue: _addAlbumToQueue,
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
            if (widget.showReleaseDate)
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.album.artist ?? '-',
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: .6,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ),
                  if (releaseYear != null && releaseYear.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Text(
                      releaseYear,
                      maxLines: 1,
                      overflow: .ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant.withValues(
                          alpha: .6,
                        ),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              )
            else
              Text(
                widget.album.artist ?? '-',
                maxLines: 1,
                overflow: .ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant.withValues(
                    alpha: .6,
                  ),
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String? _buildReleaseYear() {
    final releaseDate = widget.album.releaseDate;
    return switch (releaseDate) {
      ReleaseDate(:final year?) => '$year',
      _ => widget.album.year?.toString(),
    };
  }
}
