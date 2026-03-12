part of 'music_bar.dart';

class _BottomSheetShuffleMode extends StatelessWidget {
  const _BottomSheetShuffleMode();
  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, ref) {
        return AsyncStreamBuilder(
          provider: player.playlistModeStream,
          builder: (_, playlistMode) {
            return IconButton(
              onPressed: playlistMode == .single
                  ? null
                  : () async {
                      await player.setShuffleModeEnabled(!player.shuffle);
                    },
              icon: AsyncStreamBuilder(
                provider: player.shuffleStream,
                builder: (_, mode) {
                  return mode
                      ? Icon(
                          Icons.shuffle_on_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : const Icon(Icons.shuffle_rounded);
                },
              ),
            );
          },
        );
      },
    );
  }
}
