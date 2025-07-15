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
            trackHeight: 2,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
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
            secondaryTrackValue:
                sTotal == 0
                    ? 0
                    : sBufferPercent > 1
                    ? 1
                    : sBufferPercent,
            // 20240829会有超过1的情况
            value: effectiveValue > 1 ? 1 : effectiveValue,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(durationFormatter(sCurrent)),
              Text(sTotal == 0 ? '--:--' : durationFormatter(sTotal)),
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
      builder:
          (_, position) => _progresssBuilder(
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
      builder:
          (_, bufferedPosition) => _positionBuilder(
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
              emptyBuilder:
                  (_) =>
                      _bufferBuilder(duration: serverDuration, player: player),
              builder:
                  (_, duration) => _bufferBuilder(
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
