part of '../tab_page.dart';

class _DesktopProgressBar extends StatelessWidget {
  const _DesktopProgressBar({required this.player});

  final AppPlayer player;

  @override
  Widget build(BuildContext context) {
    return AsyncStreamBuilder(
      provider: player.positionStream,
      loading: (_) => const SizedBox.shrink(),
      builder: (_, position) {
        return AsyncStreamBuilder(
          provider: player.durationStream,
          loading: (_) => const SizedBox.shrink(),
          builder: (_, duration) {
            final maxSec = (duration ?? Duration.zero).inSeconds.toDouble();
            final posSec = position.inSeconds
                .toDouble()
                .clamp(0, maxSec <= 0 ? 0 : maxSec)
                .toDouble();
            return Row(
              children: [
                SizedBox(
                  width: 46,
                  child: Text(
                    durationFormatter(position.inSeconds),
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                Expanded(
                  child: SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.25),
                      overlayShape: SliderComponentShape.noOverlay,
                      trackHeight: 4.2,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 6.5,
                      ),
                    ),
                    child: Slider(
                      min: 0,
                      max: maxSec == 0 ? 1 : maxSec,
                      value: maxSec == 0 ? 0 : posSec,
                      onChanged: (value) {
                        player.seek(Duration(seconds: value.round()));
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 46,
                  child: Text(
                    durationFormatter(duration?.inSeconds ?? 0),
                    style: const TextStyle(fontSize: 11),
                    textAlign: .right,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
