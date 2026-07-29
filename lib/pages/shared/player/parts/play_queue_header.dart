part of 'package:melo_trip/pages/shared/player/play_queue_panel.dart';

class _PlayQueueHeader extends StatelessWidget {
  const _PlayQueueHeader({
    required this.player,
    required this.variant,
    required this.closeAfterClear,
    this.onClose,
    required this.searchExpanded,
    required this.onToggleSearch,
    required this.searchStyle,
    required this.searchController,
  });

  final AppPlayer player;
  final PlayQueuePanelVariant variant;
  final VoidCallback? onClose;
  final bool closeAfterClear;
  final bool searchExpanded;
  final VoidCallback onToggleSearch;
  final PlayQueueSearchStyle searchStyle;
  final TextEditingController searchController;

  bool get _isDesktop => variant == PlayQueuePanelVariant.desktop;
  bool get isBActive =>
      searchStyle == PlayQueueSearchStyle.headerInline && searchExpanded;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.fromLTRB(
        _isDesktop ? 18 : 16,
        _isDesktop ? 14 : 12,
        12,
        10,
      ),
      decoration: BoxDecoration(
        color: _isDesktop
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)
            : null,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.22),
          ),
        ),
      ),
      child: Row(
        children: [
          if (isBActive)
            // Search active: the pill takes the whole row (title and the
            // mode/shuffle/clear buttons are hidden inside the pill). The
            // input is Expanded to fill the pill's leftover width.
            Expanded(child: _buildPill(context))
          else ...[
            Expanded(child: _PlayQueueTitle(variant: variant, player: player)),
            _buildPill(context),
            if (_isDesktop)
              IconButton(
                onPressed: onClose,
                icon: const Icon(Icons.close_rounded),
              ),
          ],
        ],
      ),
    );
  }

  /// The pill container holding the search control and the
  /// mode/shuffle/clear buttons. B variant uses a single toggle button
  /// that morphs between search and back; the input expands next to it via
  /// AnimatedSize. While B search is active, the mode/shuffle/clear buttons
  /// are hidden so the input gets the full pill width.
  Widget _buildPill(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isB = searchStyle == PlayQueueSearchStyle.headerInline;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(
          alpha: _isDesktop ? 0.88 : 0.92,
        ),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(
            alpha: _isDesktop ? 0.28 : 0.22,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: isBActive ? .max : .min,
        children: [
          if (isB)
            _PlayQueueHeaderInlineSearch(
              controller: searchController,
              variant: variant,
              expanded: searchExpanded,
            )
          else
            IconButton(
              tooltip: l10n.searchPlayQueue,
              onPressed: onToggleSearch,
              icon: Icon(
                searchExpanded
                    ? Icons.search_rounded
                    : Icons.search_outlined,
                color: searchExpanded ? colorScheme.primary : null,
              ),
            ),
          if (isB)
            IconButton(
              tooltip: searchExpanded ? l10n.revoke : l10n.searchPlayQueue,
              onPressed: onToggleSearch,
              icon: Icon(
                searchExpanded
                    ? Icons.arrow_back_rounded
                    : Icons.search_outlined,
                color: searchExpanded
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          if (!isBActive) ...[
            const _PlayQueuePlaylistModeButton(),
            const _PlayQueueShuffleModeButton(),
            const _SaveQueueAsPlaylistButton(),
            _ClearQueueButton(
              player: player,
              closeAfterClear: closeAfterClear,
              onClose: onClose,
            ),
          ],
        ],
      ),
    );
  }
}

/// B variant: a compact search input embedded inside the header pill.
/// Uses [Flexible] with a loose fit + [AnimatedSize] so it can both animate
/// its width (0 <-> fill) AND expand to fill the pill's leftover width once
/// the mode/shuffle/clear buttons are hidden. Shares the pill's fill/border
/// — no independent outline, no underline.
class _PlayQueueHeaderInlineSearch extends StatelessWidget {
  const _PlayQueueHeaderInlineSearch({
    required this.controller,
    required this.variant,
    required this.expanded,
  });

