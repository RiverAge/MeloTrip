part of '../tab_page.dart';

class _DesktopPlayerBar extends StatelessWidget {
  const _DesktopPlayerBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        border: Border(
          top: BorderSide(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withValues(alpha: .4),
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
                  SizedBox(
                    width: 250,
                    child: current == null
                        ? const SizedBox.shrink()
                        : Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: ArtworkImage(
                                  id: current.id,
                                  width: 46,
                                  height: 46,
                                  size: 200,
                                  fit: .cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text(
                                      current.title ?? '-',
                                      maxLines: 1,
                                      overflow: .ellipsis,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: .w700,
                                      ),
                                    ),
                                    Text(
                                      current.displayArtist ?? '-',
                                      maxLines: 1,
                                      overflow: .ellipsis,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 20,
                              onPressed: () =>
                                  player.setShuffleModeEnabled(true),
                              icon: const Icon(Icons.shuffle_rounded),
                            ),
                            IconButton(
                              iconSize: 22,
                              onPressed: player.skipToPrevious,
                              icon: const Icon(Icons.skip_previous_rounded),
                            ),
                            AsyncStreamBuilder(
                              provider: player.playingStream,
                              loading: (_) => const SizedBox.shrink(),
                              builder: (_, playing) {
                                return IconButton.filled(
                                  onPressed: player.playOrPause,
                                  icon: Icon(
                                    playing
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    size: 24,
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              iconSize: 22,
                              onPressed: player.skipToNext,
                              icon: const Icon(Icons.skip_next_rounded),
                            ),
                            IconButton(
                              iconSize: 20,
                              onPressed: () => player.setPlaylistMode(.loop),
                              icon: const Icon(Icons.repeat_rounded),
                            ),
                            IconButton(
                              iconSize: 20,
                              tooltip: AppLocalizations.of(context)!.playQueue,
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
                              icon: const Icon(Icons.playlist_play_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _DesktopProgressBar(player: player),
                      ],
                    ),
                  ),
                  const SizedBox(width: 250, child: _DesktopVolumeBar()),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

