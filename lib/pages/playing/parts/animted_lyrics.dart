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
    final player = await ref.read(appPlayerHandlerProvider.future);
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
                final lyric =
                    lyrics
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
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: constraints.maxHeight / 2),
                      ..._items(_lyric),
                      SizedBox(height: constraints.maxHeight / 2),
                    ],
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
      final value = lines[idx].value ?? '';
      if (value == '') {
        return SizedBox.shrink(key: GlobalObjectKey(lines[idx].start ?? ''));
      }
      return ListTile(
        key: GlobalObjectKey(lines[idx].start ?? ''),
        title: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 400),
          style: TextStyle(
            fontSize: _currentIndex == idx ? 18 : 15,
            color:
                _currentIndex == idx
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight:
                _currentIndex == idx ? FontWeight.bold : FontWeight.normal,
          ),
          child: Text(value, textAlign: TextAlign.center),
        ),
      );
    });
  }
}
