part of '../playing_page.dart';

class _AnimtedLyrics extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlayQueueBuilder(
    builder: (context, playQueue, _) {
      final playQueueIndex = playQueue.index;
      final songs = playQueue.songs;
      if (playQueueIndex >= songs.length) {
        return Center(child: Text(AppLocalizations.of(context)!.noLyricsFound));
      }
      final current = playQueue.songs[playQueue.index];
      final effectiveCurrentId = current.id;
      if (effectiveCurrentId == null) {
        return Center(child: Text(AppLocalizations.of(context)!.noLyricsFound));
      }
      return AsyncValueBuilder(
        provider: lyricsProvider(effectiveCurrentId),
        builder: (context, subsonicLyrics, _) {
          final lines =
              subsonicLyrics
                  .subsonicResponse
                  ?.lyricsList
                  ?.structuredLyrics
                  ?.firstOrNull
                  ?.line ??
              [];
          if (lines.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noLyricsFound),
            );
          }
          return _PositionedLyrics(lyricsLines: lines);
        },
      );
    },
  );
}

class _PositionedLyrics extends ConsumerStatefulWidget {
  const _PositionedLyrics({required this.lyricsLines});

  final List<Line> lyricsLines;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PositionedLyricsState();
}

class _PositionedLyricsState extends ConsumerState<_PositionedLyrics> {
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
        : Duration(milliseconds: 650);
    setState(() {
      _currentIndex = currentLineIdx;
    });

    final start = widget.lyricsLines[currentLineIdx].start;
    if (start == null) return;
    final gContext = GlobalObjectKey(start).currentContext;
    if (gContext == null) return;
    if (!context.mounted) return;
    Scrollable.ensureVisible(
      gContext,
      alignment: 0.5,
      duration: animateDuration,
    );
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => ShaderMask(
      shaderCallback: (Rect bounds) => LinearGradient(
        begin: .topCenter,
        end: .bottomCenter,
        // 这里的 colors 和 stops 是核心
        colors: [
          Colors.transparent, // 顶部起始点：完全透明
          Colors.black, // 顶部淡入结束点：完全不透明
          Colors.black, // 底部淡出开始点：完全不透明
          Colors.transparent, // 底部终点：完全透明
        ],
        stops: const [
          0.0, // 0% 的位置透明
          0.1, // 10% 的位置开始完全显示（你可以根据需要调整这个比例）
          0.85, // 85% 的位置开始淡出
          1.0, // 100% 的位置完全消失
        ],
      ).createShader(bounds),
      // blendMode 必须设为 dstIn，表示只保留渐变色遮盖部分的颜色
      blendMode: .dstIn,
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: constraints.maxHeight / 2),
            ..._items(widget.lyricsLines),
            SizedBox(height: constraints.maxHeight / 2),
          ],
        ),
      ),
    ),
  );

  List<Widget> _items(List<Line> lines) {
    return List.generate(lines.length, (idx) {
      final value = lines[idx].value ?? [];
      if (value.isEmpty) {
        return SizedBox.shrink(key: GlobalObjectKey(lines[idx].start ?? ''));
      }

      final line = lines[idx];
      return _LyricItem(
        key: GlobalObjectKey(line.start ?? ''),
        line: line,
        isActive: _currentIndex == idx,
      );
    });
  }
}

class _LyricItem extends StatelessWidget {
  final Line line;
  final bool isActive;

  const _LyricItem({super.key, required this.line, required this.isActive});

  @override
  Widget build(BuildContext context) {
    final values = line.value ?? [];
    if (values.isEmpty) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        children: [
          for (final (i, text) in values.indexed)
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              tween: Tween(end: isActive ? 1.0 : 0.0),
              builder: (context, value, _) {
                // 优化模糊算法，sigma 过大会非常吃资源
                final sigma = 2.0 * (1.0 - value);
                final scale = 1.0 + (0.15 * value); // 稍微缩放即可，0.2 有点大

                Widget content = Text(
                  text,
                  textAlign: .center,
                  style: TextStyle(
                    fontSize: i == 0 ? 20 : 14,
                    height: 1.5,
                    color: Color.lerp(
                      colorScheme.onSurfaceVariant.withAlpha(127),
                      colorScheme.primary,
                      value,
                    ),
                    fontWeight: value > 0.5
                        ? .bold
                        : .normal,
                  ),
                );

                // 仅在需要模糊时应用滤镜，节省性能
                if (value < 0.99) {
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
