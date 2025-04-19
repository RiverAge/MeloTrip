part of '../playing_page.dart';

class _BlurFilter extends StatelessWidget {
  const _BlurFilter();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surface;
    return Positioned.fill(
      child: Container(
        color: color.withValues(alpha: .35),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
          child: Container(),
        ),
      ),
    );
  }
}
