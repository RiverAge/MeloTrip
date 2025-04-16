part of '../playing_page.dart';

class _CoverBackground extends StatelessWidget {
  const _CoverBackground();
  @override
  Widget build(BuildContext context) => Positioned.fill(
    child: PlayQueueBuilder(
      builder: (context, playQueue, ref) {
        if (playQueue.index >= playQueue.songs.length) {
          return SizedBox.shrink();
        }
        final current = playQueue.songs[playQueue.index];
        return ArtworkImage(fit: BoxFit.cover, id: 'mf-${current.id}');
      },
    ),
  );
}
