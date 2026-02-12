part of '../playing_page.dart';

class _RoundedCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        if (playQueue.index >= playQueue.songs.length) {
          return SizedBox.shrink();
        }

        final current = playQueue.songs[playQueue.index];
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.08),
              child: AspectRatio(
                aspectRatio: 1 / 1, // 强制保持 1:1 正方形
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ArtworkImage(
                    id: 'mf-${current.id}',
                    fit: BoxFit.cover,
                    size: 5000,
                  ),
                ),
              ),
            ),

            SizedBox(height: 8),
            _MediaMeta(),
            SizedBox(height: 16),
            AsyncValueBuilder(
              provider: lyricsProvider(current.id),
              loading: (_, _) => const SizedBox.shrink(),
              builder: (_, lyrics, _) {
                final structuredLyrics =
                    lyrics.subsonicResponse?.lyricsList?.structuredLyrics;
                if (structuredLyrics == null || structuredLyrics.isEmpty) {
                  return SizedBox.shrink();
                }
                final lyricsLines = structuredLyrics[0].line;
                if (lyricsLines == null) {
                  return SizedBox.shrink();
                }

                return SingleLineAnimatedLyrics(
                  lyricsLines: lyricsLines,
                  crossAxisAlignment: CrossAxisAlignment.center,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
