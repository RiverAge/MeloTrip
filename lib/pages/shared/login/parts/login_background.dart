part of '../login_page.dart';

class _LoginBackground extends StatelessWidget {
  const _LoginBackground();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.surfaceContainerLow,
            Color.lerp(colorScheme.surface, colorScheme.primary, 0.05)!,
            colorScheme.surfaceContainerHigh,
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: _GlowShape(
              size: 400,
              color: colorScheme.primary.withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _GlowShape(
              size: 300,
              color: colorScheme.primary.withValues(alpha: 0.08),
            ),
          ),
          Positioned(
            top: 200,
            left: 100,
            child: _GlowShape(
              size: 150,
              color: colorScheme.secondary.withValues(alpha: 0.05),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowShape extends StatelessWidget {
  const _GlowShape({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: 100, spreadRadius: 50)],
      ),
    );
  }
}
