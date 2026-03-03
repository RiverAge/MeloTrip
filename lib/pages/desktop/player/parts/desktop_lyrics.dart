part of '../full_player_page.dart';

class _DesktopLyrics extends ConsumerWidget {
  const _DesktopLyrics({required this.songId});

  final String? songId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    if (songId == null) return const SizedBox.shrink();

    return AsyncValueBuilder(
      provider: lyricsProvider(songId!),
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
            child: Text(
              AppLocalizations.of(context)!.noLyricsFound,
              style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 18),
            ),
          );
        }
        return _PositionedLyrics(lyricsLines: lines);
      },
    );
  }
}

class _PositionedLyrics extends ConsumerStatefulWidget {
  const _PositionedLyrics({required this.lyricsLines});

  final List<Line> lyricsLines;

  @override
  ConsumerState<_PositionedLyrics> createState() => _PositionedLyricsState();
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

    if (mounted) {
      setState(() {
        _currentIndex = currentLineIdx;
      });

      final start = widget.lyricsLines[currentLineIdx].start;
      if (start == null) return;
      final gContext = GlobalObjectKey(start).currentContext;
      if (gContext != null && context.mounted) {
        Scrollable.ensureVisible(
          gContext,
          alignment: 0.3,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ShaderMask(
      shaderCallback: (Rect bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          colorScheme.scrim.withValues(alpha: 0),
          colorScheme.scrim,
          colorScheme.scrim,
          colorScheme.scrim.withValues(alpha: 0),
        ],
        stops: [0.0, 0.15, 0.85, 1.0],
      ).createShader(bounds),
      blendMode: BlendMode.dstIn,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 200),
        itemCount: widget.lyricsLines.length,
        itemBuilder: (context, index) {
          final line = widget.lyricsLines[index];
          final isActive = _currentIndex == index;
          return _LyricItemHorizontal(
            key: GlobalObjectKey(line.start ?? '$index'),
            line: line,
            isActive: isActive,
          );
        },
      ),
    );
  }
}
