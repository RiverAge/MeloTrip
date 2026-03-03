part of '../tab_page.dart';

class _DesktopVolumeBar extends ConsumerWidget {
  const _DesktopVolumeBar({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      loading: (_, _) => const SizedBox.shrink(),
      empty: (_, _) => const SizedBox.shrink(),
      builder: (_, handler, _) {
        final player = handler as AppPlayer?;
        final stream = player?.volumeStream;
        if (stream == null) return const SizedBox.shrink();
        return AsyncStreamBuilder(
          provider: stream,
          loading: (_) => const SizedBox.shrink(),
          builder: (_, volumeValue) {
            final volume = volumeValue as double? ?? 0.0;
            return Row(
              mainAxisSize: .min,
              children: [
                Icon(
                  volume < 0.1
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded,
                  size: compact ? 14 : 16,
                ),
                SizedBox(
                  width: compact ? 86 : 120,
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 2,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .12),
                      overlayShape: SliderComponentShape.noOverlay,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 4,
                        elevation: 0,
                        pressedElevation: 0,
                      ),
                    ),
                    child: Slider(
                      value: volume,
                      min: 0,
                      max: 100,
                      onChanged: (v) => player?.setVolume(v),
                    ),
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
