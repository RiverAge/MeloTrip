part of '../playing_page.dart';

class _AnimtedLyrics extends ConsumerStatefulWidget {
  const _AnimtedLyrics();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AnimtedLyricsState();
}

class _AnimtedLyricsState extends ConsumerState<_AnimtedLyrics> {
  List<Line> _lyric = [];
  int _currentIndex = -1;
  StreamSubscription<Duration>? _positionStream;

  @override
  void initState() {
    super.initState();
    _setPositionListner();
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  void _setPositionListner() async {
    if (_positionStream != null) return;
    final player = await ref.read(appPlayerHandlerProvider.future);
    if (!mounted) return;
    _positionStream = player?.positionStream.listen((position) {
      int currentLineIdx = _lyric.indexWhere(
        (e) => (e.start ?? -1) > position.inMilliseconds,
      );
      if (currentLineIdx == -1) return;
      currentLineIdx = (currentLineIdx == 0 ? 1 : currentLineIdx) - 1;
      if (_currentIndex == currentLineIdx) return;
      setState(() {
        _currentIndex = currentLineIdx;
      });

      final start = _lyric[currentLineIdx].start;
      if (start == null) return;
      final gContext = GlobalObjectKey(start).currentContext;
      if (gContext == null) return;
      if (!context.mounted) return;
      Scrollable.ensureVisible(
        gContext,
        alignment: 0.5,
        duration: const Duration(milliseconds: 650),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return PlayQueueBuilder(
          builder: (context, playQueue, ref) {
            if (playQueue.index >= playQueue.songs.length) {
              return Center(
                child: Text(AppLocalizations.of(context)!.noLyricsFound),
              );
            }

            final current = playQueue.songs[playQueue.index];
            return AsyncValueBuilder(
              provider: lyricsProvider(current.id),
              builder: (p0, lyrics, ref) {
                final lyric = lyrics
                    .subsonicResponse
                    ?.lyricsList
                    ?.structuredLyrics
                    ?.first;
                final lyricLine = lyric?.line;
                if (lyric == null ||
                    lyricLine == null ||
                    lyricLine.isEmpty == true) {
                  return Center(
                    child: Text(AppLocalizations.of(context)!.noLyricsFound),
                  );
                }
                _lyric = lyricLine;
                return ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
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
                    ).createShader(bounds);
                  },
                  // blendMode 必须设为 dstIn，表示只保留渐变色遮盖部分的颜色
                  blendMode: BlendMode.dstIn,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: constraints.maxHeight / 2),
                        ..._items(_lyric),
                        SizedBox(height: constraints.maxHeight / 2),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  List<Widget> _items(List<Line> lines) {
    return List.generate(lines.length, (idx) {
      final value = lines[idx].value ?? [];
      if (value.isEmpty) {
        return SizedBox.shrink(key: GlobalObjectKey(lines[idx].start ?? ''));
      }

      final line = _lyric[idx];
      return _LyricItem(
        key: GlobalObjectKey(lines[idx].start ?? ''),
        line: line,
        isActive: _currentIndex == idx,
      );

      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18),
        child: ListTile(
          key: GlobalObjectKey(lines[idx].start ?? ''),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (final (index, line) in value.indexed)
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(
                    begin: 0,
                    end: _currentIndex == idx ? 1 : 0,
                  ),
                  builder: (context, value, child) {
                    final sigma = 0.8 * (1 - value);
                    final scale = 1 + 0.2 * value;
                    return ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: sigma,
                        sigmaY: sigma,
                      ),
                      child: Transform.scale(
                        scale: scale,
                        child: Text(
                          textAlign: TextAlign.center,
                          line,
                          style: TextStyle(
                            fontSize: index == 0 ? 16 : 12,
                            color: _currentIndex == idx
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                            fontWeight: _currentIndex == idx
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
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
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: i == 0 ? 20 : 14,
                    height: 1.5,
                    color: Color.lerp(
                      colorScheme.onSurfaceVariant.withAlpha(127),
                      colorScheme.primary,
                      value,
                    ),
                    fontWeight: value > 0.5
                        ? FontWeight.bold
                        : FontWeight.normal,
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
