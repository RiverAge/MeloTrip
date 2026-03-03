part of '../full_player_page.dart';

class _LyricItemHorizontal extends StatelessWidget {
  const _LyricItemHorizontal({
    super.key,
    required this.line,
    required this.isActive,
  });

  final Line line;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final values = line.value ?? [];
    if (values.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final text in values)
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              style: TextStyle(
                fontSize: isActive ? 42 : 36,
                height: 1.4,
                fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
                color: isActive
                    ? colorScheme.onSurface
                    : colorScheme.onSurface.withValues(alpha: .35),
                shadows: isActive
                    ? [
                        Shadow(
                          color: colorScheme.scrim.withValues(alpha: .3),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ]
                    : null,
              ),
              child: Text(text),
            ),
        ],
      ),
    );
  }
}
