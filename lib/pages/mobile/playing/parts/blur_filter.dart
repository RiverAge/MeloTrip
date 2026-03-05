part of '../playing_page.dart';

class _BlurFilter extends StatelessWidget {
  const _BlurFilter();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: PlaybackBlurOverlay(
        blurSigma: 30,
        surfaceAlpha: .35,
        useVignette: false,
      ),
    );
  }
}
