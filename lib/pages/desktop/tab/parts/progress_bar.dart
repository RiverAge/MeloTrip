part of '../tab_page.dart';

class _DesktopProgressBar extends StatelessWidget {
  const _DesktopProgressBar({required this.player});

  final AppPlayer player;

  double _timeLabelWidth(
    BuildContext context, {
    required String current,
    required String total,
  }) {
    final style = const TextStyle(fontSize: 11);
    final textDirection = Directionality.of(context);
    final currentPainter = TextPainter(
      text: TextSpan(text: current, style: style),
      textDirection: textDirection,
      maxLines: 1,
    )..layout();
    final totalPainter = TextPainter(
      text: TextSpan(text: total, style: style),
      textDirection: textDirection,
      maxLines: 1,
    )..layout();
    return (currentPainter.width > totalPainter.width
            ? currentPainter.width
            : totalPainter.width) +
        6;
  }

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
            final currentText = durationFormatter(position.inSeconds);
            final totalText = durationFormatter(duration?.inSeconds ?? 0);
            final timeLabelWidth = _timeLabelWidth(
              context,
              current: currentText,
              total: totalText,
            );
            return Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: timeLabelWidth),
                  child: Text(
                    currentText,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                Expanded(
                  child: AppLinearSlider(
                    min: 0,
                    max: maxSec == 0 ? 1 : maxSec,
                    value: maxSec == 0 ? 0 : posSec,
                    trackHeight: 4.2,
                    thumbRadius: 6.5,
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.25),
                    onChanged: (value) {
                      player.seek(Duration(seconds: value.round()));
                    },
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: timeLabelWidth),
                  child: Text(
                    totalText,
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
