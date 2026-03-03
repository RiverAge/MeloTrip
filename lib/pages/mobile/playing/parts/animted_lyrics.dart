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
          return AnimatedLyricsPanel(
            lyricsLines: lines,
            textAlign: .center,
            crossAxisAlignment: .center,
            itemPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            primaryFontSize: 20,
            secondaryFontSize: 14,
            blurFactor: 2,
            activeScaleDelta: .15,
            firstScrollAlignment: .5,
            activeScrollAlignment: .5,
            activeAnimationDuration: const Duration(milliseconds: 650),
            itemAnimationDuration: const Duration(milliseconds: 500),
            edgeFadeTopStop: .1,
            edgeFadeBottomStop: .85,
          );
        },
      );
    },
  );
}