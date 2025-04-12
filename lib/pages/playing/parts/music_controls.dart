part of '../playing_page.dart';

class _MusicControls extends StatelessWidget {
  const _MusicControls();

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      IconButton(
          onPressed: () async {
            final messenger = ScaffoldMessenger.of(context);
            final height = MediaQuery.of(context).size.height;
            final hanlder = await AppPlayerHandler.instance;
            final player = hanlder.player;
            if (player.loopMode == LoopMode.all) {
              player.setLoopMode(LoopMode.off);
              messenger.clearSnackBars();
              messenger.showSnackBar(SnackBar(
                content: const Text('顺序播放'),
                behavior: SnackBarBehavior.floating,
                margin:
                    EdgeInsets.only(bottom: height - 150, left: 10, right: 10),
              ));
            } else if (player.loopMode == LoopMode.off) {
              player.setLoopMode(LoopMode.one);
              messenger.clearSnackBars();
              messenger.showSnackBar(SnackBar(
                content: const Text('单曲循环'),
                behavior: SnackBarBehavior.floating,
                margin:
                    EdgeInsets.only(bottom: height - 150, left: 10, right: 10),
              ));
            } else if (player.loopMode == LoopMode.one) {
              player.setLoopMode(LoopMode.all);
              messenger.clearSnackBars();
              messenger.showSnackBar(SnackBar(
                content: const Text('列表循环'),
                behavior: SnackBarBehavior.floating,
                margin:
                    EdgeInsets.only(bottom: height - 150, left: 10, right: 10),
              ));
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
                        final messenger = ScaffoldMessenger.of(context);
                        final height = MediaQuery.of(context).size.height;
                        final hanlder = await AppPlayerHandler.instance;
                        final player = hanlder.player;
                        await player
                            .setShuffleModeEnabled(!player.shuffleModeEnabled);
                        messenger.clearSnackBars();
                        messenger.showSnackBar(SnackBar(
                          content: Text(
                              textAlign: TextAlign.center,
                              '随机${player.shuffleModeEnabled ? '开启' : '关闭'}'),
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.only(
                              bottom: height - 150, left: 10, right: 10),
                        ));
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
