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
    final sBufferPercent = sBuffer / sTotal;
    final double value = sTotal == 0 ? 0 : sCurrent / sTotal;
    // 拖动滑动条时播放器会出现电流音，
    // 只有停止拖动滚动条才能调用seek
    final effectiveValue = _isSliding ? _slidigValue : value;
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            padding: EdgeInsets.only(left: 25, right: 25, top: 4),
            trackHeight: 4.0, // 稍微加粗一点点，更有质感
            // 1. 定制滑块形状：平时让它小一点，甚至可以自定义成一个小竖线
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6.0, // 缩小到 6，显得精致
              pressedElevation: 9.0, // 按下时放大，提供反馈
            ),

            // 2. 去掉滑块周围的“光晕” (Overlay)，或者让它更淡
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),

            trackShape: const RoundedRectSliderTrackShape(),
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
              // player.seek(Duration(seconds: (sTotal * value).toInt()));
            },
            secondaryTrackValue: sTotal == 0
                ? 0
                : sBufferPercent > 1
                ? 1
                : sBufferPercent,
            // 20240829会有超过1的情况
            value: effectiveValue > 1 ? 1 : effectiveValue,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    // 这里just_audio偶尔无法获取duration，这里使用后端返回的数据
    return PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        if (playQueue.index >= playQueue.songs.length) {
          return const SizedBox.shrink();
        }

        final current = playQueue.songs[playQueue.index];
        final serverDuration = Duration(seconds: current.duration ?? 0);
        return AsyncValueBuilder(
          provider: appPlayerHandlerProvider,
          builder: (context, player, _) {
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
