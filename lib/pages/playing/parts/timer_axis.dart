part of '../playing_page.dart';

class _TimerAxis extends StatelessWidget {
  const _TimerAxis();

  _progresssBuilder({
    Duration? duration,
    Duration? bufferedPosition,
    Duration? position,
  }) {
    final sCurrent = position?.inSeconds ?? 0;
    final sTotal = duration?.inSeconds ?? 0;
    final sBuffer = bufferedPosition?.inSeconds ?? 0;
    final sBufferPercent = sBuffer / sTotal;
    final double value = sTotal == 0 ? 0 : sCurrent / sTotal;
    return Column(
      children: [
        Slider(
          onChanged: (value) async {
            final handler = await AppPlayerHandler.instance;
            handler.player.seek(Duration(seconds: (sTotal * value).toInt()));
          },
          secondaryTrackValue:
              sTotal == 0
                  ? 0
                  : sBufferPercent > 1
                  ? 1
                  : sBufferPercent,
          // 20240829会有超过1的情况
          value: value > 1 ? 1 : value,
        ),
        // Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        //     child: SizedBox(
        //       // height: 12,
        //       width: double.infinity,
        //       child: Slider(
        //         onChanged: (value) {},
        //         value: sTotal == 0 ? 0 : sBuffer / sTotal,
        //       ),

        //       // child: BufferedProgress(
        //       //     percent: sTotal == 0 ? 0 : sCurrent / sTotal,
        //       //     buffer: sTotal == 0 ? 0 : sBuffer / sTotal)
        //     )),
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

  _positionBuilder({Duration? duration, Duration? bufferedPosition}) {
    return AsyncStreamBuilder(
      provider: positionStreamProvider,
      builder:
          (_, position, __) => _progresssBuilder(
            duration: duration,
            bufferedPosition: bufferedPosition,
            position: position,
          ),
    );
  }

  _bufferBuilder({Duration? duration}) {
    return AsyncStreamBuilder(
      provider: bufferedPositionStreamProvider,
      emptyBuilder: (_, __) => _positionBuilder(duration: duration),
      builder:
          (_, bufferedPosition, __) => _positionBuilder(
            duration: duration,
            bufferedPosition: bufferedPosition,
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
        return AsyncStreamBuilder(
          provider: durationStreamProvider,
          emptyBuilder: (_, __) => _bufferBuilder(duration: serverDuration),
          builder:
              (_, duration, __) =>
                  _bufferBuilder(duration: duration ?? serverDuration),
        );
      },
    );
  }
}
