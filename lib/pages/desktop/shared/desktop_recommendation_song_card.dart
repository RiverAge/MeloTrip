import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/pages/desktop/shared/desktop_motion_tokens.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/widget/artwork_image.dart';

/// Shared recommendation song card for desktop shelves.
///
/// [borderRadius] controls the cover rounding (defaults to 6 to match album
/// cards).
class DesktopRecommendationSongCard extends ConsumerStatefulWidget {
  const DesktopRecommendationSongCard({
    super.key,
    required this.song,
    this.borderRadius = 6,
  });

  final SongEntity song;
  final double borderRadius;

  @override
  ConsumerState<DesktopRecommendationSongCard> createState() =>
      _DesktopRecommendationSongCardState();
}

class _DesktopRecommendationSongCardState
    extends ConsumerState<DesktopRecommendationSongCard> {
  bool _isHovering = false;

  Future<void> _playSong() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    await player?.insertAndPlay(widget.song);
  }

  Future<void> _addToNext() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    await player?.insertToNext(widget.song);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final artist = widget.song.displayArtist ?? widget.song.artist ?? '-';
    final title = widget.song.title ?? l10n.noTitle;
    final radius = widget.borderRadius;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: _playSong,
        borderRadius: BorderRadius.circular(radius),
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
                      borderRadius: BorderRadius.circular(radius),
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withValues(alpha: .15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
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
                        borderRadius: BorderRadius.circular(radius),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _HoverCircleButton(
                              icon: Icons.not_started_outlined,
                              size: 36,
                              iconSize: 20,
                              tooltip: l10n.playNext,
                              onPressed: _addToNext,
                            ),
                            const SizedBox(width: 8),
                            FilledButton(
                              onPressed: _playSong,
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.surface
                                    .withValues(alpha: .96),
                                foregroundColor: theme.colorScheme.onSurface,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(10),
                                minimumSize: const Size(42, 42),
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                size: 24,
                              ),
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

/// Circular hover-overlay action button for recommendation song cards.
///
/// Mirrors the visual style of the play button (surface background, onSurface
/// foreground) so secondary actions like "add to next" read as siblings of the
/// primary play action.
class _HoverCircleButton extends StatelessWidget {
  const _HoverCircleButton({
    required this.icon,
    required this.size,
    required this.tooltip,
    required this.onPressed,
    this.iconSize,
  });

  final IconData icon;
  final double size;
  final String tooltip;
  final VoidCallback onPressed;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Tooltip(
      message: tooltip,
      child: Material(
        color: theme.colorScheme.surface.withValues(alpha: .96),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: size,
            height: size,
            child: Icon(
              icon,
              size: iconSize ?? size * 0.55,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
