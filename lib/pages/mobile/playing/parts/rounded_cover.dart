part of '../playing_page.dart';

class _RoundedCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        if (playQueue.index >= playQueue.songs.length) {
          return const SizedBox.shrink();
        }

        final current = playQueue.songs[playQueue.index];
        return Column(
          children: [
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.08),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ArtworkImage(
                    id: 'mf-${current.id}',
                    fit: .cover,
                    size: 5000,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            _MediaMeta(),
            const SizedBox(height: 10),
            AsyncValueBuilder(
              provider: lyricsProvider(current.id),
              loading: (_, _) => const SizedBox.shrink(),
              builder: (_, lyricsResult, _) {
                if (lyricsResult.isErr) {
                  return const SizedBox.shrink();
                }
                final structured = lyricsResult
                    .data
                    ?.subsonicResponse
                    ?.lyricsList
                    ?.structuredLyrics
                    ?.firstOrNull;
                final lyricsLines = structured?.line;
                // 始终预留固定高度，避免歌词从无到有加载时封面被 Spacer 顶上去。
                return SizedBox(
                  height: 40,
                  child: lyricsLines == null
                      ? const SizedBox.shrink()
                      : SingleLineAnimatedLyrics(
                          lyricsLines: lyricsLines,
                          cueLinesByStart: cueLinesByStart(structured),
                          crossAxisAlignment: .center,
                        ),
                );
              },
            ),
            const Spacer(),
          ],
        );
      },
    );
  }
}
