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
      builder: (context, lyricsResult, _) {
        if (lyricsResult.isErr) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.noLyricsFound,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 18,
              ),
            ),
          );
        }
        final lines =
            lyricsResult
                .data
                ?.subsonicResponse
                ?.lyricsList
                ?.structuredLyrics
                ?.firstOrNull
                ?.line ??
            [];
        if (lines.isEmpty) {
          return Center(
            child: Text(
              AppLocalizations.of(context)!.noLyricsFound,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 18,
              ),
            ),
          );
        }
        return AnimatedLyricsPanel(
          lyricsLines: lines,
          textAlign: .left,
          crossAxisAlignment: .start,
          itemPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
          primaryFontSize: 32,
          secondaryFontSize: 22,
          blurFactor: 1.8,
          activeScaleDelta: .08,
          firstScrollAlignment: .3,
          activeScrollAlignment: .3,
          activeAnimationDuration: const Duration(milliseconds: 600),
          itemAnimationDuration: const Duration(milliseconds: 500),
          edgeFadeTopStop: .15,
          edgeFadeBottomStop: .85,
        );
      },
    );
  }
}
