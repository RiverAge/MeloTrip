part of 'music_bar.dart';

class _BottomSheetControls extends StatelessWidget {
  const _BottomSheetControls();
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton(
          onPressed: () async {
            final hanlder = await AppPlayerHandler.instance;
            final player = hanlder.player;
            if (player.loopMode == LoopMode.all) {
              player.setLoopMode(LoopMode.off);
            } else if (player.loopMode == LoopMode.off) {
              player.setLoopMode(LoopMode.one);
            } else if (player.loopMode == LoopMode.one) {
              player.setLoopMode(LoopMode.all);
            }
          },
          icon: AsyncStreamBuilder(
              provider: loopModeStreamProvider,
              builder: (_, loopMode, __) {
                return Icon(switch (loopMode) {
                  LoopMode.off => Icons.queue_music_outlined,
                  LoopMode.all => Icons.repeat,
                  LoopMode.one => Icons.repeat_one_outlined
                });
              })),
      AsyncStreamBuilder(
          provider: loopModeStreamProvider,
          builder: (_, loopMode, __) {
            return IconButton(
                onPressed: loopMode == LoopMode.one
                    ? null
                    : () async {
                        final hanlder = await AppPlayerHandler.instance;
                        final player = hanlder.player;
                        await player
                            .setShuffleModeEnabled(!player.shuffleModeEnabled);
                      },
                icon: AsyncStreamBuilder(
                    provider: shuffleModeEnabledStreamProvider,
                    builder: (_, mode, __) {
                      return mode
                          ? Icon(Icons.shuffle_on_outlined,
                              color: Theme.of(context).colorScheme.primary)
                          : const Icon(Icons.shuffle_outlined);
                    }));
          })
    ]);
  }
}