  final TextEditingController controller;
  final PlayQueuePanelVariant variant;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Flexible(
      fit: .loose,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
        alignment: Alignment.centerRight,
        child: SizedBox(
          // A large target so the loose constraint clamps it to whatever
          // width is available; 0 when collapsed.
          width: expanded ? 10000 : 0,
          child: AnimatedOpacity(
            opacity: expanded ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 160),
            child: expanded
                ? Padding(
                    padding: const EdgeInsets.only(left: 6, right: 2),
                    child: ValueListenableBuilder(
                      valueListenable: controller,
                      builder: (_, _, _) {
                        final hasText = controller.text.isNotEmpty;
                        return TextField(
                          controller: controller,
                          autofocus: true,
                          textInputAction: .search,
                          style: theme.textTheme.bodySmall,
                          cursorColor: colorScheme.primary,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText:
                                AppLocalizations.of(context)!.searchPlayQueue,
                            hintStyle: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.6),
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              size: 16,
                              color: colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.7),
                            ),
                            prefixIconConstraints: const BoxConstraints(
                              minWidth: 28,
                              minHeight: 28,
                            ),
                            suffixIcon: hasText
                                ? IconButton(
                                    visualDensity: VisualDensity.compact,
                                    iconSize: 16,
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(
                                      minWidth: 24,
                                      minHeight: 24,
                                    ),
                                    icon: const Icon(Icons.close_rounded),
                                    onPressed: controller.clear,
                                  )
                                : null,
                          suffixIconConstraints: const BoxConstraints(
                            minWidth: 24,
                            minHeight: 28,
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 8),
                          isCollapsed: true,
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      );
                    },
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    ),
    );
  }
}

class _ClearQueueButton extends StatelessWidget {
  const _ClearQueueButton({
    required this.player,
    required this.closeAfterClear,
    this.onClose,
  });

  final AppPlayer player;
  final bool closeAfterClear;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return PlayQueueBuilder(
      builder: (context, playQueue, _) {
        if (playQueue.songs.isEmpty) {
          return const SizedBox.shrink();
        }
        return IconButton(
          tooltip: AppLocalizations.of(context)!.clearPlayQueue,
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final l10n = AppLocalizations.of(context)!;
            await player.setPlaylist(songs: []);
            if (closeAfterClear) {
              onClose?.call();
            }
            const snackBarDuration = Duration(seconds: 6);
            showAutoClosingSnackBar(
              messenger,
              dismissAfter: snackBarDuration,
              snackBar: SnackBar(
                duration: snackBarDuration,
                content: Text(l10n.playQueueCleared),
                action: SnackBarAction(
                  label: l10n.revoke,
                  onPressed: () {
                    final currentIndex = playQueue.index.clamp(
                      0,
                      playQueue.songs.length - 1,
                    );
                    player.setPlaylist(
                      songs: playQueue.songs,
                      initialId: playQueue.songs[currentIndex].id,
                    );
                  },
                ),
              ),
            );
          },
          icon: const Icon(Icons.clear_all_outlined),
        );
      },
    );
  }
}

class _PlayQueueTitle extends StatelessWidget {
  const _PlayQueueTitle({required this.variant, required this.player});

  final PlayQueuePanelVariant variant;
  final AppPlayer player;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PlayQueueBuilder(
      builder: (context, playQueue, _) {
        if (variant == PlayQueuePanelVariant.mobile) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.playlist_play_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text.rich(
                  TextSpan(
                    text: AppLocalizations.of(context)!.playQueue,
                    style: theme.textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: ' (${playQueue.songs.length})',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        }

        return Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.playlist_play_rounded,
                color: colorScheme.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          AppLocalizations.of(context)!.playQueue,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: .w800,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.surface.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                            color: colorScheme.outlineVariant.withValues(
                              alpha: 0.3,
                            ),
                          ),
                        ),
                        child: Text(
                          playQueue.songs.length.toString(),
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: .w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
