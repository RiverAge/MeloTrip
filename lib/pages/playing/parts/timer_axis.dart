part of '../playing_page.dart';

class _TimerAxis extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TimerAxisState();
}

class _TimerAxisState extends State<_TimerAxis> {
  bool _isSliding = false;
  double _slidigValue = 0;

  Widget _progresssBuilder({
    Duration? duration,
    Duration? bufferedPosition,
    Duration? position,
    required AppPlayer player,
  }) {
    final sCurrent = position?.inSeconds ?? 0;
    final sTotal = duration?.inSeconds ?? 0;
    final sBuffer = bufferedPosition?.inSeconds ?? 0;
    final sBufferPercent = sTotal == 0 ? 0.0 : sBuffer / sTotal;
    final value = sTotal == 0 ? 0.0 : sCurrent / sTotal;
    final effectiveValue = _isSliding ? _slidigValue : value;

    return Column(
      children: [
        SliderTheme(
          data: const SliderThemeData(
            padding: EdgeInsets.only(left: 25, right: 25, top: 4),
            trackHeight: 4.0,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 6.0,
              pressedElevation: 9.0,
            ),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 16.0),
            trackShape: RoundedRectSliderTrackShape(),
          ),
          child: Slider(
            onChangeStart: (val) {
              setState(() {
                _isSliding = true;
                _slidigValue = val;
              });
            },
            onChangeEnd: (val) async {
              await player.seek(Duration(seconds: (sTotal * val).toInt()));
              setState(() {
                _isSliding = false;
                _slidigValue = val;
              });
            },
            onChanged: (val) {
              setState(() {
                _slidigValue = val;
              });
            },
            secondaryTrackValue: sBufferPercent > 1 ? 1 : sBufferPercent,
            value: effectiveValue > 1 ? 1 : effectiveValue,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                durationFormatter(sCurrent),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(127),
                ),
              ),
              Text(
                sTotal == 0 ? '--:--' : durationFormatter(sTotal),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(127),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _positionBuilder({
    Duration? duration,
    Duration? bufferedPosition,
    required AppPlayer player,
  }) {
    return AsyncStreamBuilder(
      provider: player.positionStream,
      builder: (_, position) => _progresssBuilder(
        duration: duration,
        bufferedPosition: bufferedPosition,
        position: position,
        player: player,
      ),
    );
  }

  Widget _bufferBuilder({Duration? duration, required AppPlayer player}) {
    return AsyncStreamBuilder(
      provider: player.bufferedPositionStream,
      emptyBuilder: (_) => _positionBuilder(duration: duration, player: player),
      builder: (_, bufferedPosition) => _positionBuilder(
        duration: duration,
        bufferedPosition: bufferedPosition,
        player: player,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      builder: (context, player, _) {
        return PlayQueueBuilder(
          builder: (context, playQueue, ref) {
            if (playQueue.index >= playQueue.songs.length) {
              return const SizedBox.shrink();
            }

            final current = playQueue.songs[playQueue.index];
            final serverDuration = Duration(seconds: current.duration ?? 0);
            return AsyncStreamBuilder(
              provider: player.durationStream,
              emptyBuilder: (_) =>
                  _bufferBuilder(duration: serverDuration, player: player),
              builder: (_, duration) => _bufferBuilder(
                duration: duration ?? serverDuration,
                player: player,
              ),
            );
          },
        );
      },
    );
  }
}
