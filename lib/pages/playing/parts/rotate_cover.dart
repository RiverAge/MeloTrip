part of '../playing_page.dart';

class _RotateCover extends StatefulWidget {
  const _RotateCover();

  @override
  State<StatefulWidget> createState() => _RotateCoverState();
}

class _RotateCoverState extends State<_RotateCover>
    with SingleTickerProviderStateMixin {
  StreamSubscription<bool>? _playingStream;

  _RotateCoverState();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 15),
    vsync: this,
  );

  @override
  void initState() {
    _setStream();
    super.initState();
  }

  @override
  void dispose() {
    _playingStream?.cancel();
    _controller.dispose();
    super.dispose();
  }

  _setStream() async {
    final handler = await AppPlayerHandler.instance;
    final player = handler.player;
    _playingStream = player.playingStream.listen((playing) {
      if (playing) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
    child: RotationTransition(
      turns: _controller,
      child: PlayQueueBuilder(
        builder: (context, playQueue, ref) {
          if (playQueue.index >= playQueue.songs.length) {
            return SizedBox.shrink();
          }

          final current = playQueue.songs[playQueue.index];
          return ClipOval(
            child: ArtworkImage(
              id: 'mf-${current.id}',
              fit: BoxFit.cover,
              width: 300,
              height: 300,
              size: 300,
            ),
          );
        },
      ),
    ),
  );
}
