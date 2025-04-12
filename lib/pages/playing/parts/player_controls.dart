part of '../playing_page.dart';

enum PlayerNextState { pause, play, replay }

class _PlayerControls extends StatelessWidget {
  const _PlayerControls();

  _seekReplay(Duration d) async {
    final handler = await AppPlayerHandler.instance;
    final player = handler.player;
    final current = player.position;

    final c = current;
    Duration dest = c;
    dest = c - d;
    dest = d < Duration.zero ? Duration.zero : dest;

    player.seek(dest);
  }

  _seekForward(Duration d) async {
    final handler = await AppPlayerHandler.instance;
    final player = handler.player;
    final current = player.position;
    final total = player.duration;

    final c = current;
    final t = total ?? Duration.zero;
    Duration dest = c;
    dest = d + c;
    dest = dest > t ? t : dest;

    player.seek(dest);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () async {
              final handler = await AppPlayerHandler.instance;
              final player = handler.player;
              player.skipToPrevious();
            },
            icon: const Icon(
              Icons.skip_previous_outlined,
              size: 40,
            )),
        IconButton(
            onPressed: () {
              _seekReplay(const Duration(seconds: 30));
            },
            icon: const Icon(
              Icons.replay_30_outlined,
            )),
        AsyncStreamBuilder(
            provider: playerStateStreamProvider,
            builder: (context, data, ref) {
              return IconButton(
                  onPressed: data.processingState != ProcessingState.ready &&
                          data.processingState != ProcessingState.completed
                      ? null
                      : () async {
                          final handler = await AppPlayerHandler.instance;
                          final player = handler.player;
                          if (player.playing) {
                            player.pause();
                          } else {
                            player.play();
                          }
                        },
                  icon: Icon(
                    data.playing
                        ? Icons.pause_circle_outline
                        : Icons.play_circle_outlined,
                    size: 60,
                  ));
            }),
        IconButton(
            onPressed: () {
              _seekForward(const Duration(seconds: 30));
            },
            icon: const Icon(
              Icons.forward_30_outlined,
            )),
        IconButton(
            onPressed: () async {
              final handler = await AppPlayerHandler.instance;
              final player = handler.player;
              player.skipToNext();
            },
            icon: const Icon(
              Icons.skip_next_outlined,
              size: 40,
            )),
      ],
    );
  }
}
