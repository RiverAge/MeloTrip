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

class _DesktopProgressBar extends StatelessWidget {
  const _DesktopProgressBar({required this.player});

  final AppPlayer player;

  @override
  Widget build(BuildContext context) {
    return AsyncStreamBuilder(
      provider: player.positionStream,
      loading: (_) => const SizedBox.shrink(),
      builder: (_, position) {
        return AsyncStreamBuilder(
          provider: player.durationStream,
          loading: (_) => const SizedBox.shrink(),
          builder: (_, duration) {
            final maxSec = (duration ?? Duration.zero).inSeconds.toDouble();
            final posSec = position.inSeconds
                .toDouble()
                .clamp(0, maxSec <= 0 ? 0 : maxSec)
                .toDouble();
            return Row(
              children: [
                SizedBox(
                  width: 46,
                  child: Text(
                    durationFormatter(position.inSeconds),
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .25),
                      overlayShape: SliderComponentShape.noOverlay,
                      trackHeight: 4.2,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6.5,
                      ),
                    ),
                    child: Slider(
                      min: 0,
                      max: maxSec == 0 ? 1 : maxSec,
                      value: maxSec == 0 ? 0 : posSec,
                      onChanged: (value) {
                        player.seek(Duration(seconds: value.round()));
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 46,
                  child: Text(
                    durationFormatter(duration?.inSeconds ?? 0),
                    style: const TextStyle(fontSize: 11),
                    textAlign: .right,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _DesktopVolumeBar extends ConsumerWidget {
  const _DesktopVolumeBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      loading: (_, _) => const SizedBox.shrink(),
      empty: (_, _) => const SizedBox.shrink(),
      builder: (_, player, _) {
        return AsyncStreamBuilder(
          provider: player.volumeStream,
          loading: (_) => const SizedBox.shrink(),
          builder: (_, volume) {
            return Row(
              children: [
                const Spacer(),
                Icon(
                  volume < 0.1
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded,
                  size: 16,
                ),
                SizedBox(
                  width: 120,
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .22),
                      overlayShape: SliderComponentShape.noOverlay,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 5,
                      ),
                    ),
                    child: Slider(
                      value: volume,
                      min: 0,
                      max: 100,
                      onChanged: player.setVolume,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _DesktopQueueSheet extends ConsumerWidget {
  const _DesktopQueueSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return SafeArea(
      top: false,
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.62,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 10, 10),
              child: Row(
                children: [
                  Text(
                    l10n.playQueue,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: .w800,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: AsyncValueBuilder(
                provider: appPlayerHandlerProvider,
                loading: (_, _) => const SizedBox.shrink(),
                empty: (_, _) => const SizedBox.shrink(),
                builder: (context, player, _) {
                  return PlayQueueBuilder(
                    builder: (context, queue, _) {
                      if (queue.songs.isEmpty) return const SizedBox.shrink();
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                        itemCount: queue.songs.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 6),
                        itemBuilder: (_, index) {
                          final song = queue.songs[index];
                          final isActive = index == queue.index;
                          return Material(
                            color: isActive
                                ? theme.colorScheme.primaryContainer.withValues(
                                    alpha: .4,
                                  )
                                : theme.colorScheme.surfaceContainerHigh
                                      .withValues(alpha: .35),
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                player.skipToQueueItem(index);
                                Navigator.of(context).pop();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 9,
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: ArtworkImage(
                                        id: song.id,
                                        width: 36,
                                        height: 36,
                                        size: 180,
                                        fit: .cover,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    SizedBox(
                                      width: 28,
                                      child: Text(
                                        '${index + 1}',
                                        style: theme.textTheme.bodySmall,
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          Text(
                                            song.title ?? '-',
                                            maxLines: 1,
                                            overflow: .ellipsis,
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  fontWeight: isActive
                                                      ? .w700
                                                      : .w500,
                                                ),
                                          ),
                                          Text(
                                            '${song.displayArtist ?? '-'} · ${durationFormatter(song.duration)}',
                                            maxLines: 1,
                                            overflow: .ellipsis,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      isActive
                                          ? Icons.graphic_eq_rounded
                                          : Icons.play_arrow_rounded,
                                      size: 16,
                                      color: isActive
                                          ? theme.colorScheme.primary
                                          : theme.colorScheme.onSurfaceVariant
                                                .withValues(alpha: .7),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
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
