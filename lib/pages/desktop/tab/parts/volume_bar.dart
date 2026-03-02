part of '../tab_page.dart';

class _DesktopVolumeBar extends ConsumerWidget {
  const _DesktopVolumeBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueBuilder(
      provider: appPlayerHandlerProvider,
      loading: (_, _) => const SizedBox.shrink(),
      empty: (_, _) => const SizedBox.shrink(),
      builder: (_, player, _) {
        return AsyncStreamBuilder(
          provider: player.volumeStream,
          loading: (_) => const SizedBox.shrink(),
          builder: (_, volume) {
            return Row(
              children: [
                const Spacer(),
                Icon(
                  volume < 0.1
                      ? Icons.volume_off_rounded
                      : Icons.volume_up_rounded,
                  size: 16,
                ),
                SizedBox(
                  width: 120,
                  child: SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 3,
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: .22),
                      overlayShape: SliderComponentShape.noOverlay,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 5,
                      ),
                    ),
                    child: Slider(
                      value: volume,
                      min: 0,
                      max: 100,
                      onChanged: player.setVolume,
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