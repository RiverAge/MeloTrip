part of '../playing_page.dart';

class _RotateCover extends ConsumerStatefulWidget {
  const _RotateCover();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RotateCoverState();
}

class _RotateCoverState extends ConsumerState<_RotateCover>
    with SingleTickerProviderStateMixin {
  StreamSubscription<bool>? _playingStream;

  _RotateCoverState();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 15),
    vsync: this,
  );

  @override
  void initState() {
    super.initState();
    _setStreamListner();
  }

  @override
  void dispose() {
    _playingStream?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _setStreamListner() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    _playingStream = player?.playingStream.listen((playing) {
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
