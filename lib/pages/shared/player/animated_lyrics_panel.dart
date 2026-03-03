import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:melo_trip/app_player/player.dart';
import 'package:melo_trip/helper/index.dart';
import 'package:melo_trip/model/response/lyrics/lyrics.dart';
import 'package:melo_trip/provider/app_player/app_player.dart';

class AnimatedLyricsPanel extends ConsumerStatefulWidget {
  const AnimatedLyricsPanel({
    super.key,
    required this.lyricsLines,
    this.textAlign = TextAlign.center,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.primaryFontSize = 20,
    this.secondaryFontSize = 14,
    this.blurFactor = 2,
    this.activeScaleDelta = .15,
    this.firstScrollAlignment = .5,
    this.activeScrollAlignment = .5,
    this.activeAnimationDuration = const Duration(milliseconds: 650),
    this.itemAnimationDuration = const Duration(milliseconds: 500),
    this.edgeFadeTopStop = .1,
    this.edgeFadeBottomStop = .85,
  });

  final List<Line> lyricsLines;
  final TextAlign textAlign;
  final CrossAxisAlignment crossAxisAlignment;
  final EdgeInsets itemPadding;
  final double primaryFontSize;
  final double secondaryFontSize;
  final double blurFactor;
  final double activeScaleDelta;
  final double firstScrollAlignment;
  final double activeScrollAlignment;
  final Duration activeAnimationDuration;
  final Duration itemAnimationDuration;
  final double edgeFadeTopStop;
  final double edgeFadeBottomStop;

  @override
  ConsumerState<AnimatedLyricsPanel> createState() => _AnimatedLyricsPanelState();
}

class _AnimatedLyricsPanelState extends ConsumerState<AnimatedLyricsPanel> {
  int _currentIndex = -1;
  StreamSubscription<Duration>? _positionStream;

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
      _scrollLyrics(position: position);
    });
  }

  void _scrollLyrics({required Duration position}) {
    final currentLineIdx = indexOfLyrics(
      sortedLyrics: widget.lyricsLines,
      position: position,
    );
    if (_currentIndex == currentLineIdx) return;

    final animateDuration = _currentIndex == -1
        ? Duration.zero
        : widget.activeAnimationDuration;

    setState(() {
      _currentIndex = currentLineIdx;
    });

    final start = widget.lyricsLines[currentLineIdx].start;
    if (start == null) return;
    final gContext = GlobalObjectKey(start).currentContext;
    if (gContext == null || !context.mounted) return;
    Scrollable.ensureVisible(
      gContext,
      alignment:
          _currentIndex == -1
              ? widget.firstScrollAlignment
              : widget.activeScrollAlignment,
      duration: animateDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return LayoutBuilder(
      builder:
          (context, constraints) => ShaderMask(
            shaderCallback:
                (bounds) => LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [
                    0,
                    widget.edgeFadeTopStop,
                    widget.edgeFadeBottomStop,
                    1,
                  ],
                ).createShader(bounds),
            blendMode: BlendMode.dstIn,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight / 2),
                  ..._items(colorScheme),
                  SizedBox(height: constraints.maxHeight / 2),
                ],
              ),
            ),
          ),
    );
  }

  List<Widget> _items(ColorScheme colorScheme) {
    return List.generate(widget.lyricsLines.length, (idx) {
      final line = widget.lyricsLines[idx];
      final values = line.value ?? [];
      if (values.isEmpty) {
        return SizedBox.shrink(key: GlobalObjectKey(line.start ?? ''));
      }
      return _AnimatedLyricsItem(
        key: GlobalObjectKey(line.start ?? ''),
        line: line,
        isActive: _currentIndex == idx,
        colorScheme: colorScheme,
        textAlign: widget.textAlign,
        itemPadding: widget.itemPadding,
        primaryFontSize: widget.primaryFontSize,
        secondaryFontSize: widget.secondaryFontSize,
        blurFactor: widget.blurFactor,
        activeScaleDelta: widget.activeScaleDelta,
        itemAnimationDuration: widget.itemAnimationDuration,
      );
    });
  }
}

class _AnimatedLyricsItem extends StatelessWidget {
  const _AnimatedLyricsItem({
    super.key,
    required this.line,
    required this.isActive,
    required this.colorScheme,
    required this.textAlign,
    required this.itemPadding,
    required this.primaryFontSize,
    required this.secondaryFontSize,
    required this.blurFactor,
    required this.activeScaleDelta,
    required this.itemAnimationDuration,
  });

  final Line line;
  final bool isActive;
  final ColorScheme colorScheme;
  final TextAlign textAlign;
  final EdgeInsets itemPadding;
  final double primaryFontSize;
  final double secondaryFontSize;
  final double blurFactor;
  final double activeScaleDelta;
  final Duration itemAnimationDuration;

  @override
  Widget build(BuildContext context) {
    final values = line.value ?? [];
    if (values.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: itemPadding,
      child: Column(
        children: [
          for (final (i, text) in values.indexed)
            TweenAnimationBuilder<double>(
              duration: itemAnimationDuration,
              curve: Curves.easeOutCubic,
              tween: Tween(end: isActive ? 1 : 0),
              builder: (context, value, _) {
                final sigma = blurFactor * (1 - value);
                final scale = 1 + (activeScaleDelta * value);

                Widget content = Text(
                  text,
                  textAlign: textAlign,
                  style: TextStyle(
                    fontSize: i == 0 ? primaryFontSize : secondaryFontSize,
                    height: 1.5,
                    color: Color.lerp(
                      colorScheme.onSurfaceVariant.withValues(alpha: .5),
                      colorScheme.primary,
                      value,
                    ),
                    fontWeight: value > .5 ? FontWeight.bold : FontWeight.normal,
                  ),
                );

                if (value < .99) {
                  content = ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                    child: content,
                  );
                }
                return Transform.scale(scale: scale, child: content);
              },
            ),
        ],
      ),
    );
  }
}

