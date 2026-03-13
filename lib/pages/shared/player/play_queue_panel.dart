import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/l10n/app_localizations.dart';
import 'package:melo_trip/model/player/play_queue.dart';
import 'package:melo_trip/model/response/song/song.dart';
import 'package:melo_trip/provider/app/player.dart';
import 'package:melo_trip/widget/artwork_image.dart';
import 'package:melo_trip/widget/no_data.dart';
import 'package:melo_trip/widget/play_queue_builder.dart';
import 'package:melo_trip/widget/provider_value_builder.dart';

enum PlayQueuePanelVariant { mobile, desktop }

double? computePlayQueueJumpOffset({
  required int index,
  required int songCount,
  required double maxScrollExtent,
  double itemExtent = 72.0,
  double edgePadding = 23.0,
}) {
  if (index < 0 || index >= songCount || !maxScrollExtent.isFinite) {
    return null;
  }
  final safeMaxOffset = (maxScrollExtent - edgePadding).clamp(
    0.0,
    double.infinity,
  );
  final targetOffset = index * itemExtent;
  return targetOffset.clamp(0.0, safeMaxOffset).toDouble();
}

class PlayQueuePanel extends ConsumerWidget {
  const PlayQueuePanel({
    super.key,
    required this.variant,
    this.onClose,
    this.closeAfterClear = false,
    this.closeOnSelection = false,
  });

  final PlayQueuePanelVariant variant;
  final VoidCallback? onClose;
  final bool closeAfterClear;
  final bool closeOnSelection;

  bool get _isDesktop => variant == PlayQueuePanelVariant.desktop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return Column(
          children: [
            _PlayQueueHeader(
              player: player,
              variant: variant,
              onClose: onClose,
              closeAfterClear: closeAfterClear,
            ),
            Expanded(
              child: PlayQueueBuilder(
                builder: (_, playQueue, _) {
                  if (playQueue.songs.isEmpty) {
                    return const NoData();
                  }
                  return _PlayQueueListView(
                    playQueue: playQueue,
                    player: player,
                    variant: variant,
                    closeOnSelection: closeOnSelection,
                  );
                },
              ),
            ),
            if (_isDesktop)
              Container(
                height: 1,
                color: Theme.of(
                  context,
                ).colorScheme.outlineVariant.withValues(alpha: 0.2),
              ),
          ],
        );
      },
    );
  }
}

class _PlayQueueHeader extends StatelessWidget {
  const _PlayQueueHeader({
    required this.player,
    required this.variant,
    required this.closeAfterClear,
    this.onClose,
  });

  final AppPlayer player;
  final PlayQueuePanelVariant variant;
  final VoidCallback? onClose;
  final bool closeAfterClear;

  bool get _isDesktop => variant == PlayQueuePanelVariant.desktop;

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
          Expanded(child: _PlayQueueTitle(variant: variant, player: player)),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withValues(alpha: _isDesktop ? 0.88 : 0.92),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(
                  alpha: _isDesktop ? 0.28 : 0.22,
                ),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _PlayQueuePlaylistModeButton(),
                const _PlayQueueShuffleModeButton(),
                _ClearQueueButton(
                  player: player,
                  closeAfterClear: closeAfterClear,
                  onClose: onClose,
                ),
              ],
            ),
          ),
          if (_isDesktop)
            IconButton(
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded),
            ),
        ],
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
            messenger.showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 6),
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
                          '${playQueue.songs.length}',
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

class _PlayQueuePlaylistModeButton extends ConsumerWidget {
  const _PlayQueuePlaylistModeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return IconButton(
          onPressed: () {
            if (player.playlistMode == .loop) {
              player.setPlaylistMode(.none);
            } else if (player.playlistMode == .none) {
              player.setPlaylistMode(.single);
            } else {
              player.setPlaylistMode(.loop);
            }
          },
          icon: AsyncStreamBuilder(
            provider: player.playlistModeStream,
            builder: (_, playlistMode) {
              return Icon(switch (playlistMode) {
                .none => Icons.queue_music_outlined,
                .loop => Icons.repeat_rounded,
                .single => Icons.repeat_one_rounded,
              });
            },
          ),
        );
      },
    );
  }
}

