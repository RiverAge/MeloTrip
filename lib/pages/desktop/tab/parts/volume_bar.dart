part of '../tab_page.dart';

class _DesktopVolumeBar extends ConsumerWidget {
  const _DesktopVolumeBar();

  static const double _iconWidth = 16.0;
  static const double _minSliderWidth = 64.0;
  static const double _maxSliderWidth = 140.0;

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
            final theme = Theme.of(context);
            final volume = volumeValue as double? ?? 0.0;
            final volumeIcon = Icon(
              volume < 0.1 ? Icons.volume_off_rounded : Icons.volume_up_rounded,
              size: _iconWidth,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.78),
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                final sliderWidth = _resolveSliderWidth(constraints.maxWidth);
                if (sliderWidth == null) {
                  return constraints.maxWidth.isFinite &&
                          constraints.maxWidth < _iconWidth
                      ? const SizedBox.shrink()
                      : volumeIcon;
                }

                return Row(
                  mainAxisSize: .min,
                  children: [
                    volumeIcon,
                    SizedBox(
                      width: sliderWidth,
                      child: AppLinearSlider(
                        value: volume.clamp(0.0, 100.0).toDouble(),
                        min: 0,
                        max: 100,
                        trackHeight: 2,
                        thumbRadius: 4,
                        activeColor: theme.colorScheme.primary,
                        inactiveColor: theme.colorScheme.onSurface.withValues(
                          alpha: 0.12,
                        ),
                        onChanged: (value) => player?.setVolume(value),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  double? _resolveSliderWidth(double maxWidth) {
    if (!maxWidth.isFinite) return _maxSliderWidth;

    final sliderBudget = maxWidth - _iconWidth;
    if (sliderBudget < _minSliderWidth) return null;

    return sliderBudget.clamp(_minSliderWidth, _maxSliderWidth).toDouble();
  }
}
