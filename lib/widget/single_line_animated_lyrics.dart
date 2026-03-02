import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';

class SingleLineAnimatedLyrics extends ConsumerStatefulWidget {
  const SingleLineAnimatedLyrics({
    super.key,
    required this.lyricsLines,
    this.crossAxisAlignment = .start,
  });
  final List<Line> lyricsLines;
  final CrossAxisAlignment crossAxisAlignment;
  @override
  ConsumerState<SingleLineAnimatedLyrics> createState() =>
      _SingleLineAnimatedLyrics();
}

class _SingleLineAnimatedLyrics
    extends ConsumerState<SingleLineAnimatedLyrics> {
  int _currentLineIdx = -1;
  StreamSubscription<Duration>? _positionStream;
  Duration _animationDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _setPositionListener();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  void _setPositionListener() async {
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (!mounted) return;
    _positionStream = player?.positionStream.listen((position) {
      _lyricsOfLine(widget.lyricsLines, position);
    });
  }

  void _lyricsOfLine(List<Line> lines, Duration position) {
    final currentLineIdx = indexOfLyrics(
      sortedLyrics: lines,
      position: position,
    );
    if (currentLineIdx != _currentLineIdx) {
      setState(() {
        // 控制首次出现不是以动画的效果
        _animationDuration = _currentLineIdx == -1
            ? Duration.zero
            : Duration(milliseconds: 500);
        _currentLineIdx = currentLineIdx;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final lyricsLines = widget.lyricsLines;
    if (_currentLineIdx == -1 || lyricsLines.isEmpty) {
      return SizedBox.shrink();
    }
    return _TweenAnimationBuilder(
      key: ValueKey(_currentLineIdx),
      animationDuration: _animationDuration,
      crossAxisAlignment: widget.crossAxisAlignment,
      currentLine: lyricsLines[_currentLineIdx],
      prevLine: lyricsLines[_currentLineIdx == 0 ? 0 : _currentLineIdx - 1],
    );
  }
}

class _TweenAnimationBuilder extends StatelessWidget {
  const _TweenAnimationBuilder({
    super.key,
    required this.currentLine,
    required this.prevLine,
    required this.animationDuration,
    required this.crossAxisAlignment,
  });

  final Line currentLine;
  final Line prevLine;
  final Duration animationDuration;
  final CrossAxisAlignment crossAxisAlignment;

  static const height = 35.0;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: animationDuration,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return SizedBox(
          height: height,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                height: height,
                top: -height * value,
                child: Opacity(
                  opacity: 1 - value,
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: crossAxisAlignment,
                    children: [
                      // 偏爱歌词同一个时间轴三行
                      for (final (index, line)
                          in (prevLine.value?.take(2) ?? []).indexed)
                        Opacity(
                          opacity: index == 0 ? 1 : 0.5,
                          child: Text(
                            line,
                            maxLines: 1,
                            style: (prevLine.value ?? []).length > 1
                                ? TextStyle(fontSize: [12.0, 10.0][index])
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                height: height,
                top: height - height * value,
                child: Opacity(
                  opacity: value,
                  child: Column(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: crossAxisAlignment,
                    children: [
                      for (final (index, line)
                          // 偏爱歌词同一个时间轴三行
                          in (currentLine.value?.take(2) ?? []).indexed)
                        Opacity(
                          opacity: index == 0 ? 1 : 0.5,
                          child: Text(
                            line,
                            maxLines: 1,
                            style: (currentLine.value ?? []).length > 1
                                ? TextStyle(fontSize: [12.0, 10.0][index])
                                : null,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
