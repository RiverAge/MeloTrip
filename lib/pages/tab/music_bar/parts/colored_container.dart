part of 'music_bar.dart';

class _ColoredContainer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ColoredContainerState();
}

class _ColoredContainerState extends State<_ColoredContainer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    duration: const Duration(seconds: 7),
    vsync: this,
  );

  StreamSubscription<bool>? _playingStream;

  @override
  void initState() {
    _setStream();
    super.initState();
  }

  _setStream() async {
    final handler = await AppPlayerHandler.instance;
    final player = handler.player;
    _playingStream = player.playingStream.listen((playing) {
      if (playing) {
        _animationController.repeat(reverse: true);
      } else {
        _animationController.stop();
      }
    });
  }

  @override
  void dispose() {
    _playingStream?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Container(
          color: surface,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withAlpha(
                    (255 - _animationController.value * 255).toInt(),
                  ),
                  color.withAlpha((_animationController.value * 255).toInt()),
                ],
                // Gradient from
              ),
            ),
          ),
        );
      },
    );
  }
}
