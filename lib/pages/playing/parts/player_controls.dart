part of '../playing_page.dart';

enum PlayerNextState { pause, play, replay }

class _PlayerControls extends StatelessWidget {
  const _PlayerControls();

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                player.skipToPrevious();
              },
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.skip_previous_rounded, size: 40),
            ),
            // IconButton(
            //   onPressed: () {
            //     final current = player.position;

            //     final c = current;
            //     Duration dest = c;
            //     dest = c - _stepDuration;
            //     dest = _stepDuration < Duration.zero ? Duration.zero : dest;

            //     player.seek(dest);
            //   },
            //   icon: const Icon(Icons.replay_30_outlined),
            // ),
            AsyncStreamBuilder(
              provider: player.playingStream,
              builder: (context, playing) {
                return IconButton(
                  onPressed: () {
                    player.playOrPause();
                  },
                  color: Theme.of(context).colorScheme.primary,
                  icon: Icon(
                    playing
                        ? Icons.pause_circle_outline_rounded
                        : Icons.play_circle_outline_rounded,
                    size: 60,
                  ),
                );
              },
            ),
            // IconButton(
            //   onPressed: () {
            //     final current = player.position;
            //     final total = player.duration;

            //     final c = current;
            //     final t = total ?? Duration.zero;
            //     Duration dest = c;
            //     dest = _stepDuration + c;
            //     dest = dest > t ? t : dest;

            //     player.seek(dest);
            //   },
            //   icon: const Icon(Icons.forward_30_outlined),
            // ),
            IconButton(
              onPressed: () {
                player.skipToNext();
              },
              color: Theme.of(context).colorScheme.primary,
              icon: const Icon(Icons.skip_next_rounded, size: 40),
            ),
          ],
        );
      },
    );
  }
}
