part of '../playing_page.dart';

class _CoverLyricsSwitcher extends StatefulWidget {
  const _CoverLyricsSwitcher();

  @override
  State<StatefulWidget> createState() => _CoverLyricsSwitcherState();
}

class _CoverLyricsSwitcherState extends State<_CoverLyricsSwitcher> {
  bool _isFront = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isFront = !_isFront;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 650),
        child: _isFront ? const _RotateCover() : const _AnimtedLyrics(),
      ),
    );
  }
}
