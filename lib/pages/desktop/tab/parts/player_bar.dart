part of '../tab_page.dart';

class _DesktopPlayerBar extends StatelessWidget {
  const _DesktopPlayerBar({required this.onToggleFullPlayer});

  final VoidCallback onToggleFullPlayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final iconMutedColor = colorScheme.onSurfaceVariant.withValues(alpha: .72);
    return Container(
      height: 104,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? colorScheme.onSurface.withValues(alpha: .12)
                : theme.shadowColor.withValues(alpha: .12),
            blurRadius: isDark ? 14 : 16,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: colorScheme.surface.withValues(alpha: 0),
          ),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: AsyncValueBuilder(
        provider: appPlayerHandlerProvider,
        loading: (_, _) => const SizedBox.shrink(),
        empty: (_, _) => const SizedBox.shrink(),
        builder: (context, player, _) {
          return PlayQueueBuilder(
            builder: (context, playQueue, _) {
              final SongEntity? current =
                  playQueue.index < 0 ||
                      playQueue.index >= playQueue.songs.length
                  ? null
                  : playQueue.songs[playQueue.index];
              return Row(
                children: [
                  // 左侧歌曲信息：弹性布局确保自适应且维持对齐
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: current == null
                            ? const SizedBox.shrink()
                            : Row(
                                children: [
                                  _PlayerBarArtwork(
                                    id: current.id,
                                    onTap: onToggleFullPlayer,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _HoverText(
                                          text: current.title ?? '-',
                                          onTap: onToggleFullPlayer,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        _HoverText(
                                          text: current.displayArtist ?? '-',
                                          onTap:
                                              () {}, // TODO: Navigate to artist
                                          style: TextStyle(
                                            fontSize: 11,
                                            height: 1.2,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        _HoverText(
                                          text: current.album ?? '-',
                                          onTap:
                                              () {}, // TODO: Navigate to album
                                          style: TextStyle(
                                            fontSize: 11,
                                            height: 1.2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant
                                                .withValues(alpha: 0.7),
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

                  // 中间控制区
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            iconSize: 20,
                            tooltip: l10n.shuffleOn,
                            onPressed: () => player.setShuffleModeEnabled(true),
                            icon: Icon(
                              Icons.shuffle_outlined,
                              color: iconMutedColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            iconSize: 24,
                            tooltip: l10n.previousSong,
                            onPressed: player.skipToPrevious,
                            icon: const Icon(Icons.skip_previous_rounded),
                          ),
                          const SizedBox(width: 16),
                          AsyncStreamBuilder(
                            provider: player.playingStream,
                            loading: (_) => const SizedBox.shrink(),
                            builder: (_, playing) {
                              return IconButton.filled(
                                iconSize: 32,
                                tooltip: playing ? l10n.pause : l10n.play,
                                onPressed: player.playOrPause,
                                icon: Icon(
                                  playing
                                      ? Icons.pause_rounded
                                      : Icons.play_arrow_rounded,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            iconSize: 24,
                            tooltip: l10n.nextSong,
                            onPressed: player.skipToNext,
                            icon: const Icon(Icons.skip_next_rounded),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            iconSize: 20,
                            tooltip: l10n.playModeLoop,
                            onPressed: () => player.setPlaylistMode(.loop),
                            icon: Icon(
                              Icons.repeat_rounded,
                              color: iconMutedColor,
                            ),
                          ),
                          const SizedBox(width: 16),
                          IconButton(
                            iconSize: 20,
                            tooltip: l10n.playQueue,
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerLow,
                                isScrollControlled: true,
                                builder: (_) => const _DesktopQueueSheet(),
                              );
                            },
                            icon: Icon(
                              Icons.playlist_play_rounded,
                              color: iconMutedColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      // 进度条宽度随窗口动态调整
                      SizedBox(
                        width: (MediaQuery.sizeOf(context).width * 0.4).clamp(
                          300,
                          600,
                        ),
                        child: _DesktopProgressBar(player: player),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),

                  // 右侧功能区
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            // Top Row: Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star_outline_rounded,
                                  size: 14,
                                  color: iconMutedColor,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Bottom Row: Favorite + Volume
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  iconSize: 20,
                                  tooltip: l10n.favorite,
                                  icon: Icon(
                                    Icons.favorite_border_rounded,
                                    color: iconMutedColor,
                                  ),
                                ),
                                const _DesktopVolumeBar(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class _PlayerBarArtwork extends StatefulWidget {
  const _PlayerBarArtwork({required this.id, required this.onTap});
  final String? id;
  final VoidCallback onTap;

  @override
  State<_PlayerBarArtwork> createState() => _PlayerBarArtworkState();
}

class _PlayerBarArtworkState extends State<_PlayerBarArtwork> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Hero(
          tag: 'player_cover',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: ArtworkImage(
              id: widget.id,
              width: 46,
              height: 46,
              size: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverText extends StatefulWidget {
  const _HoverText({required this.text, required this.style, this.onTap});

  final String text;
  final TextStyle style;
  final VoidCallback? onTap;

  @override
  State<_HoverText> createState() => _HoverTextState();
}

class _HoverTextState extends State<_HoverText> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Text(
          widget.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: widget.style.copyWith(
            color: _isHovering
                ? Theme.of(context).colorScheme.primary
                : (widget.style.color),
            decoration: _isHovering
                ? TextDecoration.underline
                : TextDecoration.none,
            decorationColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
