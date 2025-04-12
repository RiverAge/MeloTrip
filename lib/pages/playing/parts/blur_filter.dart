part of '../playing_page.dart';

class _BlurFilter extends StatelessWidget {
  const _BlurFilter({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surface;
    return Positioned.fill(
      child: Container(
        color: color.withValues(alpha: .95),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
