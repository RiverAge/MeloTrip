part of 'music_bar.dart';

class _BottomSheetItem extends StatelessWidget {
  const _BottomSheetItem({
    required this.songs,
    required this.currentPlayingIndex,
    required this.index,
    // this.onRemove
  });

  final List<SongEntity?> songs;
  final int currentPlayingIndex;
  final int index;
  // final void Function(int index)? onRemove;

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return ListTile(
          onTap: () {
            if (currentPlayingIndex == index) {
              player.playOrPause();
            } else {
              player.skipToQueueItem(index);
            }
          },
          contentPadding: EdgeInsets.symmetric(horizontal: 8),
          leading: Row(
            mainAxisSize: .min,
            children: [
              Text(
                (index + 1).toString().padLeft(2, ' '),
                style: TextStyle(
                  fontWeight: currentPlayingIndex == index
                      ? .bold
                      : .normal,
                  fontStyle: .italic,
                  fontSize: 17,
                ),
              ),
              AsyncValueBuilder(
                provider: appPlayerHandlerProvider,
                builder: (context, player, _) {
                  return AsyncStreamBuilder(
                    provider: player.playingStream,
                    loading: (ctx) => const SizedBox.shrink(),
                    builder: (_, playing) {
                      final isPlaying =
                          currentPlayingIndex == index && playing == true;
                      return AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        child: SizedBox(
                          width: isPlaying ? 30 : 0,
                          height: isPlaying ? 30 : 0,
                          child: isPlaying
                              ? Image.asset(
                                  'images/playing.gif',
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
              Container(
                width: 40,
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                clipBehavior: .antiAlias,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: ArtworkImage(id: songs[index]?.id),
              ),
            ],
          ),
          title: Text(
            '${songs[index]?.title}',
            style: TextStyle(
              color: currentPlayingIndex == index
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: currentPlayingIndex == index
                  ? .bold
                  : .normal,
            ),
            overflow: .ellipsis,
          ),
          subtitle: Text(
            '${songs[index]?.artist} - ${songs[index]?.album}',
            overflow: .ellipsis,
            style: TextStyle(
              color: currentPlayingIndex == index
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              player.removeQueueItemAt(index);
            },
          ),
        );
      },
    );
  }
}
