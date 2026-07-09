import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/provider/app/player.dart';

class SingleLineAnimatedLyrics extends ConsumerStatefulWidget {
  const SingleLineAnimatedLyrics({
    super.key,
    required this.lyricsLines,
    this.cueLinesByStart,
    this.crossAxisAlignment = .start,
  });
  final List<Line> lyricsLines;
  final Map<int, CueLine>? cueLinesByStart;
  final CrossAxisAlignment crossAxisAlignment;
  @override
  ConsumerState<SingleLineAnimatedLyrics> createState() =>
      _SingleLineAnimatedLyrics();
}

class _SingleLineAnimatedLyrics
    extends ConsumerState<SingleLineAnimatedLyrics> {
  int _currentLineIdx = -1;
  Duration _animationDuration = Duration.zero;
  StreamSubscription<Duration>? _positionStream;
  int _positionMs = 0;

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
    if (_positionStream != null) return;
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (!mounted) return;
    _positionStream = player?.positionStream.listen((position) {
      _positionMs = position.inMilliseconds;
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
    } else {
      final start = lines[currentLineIdx].start;
      final cueLine = start == null ? null : widget.cueLinesByStart?[start];
      if (cueLine != null) {
        // 同一行内随位置推进逐字色变。
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final lyricsLines = widget.lyricsLines;
    if (_currentLineIdx == -1 || lyricsLines.isEmpty) {
      return SizedBox.shrink();
    }
    final currentStart = lyricsLines[_currentLineIdx].start;
    final cueLine =
        currentStart == null ? null : widget.cueLinesByStart?[currentStart];
    return _TweenAnimationBuilder(
      key: ValueKey(_currentLineIdx),
      animationDuration: _animationDuration,
      crossAxisAlignment: widget.crossAxisAlignment,
      currentLine: lyricsLines[_currentLineIdx],
      prevLine: lyricsLines[_currentLineIdx == 0 ? 0 : _currentLineIdx - 1],
      cueLine: cueLine,
      positionMs: _positionMs,
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
    required this.cueLine,
    required this.positionMs,
  });

  final Line currentLine;
  final Line prevLine;
  final Duration animationDuration;
  final CrossAxisAlignment crossAxisAlignment;
  final CueLine? cueLine;
  final int positionMs;

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
                      Text(
                        prevLine.value ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                      _currentLineContent(context),
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

  /// 当前行内容：有 [cueLine] 时渲染逐字 Text.rich，否则整行 Text。
  Widget _currentLineContent(BuildContext context) {
    final cueLine = this.cueLine;
    if (cueLine == null || cueLine.cue == null || cueLine.cue!.isEmpty) {
      return Text(
        currentLine.value ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    final cues = cueLine.cue!;
    final progress = cueProgressByStartMs(cues: cues, positionMs: positionMs);
    final colorScheme = Theme.of(context).colorScheme;
    final inactive = colorScheme.onSurfaceVariant.withValues(alpha: 0.5);
    final active = colorScheme.primary;

    final spans = <InlineSpan>[
      for (var i = 0; i < cues.length; i++)
        TextSpan(
          text: cues[i].value ?? '',
          style: TextStyle(
            color: Color.lerp(inactive, active, progress[i]),
            fontWeight: progress[i] > 0.5 ? .bold : .normal,
          ),
        ),
    ];

    return Text.rich(
      TextSpan(children: spans),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
