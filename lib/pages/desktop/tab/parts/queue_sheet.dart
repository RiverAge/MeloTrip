part of '../tab_page.dart';

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