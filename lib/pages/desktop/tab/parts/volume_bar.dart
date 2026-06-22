part of '../tab_page.dart';

class _DesktopVolumeBar extends ConsumerWidget {
  const _DesktopVolumeBar();

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
                  size: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withValues(alpha: 0.78),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 84,
                    maxWidth: 140,
                  ),
                  child: AppLinearSlider(
                    value: volume.clamp(0.0, 100.0).toDouble(),
                    min: 0,
                    max: 100,
                    trackHeight: 2,
                    thumbRadius: 4,
                    activeColor: Theme.of(context).colorScheme.primary,
                    inactiveColor: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.12),
                    onChanged: (value) => player?.setVolume(value),
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
