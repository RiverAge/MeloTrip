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
    return InkWell(
      onTap: () async {
        final handler = await AppPlayerHandler.instance;
        final player = handler.player;
        if (currentPlayingIndex == index) {
          player.playOrPause();
          // if (player.playing == true) {
          //   player.pause();
          // } else {
          //   player.play();
          // }
        } else {
          await player.skipToQueueItem(index);
          // if (player.playing != true) {
          // player.play();
          // }
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          children: [
            Text(
              (index + 1).toString().padLeft(2, ' '),
              style: TextStyle(
                fontWeight:
                    currentPlayingIndex == index
                        ? FontWeight.bold
                        : FontWeight.normal,
                fontStyle: FontStyle.italic,
                fontSize: 17,
              ),
            ),
            AsyncStreamBuilder(
              provider: playingStreamProvider,
              loading: (ctx, _) => const SizedBox.shrink(),
              builder: (_, playing, __) {
                final isPlaying =
                    currentPlayingIndex == index && playing == true;
                return AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: SizedBox(
                    width: isPlaying ? 30 : 0,
                    height: isPlaying ? 30 : 0,
                    child:
                        isPlaying
                            ? Image.asset(
                              'images/playing.gif',
                              color: Theme.of(context).colorScheme.primary,
                            )
                            : null,
                  ),
                );
              },
            ),
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: ArtworkImage(id: songs[index]?.id),
            ),
            // const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${songs[index]?.title}',
                    style: TextStyle(
                      color:
                          currentPlayingIndex == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight:
                          currentPlayingIndex == index
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${songs[index]?.artist} - ${songs[index]?.album}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color:
                          currentPlayingIndex == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () async {
                final handler = await AppPlayerHandler.instance;
                final player = handler.player;
                await player.removeQueueItemAt(index);
                // if (onRemove != null) {
                //   onRemove!(index);
                // }
              },
            ),
          ],
        ),
      ),
    );
  }
}