class _PlayQueueShuffleModeButton extends ConsumerWidget {
  const _PlayQueueShuffleModeButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return AsyncStreamBuilder(
          provider: player.playlistModeStream,
          builder: (_, playlistMode) {
            return IconButton(
              onPressed: playlistMode == .single
                  ? null
                  : () => player.setShuffleModeEnabled(!player.shuffle),
              icon: AsyncStreamBuilder(
                provider: player.shuffleStream,
                builder: (_, enabled) {
                  return Icon(
                    enabled ? Icons.shuffle_on_rounded : Icons.shuffle_rounded,
                    color: enabled
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _PlayQueueListView extends ConsumerStatefulWidget {
  const _PlayQueueListView({
    required this.playQueue,
    required this.player,
    required this.variant,
    required this.closeOnSelection,
  });

  final PlayQueue playQueue;
  final AppPlayer player;
  final PlayQueuePanelVariant variant;
  final bool closeOnSelection;

  @override
  ConsumerState<_PlayQueueListView> createState() => _PlayQueueListViewState();
}

class _PlayQueueListViewState extends ConsumerState<_PlayQueueListView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _jumpToCurrentSong());
  }

  void _jumpToCurrentSong() {
    if (!_scrollController.hasClients) {
      return;
    }
    final offset = computePlayQueueJumpOffset(
      index: widget.playQueue.index,
      songCount: widget.playQueue.songs.length,
      maxScrollExtent: _scrollController.position.maxScrollExtent,
    );
    if (offset != null) {
      _scrollController.jumpTo(offset);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AsyncStreamBuilder(
      provider: widget.player.playingStream,
      loading: (_) => _buildListView(playing: false),
      builder: (_, playing) => _buildListView(playing: playing),
    );
  }

  Widget _buildListView({required bool playing}) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(
        widget.variant == PlayQueuePanelVariant.desktop ? 12 : 8,
        10,
        widget.variant == PlayQueuePanelVariant.desktop ? 12 : 8,
        12,
      ),
      itemExtent: 72,
      itemCount: widget.playQueue.songs.length,
      itemBuilder: (context, index) {
        return _PlayQueueListItem(
          player: widget.player,
          songs: widget.playQueue.songs,
          currentPlayingIndex: widget.playQueue.index,
          index: index,
          isCurrentPlaying: playing && widget.playQueue.index == index,
          variant: widget.variant,
          closeOnSelection: widget.closeOnSelection,
        );
      },
    );
  }
}

class _PlayQueueListItem extends StatelessWidget {
  const _PlayQueueListItem({
    required this.player,
    required this.songs,
    required this.currentPlayingIndex,
    required this.index,
    required this.isCurrentPlaying,
    required this.variant,
    required this.closeOnSelection,
  });

  final AppPlayer player;
  final List<SongEntity> songs;
  final int currentPlayingIndex;
  final int index;
  final bool isCurrentPlaying;
  final PlayQueuePanelVariant variant;
  final bool closeOnSelection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currentSong = songs[index];
    final isCurrent = currentPlayingIndex == index;
    final tile = ListTile(
      onTap: () {
        if (isCurrent) {
          player.playOrPause();
        } else {
          player.skipToQueueItem(index);
        }
        if (closeOnSelection) {
          Navigator.of(context).pop();
        }
      },
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: Row(
        mainAxisSize: .min,
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${index + 1}'.padLeft(2, ' '),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isCurrent
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
                fontWeight: isCurrent ? .w700 : .w500,
                fontStyle: .italic,
              ),
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
              width: isCurrentPlaying ? 26 : 0,
              height: isCurrentPlaying ? 26 : 0,
              child: isCurrentPlaying
                  ? Image.asset(
                      'images/playing.gif',
                      color: colorScheme.primary,
                    )
                  : null,
            ),
          ),
          Container(
            width: 40,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            clipBehavior: .antiAlias,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: ArtworkImage(id: currentSong.id, size: 96, fit: .cover),
          ),
        ],
      ),
      title: Text(
        currentSong.title ?? '-',
        overflow: .ellipsis,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: isCurrent ? colorScheme.primary : colorScheme.onSurface,
          fontWeight: isCurrent ? .w700 : .w500,
        ),
      ),
      subtitle: Text(
        '${currentSong.artist ?? '-'} - ${currentSong.album ?? '-'}',
        overflow: .ellipsis,
        style: theme.textTheme.bodySmall?.copyWith(
          color: isCurrent
              ? colorScheme.primary.withValues(alpha: 0.82)
              : colorScheme.onSurfaceVariant.withValues(alpha: 0.72),
        ),
      ),
      trailing: IconButton(
        tooltip: AppLocalizations.of(context)!.removeFromPlayQueue,
        icon: const Icon(Icons.playlist_remove_rounded),
        onPressed: () => player.removeQueueItemAt(index),
      ),
    );

    if (variant == PlayQueuePanelVariant.mobile) {
      return tile;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isCurrent
              ? colorScheme.primary.withValues(alpha: 0.08)
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.62),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isCurrent
                ? colorScheme.primary.withValues(alpha: 0.28)
                : colorScheme.outlineVariant.withValues(alpha: 0.18),
          ),
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ]
              : null,
        ),
        child: tile,
      ),
    );
  }
}
